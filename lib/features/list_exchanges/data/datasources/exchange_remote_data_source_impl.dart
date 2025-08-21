import '../../../../core/network_service.dart';
import '../../../../core/api_urls.dart';
import '../../../../core/cache_service.dart';
import '../models/exchange_model.dart';
import 'exchange_remote_data_source.dart';

class ExchangeRemoteDataSourceImpl implements ExchangeRemoteDataSource {
  final NetworkService _networkService;
  final CacheService _cacheService;

  static const String _exchangeMapCacheKey = 'exchange_map';
  static const Duration _mapCacheDuration = Duration(minutes: 10);
  static const Duration _listCacheDuration = Duration(minutes: 5);
  static const Duration _detailCacheDuration = Duration(minutes: 15);

  ExchangeRemoteDataSourceImpl({
    required NetworkService networkService,
    CacheService? cacheService,
  })  : _networkService = networkService,
        _cacheService = cacheService ?? CacheService();

  @override
  Future<List<ExchangeModel>> getExchanges({int start = 0, int limit = 10}) async {
    final cacheKey = 'exchanges_${start}_$limit';
    
    final cachedData = _cacheService.get<List<ExchangeModel>>(cacheKey);
    if (cachedData != null) {
      return cachedData;
    }

    try {
      final exchangeMapData = await _getExchangeMapData();
      
      final exchanges = await _processExchangesBatch(
        exchangeMapData.skip(start).take(limit).toList(),
      );
      
      _cacheService.set(cacheKey, exchanges, duration: _listCacheDuration);
      return exchanges;
    } catch (e) {
      throw Exception('Failed to load exchanges: $e');
    }
  }

  Future<List<dynamic>> _getExchangeMapData() async {
    final cachedMap = _cacheService.get<List<dynamic>>(_exchangeMapCacheKey);
    if (cachedMap != null) {
      return cachedMap;
    }

    final response = await _networkService.get(ApiUrls.exchangeMap);
    final data = response.data['data'] as List<dynamic>;
    
    _cacheService.set(_exchangeMapCacheKey, data, duration: _mapCacheDuration);
    return data;
  }

  Future<List<ExchangeModel>> _processExchangesBatch(List<dynamic> exchangeDataList) async {
    final futures = exchangeDataList.map((exchangeData) => _processExchangeItem(exchangeData));
    return await Future.wait(futures);
  }

  Future<ExchangeModel> _processExchangeItem(Map<String, dynamic> exchangeData) async {
    final exchangeId = exchangeData['id'] as int;

    try {
      return await getExchangeById(exchangeId);
    } catch (_) {
      return _createBasicExchangeModel(exchangeData);
    }
  }

  ExchangeModel _createBasicExchangeModel(Map<String, dynamic> exchangeData) {
    return ExchangeModel(
      id: exchangeData['id'] as int,
      name: exchangeData['name'] as String? ?? '',
      logo: null,
      spotVolumeUsd: null,
      dateLaunched: exchangeData['first_historical_data'] as String?,
      description: null,
      website: null,
      makerFee: null,
      takerFee: null,
      currencies: const [],
    );
  }

  @override
  Future<ExchangeModel> getExchangeById(int id) async {
    final cacheKey = 'exchange_$id';
    
    final cachedData = _cacheService.get<ExchangeModel>(cacheKey);
    if (cachedData != null) return cachedData;

    try {
      final exchangeData = await _fetchExchangeInfo(id);

      final exchange = _buildExchangeModel(exchangeData);
      
      _cacheService.set(cacheKey, exchange, duration: _detailCacheDuration);
      return exchange;
    } catch (e) {
      throw Exception('Failed to load exchange info: $e');
    }
  }

  Future<Map<String, dynamic>> _fetchExchangeInfo(int id) async {
    final response = await _networkService.get(ApiUrls.getExchangeInfoById(id));
    final data = response.data['data'] as Map<String, dynamic>;
    return data[id.toString()] as Map<String, dynamic>;
  }


  CurrencyModel _buildCurrencyModel(dynamic asset) {
    return CurrencyModel(
      name: asset['name'] as String? ?? '',
      priceUsd: (asset['price_usd'] as num?)?.toDouble(),
    );
  }

  ExchangeModel _buildExchangeModel(
    Map<String, dynamic> infoData,
  ) {
    return ExchangeModel(
      id: infoData['id'] as int,
      name: infoData['name'] as String? ?? '',
      logo: infoData['logo'] as String?,
      spotVolumeUsd: (infoData['spot_volume_usd'] as num?)?.toDouble(),
      dateLaunched: infoData['date_launched'] as String?,
      description: infoData['description'] as String?,
      website: _extractWebsiteFromUrls(infoData['urls']),
      makerFee: (infoData['maker_fee'] as num?)?.toDouble(),
      takerFee: (infoData['taker_fee'] as num?)?.toDouble(),
    );
  }

  String? _extractWebsiteFromUrls(dynamic urls) {
    if (urls == null || (urls is Map && urls.isEmpty)) return null;
    
    final urlsMap = urls as Map<String, dynamic>;
    
    final website = urlsMap['website'];
    if (website != null) {
      return _extractStringFromUrlValue(website);
    }
    
    for (final value in urlsMap.values) {
      final extractedUrl = _extractStringFromUrlValue(value);
      if (extractedUrl != null && extractedUrl.isNotEmpty) {
        return extractedUrl;
      }
    }
    
    return null;
  }

  String? _extractStringFromUrlValue(dynamic value) {
    if (value == null) return null;
    
    if (value is String && value.isNotEmpty) {
      return value;
    }
    
    if (value is List && value.isNotEmpty) {
      final firstValue = value.first;
      return firstValue?.toString();
    }
    
    return value.toString().isEmpty ? null : value.toString();
  }
}
