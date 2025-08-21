import 'package:dio/dio.dart';
import 'api_cache_service.dart';

class NetworkService {
  final Dio _dio;
  final String _apiKey;
  DateTime? _lastRequestTime;
  static const Duration _minRequestInterval = Duration(milliseconds: 2000);
  static const int _maxConcurrentRequests = 2;
  int _activeRequests = 0;
  final ApiCacheService _cache = ApiCacheService();

  NetworkService({
    required Dio dio,
    required String apiKey,
  }) : _dio = dio, _apiKey = apiKey {
    _dio.options.headers.addAll({
      'X-CMC_PRO_API_KEY': _apiKey,
      'Accept': 'application/json',
    });
    
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      requestHeader: false,
      responseHeader: false,
    ));
  }

  Future<void> _enforceRateLimit() async {
    // Wait if we have too many concurrent requests
    while (_activeRequests >= _maxConcurrentRequests) {
      await Future.delayed(Duration(milliseconds: 500));
    }
    
    if (_lastRequestTime != null) {
      final timeSinceLastRequest = DateTime.now().difference(_lastRequestTime!);
      if (timeSinceLastRequest < _minRequestInterval) {
        final waitTime = _minRequestInterval - timeSinceLastRequest;
        await Future.delayed(waitTime);
      }
    }
    _lastRequestTime = DateTime.now();
    _activeRequests++;
  }

  void _releaseRequest() {
    if (_activeRequests > 0) {
      _activeRequests--;
    }
  }

  Future<Response> get(
    String url, {
    Map<String, dynamic>? queryParameters,
    int maxRetries = 3,
    bool useCache = true,
  }) async {
    // Check cache first
    if (useCache) {
      final cachedResponse = _cache.get<Map<String, dynamic>>(
        url, 
        params: queryParameters,
      );
      if (cachedResponse != null) {
        return Response(
          requestOptions: RequestOptions(path: url),
          data: cachedResponse,
          statusCode: 200,
        );
      }
    }

    for (int attempt = 0; attempt <= maxRetries; attempt++) {
      try {
        await _enforceRateLimit();
        final response = await _dio.get(url, queryParameters: queryParameters);
        _releaseRequest();
        
        // Cache successful response
        if (useCache && response.statusCode == 200 && response.data != null) {
          _cache.set(
            url,
            response.data,
            params: queryParameters,
            cacheDuration: Duration(minutes: 5),
          );
        }
        
        return response;
      } on DioException catch (e) {
        _releaseRequest();
        final exception = _handleDioError(e);
        
        // Cache rate limit errors for longer
        if (e.response?.statusCode == 429) {
          _cache.set(
            url,
            {'error': 'rate_limited'},
            params: queryParameters,
            isRateLimited: true,
          );
        }
        
        if (attempt < maxRetries && _shouldRetry(e)) {
          final backoffDelay = Duration(seconds: (attempt + 1) * 3);
          await Future.delayed(backoffDelay);
          continue;
        }
        
        throw exception;
      } catch (e) {
        _releaseRequest();
        rethrow;
      }
    }
    
    _releaseRequest();
    throw Exception('Max retries exceeded');
  }

  Future<Response> post(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    int maxRetries = 3,
  }) async {
    for (int attempt = 0; attempt <= maxRetries; attempt++) {
      try {
        await _enforceRateLimit();
        final response = await _dio.post(
          url,
          data: data,
          queryParameters: queryParameters,
        );
        _releaseRequest();
        return response;
      } on DioException catch (e) {
        _releaseRequest();
        final exception = _handleDioError(e);
        
        if (attempt < maxRetries && _shouldRetry(e)) {
          final backoffDelay = Duration(seconds: (attempt + 1) * 3);
          await Future.delayed(backoffDelay);
          continue;
        }
        
        throw exception;
      } catch (e) {
        _releaseRequest();
        rethrow;
      }
    }
    
    _releaseRequest();
    throw Exception('Max retries exceeded');
  }

  bool _shouldRetry(DioException e) {
    final statusCode = e.response?.statusCode;
    final responseData = e.response?.data;
    
    if (statusCode != null && responseData is Map<String, dynamic>) {
      final status = responseData['status'];
      final errorCode = status?['error_code'];
      
      return errorCode == 1008 || statusCode == 429 || statusCode >= 500;
    }
    
    return e.type == DioExceptionType.connectionTimeout ||
           e.type == DioExceptionType.receiveTimeout ||
           e.type == DioExceptionType.connectionError;
  }

  Exception _handleDioError(DioException e) {
    final statusCode = e.response?.statusCode;
    final responseData = e.response?.data;
    
    if (statusCode != null && responseData is Map<String, dynamic>) {
      final status = responseData['status'];
      final errorCode = status?['error_code'];
      final errorMessage = status?['error_message'];
      
      switch (errorCode) {
        case 1001:
          return Exception('API Key Invalid: This API Key is invalid.');
        case 1002:
          return Exception('API Key Missing: API key missing.');
        case 1003:
          return Exception('Payment Required: Your API Key must be activated. Please go to pro.coinmarketcap.com/account/plan.');
        case 1004:
          return Exception('Payment Expired: Your API Key\'s subscription plan has expired.');
        case 1005:
          return Exception('API Key Required: An API Key is required for this call.');
        case 1006:
          return Exception('Plan Not Authorized: Your API Key subscription plan doesn\'t support this endpoint.');
        case 1007:
          return Exception('API Key Disabled: This API Key has been disabled. Please contact support.');
        case 1008:
          return Exception('Rate Limit: You\'ve exceeded your API Key\'s HTTP request rate limit. Rate limits reset every minute.');
        case 1009:
          return Exception('Daily Rate Limit: You\'ve exceeded your API Key\'s daily rate limit.');
        case 1010:
          return Exception('Monthly Rate Limit: You\'ve exceeded your API Key\'s monthly rate limit.');
        case 1011:
          return Exception('IP Rate Limit: You\'ve hit an IP rate limit.');
        default:
          if (errorMessage != null) {
            return Exception('API Error ($errorCode): $errorMessage');
          }
      }
    }

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return Exception('Connection timeout');
      case DioExceptionType.sendTimeout:
        return Exception('Send timeout');
      case DioExceptionType.receiveTimeout:
        return Exception('Receive timeout');
      case DioExceptionType.badResponse:
        if (statusCode == 401) {
          return Exception('Unauthorized: Invalid API key');
        } else if (statusCode == 402) {
          return Exception('Payment Required: Check your API subscription');
        } else if (statusCode == 403) {
          return Exception('Forbidden: Access denied or endpoint not available');
        } else if (statusCode == 429) {
          return Exception('Too many requests: API rate limit exceeded');
        } else if (statusCode == 500) {
          return Exception('Internal server error');
        }
        return Exception('Bad response: $statusCode');
      case DioExceptionType.cancel:
        return Exception('Request cancelled');
      case DioExceptionType.connectionError:
        return Exception('Connection error: Check your internet connection');
      case DioExceptionType.unknown:
        return Exception('Unknown error: ${e.message}');
      default:
        return Exception('Network error: ${e.message}');
    }
  }
}
