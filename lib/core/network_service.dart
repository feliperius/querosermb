import 'package:dio/dio.dart';

class NetworkService {
  final Dio _dio;
  final String _apiKey;
  DateTime? _lastRequestTime;
  static const Duration _minRequestInterval = Duration(milliseconds: 1100);

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
    if (_lastRequestTime != null) {
      final timeSinceLastRequest = DateTime.now().difference(_lastRequestTime!);
      if (timeSinceLastRequest < _minRequestInterval) {
        final waitTime = _minRequestInterval - timeSinceLastRequest;
        await Future.delayed(waitTime);
      }
    }
    _lastRequestTime = DateTime.now();
  }

  Future<Response> get(
    String url, {
    Map<String, dynamic>? queryParameters,
    int maxRetries = 3,
  }) async {
    for (int attempt = 0; attempt <= maxRetries; attempt++) {
      try {
        await _enforceRateLimit();
        return await _dio.get(url, queryParameters: queryParameters);
      } on DioException catch (e) {
        final exception = _handleDioError(e);
        
        if (attempt < maxRetries && _shouldRetry(e)) {
          final backoffDelay = Duration(seconds: (attempt + 1) * 2);
          await Future.delayed(backoffDelay);
          continue;
        }
        
        throw exception;
      }
    }
    
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
        return await _dio.post(
          url,
          data: data,
          queryParameters: queryParameters,
        );
      } on DioException catch (e) {
        final exception = _handleDioError(e);
        
        if (attempt < maxRetries && _shouldRetry(e)) {
          final backoffDelay = Duration(seconds: (attempt + 1) * 2);
          await Future.delayed(backoffDelay);
          continue;
        }
        
        throw exception;
      }
    }
    
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
        return Exception('Bad response: ${statusCode}');
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
