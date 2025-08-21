import '../../../../core/network_service.dart';
import '../../../../core/api_urls.dart';
import '../../../../core/cache_service.dart';
import '../models/exchange_model.dart';
import 'exchange_remote_data_source.dart';

class DetailExchangeRemoteDataSourceImpl implements DetailExchangeRemoteDataSource {
  final NetworkService networkService;
  final CacheService _cacheService = CacheService();

  DetailExchangeRemoteDataSourceImpl({required this.networkService});

  @override
  Future<ExchangeModel> getExchangeById(int id) async {
    final cacheKey = 'detail_exchange_$id';
    final cached = _cacheService.get<ExchangeModel>(cacheKey);
    if (cached != null) return cached;

    try {
      final infoResponse = await networkService.get(ApiUrls.getExchangeInfoById(id));
      final infoData = infoResponse.data['data'][id.toString()] as Map<String, dynamic>;

      List<CurrencyModel> currencies = [];
      try {
        currencies = await getExchangeAssets(id);
      } catch (_) {}

      final exchange = ExchangeModel.fromInfoWithAssets(infoData, currencies);
      _cacheService.set(cacheKey, exchange, duration: const Duration(minutes: 15));
      return exchange;
    } catch (e) {
      throw Exception('Failed to load exchange detail: $e');
    }
  }

  @override
  Future<List<CurrencyModel>> getExchangeAssets(int exchangeId) async {
    final cacheKey = 'detail_exchange_assets_$exchangeId';
    final cached = _cacheService.get<List<CurrencyModel>>(cacheKey);
    if (cached != null) return cached;

    try {
      final response = await networkService.get(ApiUrls.getExchangeAssetsById(exchangeId));
      final data = response.data['data'] as Map<String, dynamic>;
      final assets = data[exchangeId.toString()] as List<dynamic>;

      final currencies = assets.map((asset) => CurrencyModel(
        name: asset['name'] as String? ?? '',
        priceUsd: (asset['price_usd'] as num?)?.toDouble(),
      )).toList();

      _cacheService.set(cacheKey, currencies, duration: const Duration(minutes: 10));
      return currencies;
    } catch (e) {
      throw Exception('Failed to load exchange assets: $e');
    }
  }
}
