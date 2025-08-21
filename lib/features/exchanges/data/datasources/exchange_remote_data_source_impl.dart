import '../../../../core/network_service.dart';
import '../../../../core/api_urls.dart';
import '../../../../core/cache_service.dart';
import '../models/exchange_model.dart';
import 'exchange_remote_data_source.dart';

class ExchangeRemoteDataSourceImpl implements ExchangeRemoteDataSource {
  final NetworkService networkService;
  final CacheService _cacheService = CacheService();

  ExchangeRemoteDataSourceImpl({
    required this.networkService,
  });

  @override
  Future<List<ExchangeModel>> getExchanges({int start = 0, int limit = 10}) async {
    final cacheKey = 'exchanges_${start}_$limit';
    
    final cachedData = _cacheService.get<List<ExchangeModel>>(cacheKey);
    if (cachedData != null) {
      return cachedData;
    }

    try {
      final mapCacheKey = 'exchange_map';
      List<dynamic> data;
      
      final cachedMap = _cacheService.get<List<dynamic>>(mapCacheKey);
      if (cachedMap != null) {
        data = cachedMap;
      } else {
        final response = await networkService.get(ApiUrls.exchangeMap);
        data = response.data['data'];
        _cacheService.set(mapCacheKey, data, duration: const Duration(minutes: 10));
      }
      
      final List<ExchangeModel> exchanges = [];
      
      final paginatedData = data.skip(start).take(limit).toList();
      
      for (final exchangeData in paginatedData) {
        final exchangeId = exchangeData['id'] as int;
        
        try {
          await Future.delayed(const Duration(milliseconds: 500));
          
          final infoResponse = await networkService.get(
            ApiUrls.getExchangeInfoById(exchangeId),
          );
          
          final infoData = infoResponse.data['data'][exchangeId.toString()] as Map<String, dynamic>;
          exchanges.add(ExchangeModel.fromInfo(infoData));
        } catch (e) {
          exchanges.add(ExchangeModel(
            id: exchangeId,
            name: exchangeData['name'] ?? '',
            logo: null,
            spotVolumeUsd: null,
            dateLaunched: exchangeData['first_historical_data'],
            description: null,
            website: null,
            makerFee: null,
            takerFee: null,
            currencies: const [],
          ));
        }
      }
      
      _cacheService.set(cacheKey, exchanges, duration: const Duration(minutes: 5));
      return exchanges;
    } catch (e) {
      throw Exception('Failed to load exchanges: $e');
    }
  }

  @override
  Future<ExchangeModel> getExchangeById(int id) async {
    final cacheKey = 'exchange_$id';
    
    final cachedData = _cacheService.get<ExchangeModel>(cacheKey);
    if (cachedData != null) {
      return cachedData;
    }

    try {
      final infoResponse = await networkService.get(
        ApiUrls.getExchangeInfoById(id),
      );

      final infoData = infoResponse.data['data'][id.toString()] as Map<String, dynamic>;
      final exchange = ExchangeModel.fromInfo(infoData);
      
      _cacheService.set(cacheKey, exchange, duration: const Duration(minutes: 15));
      return exchange;
    } catch (e) {
      throw Exception('Failed to load exchange details: $e');
    }
  }
}
