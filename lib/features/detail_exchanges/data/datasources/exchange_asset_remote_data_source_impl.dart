import '../../../../core/network_service.dart';
import '../../../../core/api_urls.dart';
import '../models/exchange_asset_model.dart';
import 'exchange_asset_remote_data_source.dart';

class ExchangeAssetRemoteDataSourceImpl implements ExchangeAssetRemoteDataSource {
  final NetworkService _networkService;

  ExchangeAssetRemoteDataSourceImpl(this._networkService);

  @override
  Future<List<ExchangeAssetModel>> getExchangeAssets(int exchangeId) async {
    try {
      final response = await _networkService.get(
        ApiUrls.getExchangeAssetsById(exchangeId),
        useCache: true,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data;
        final List<dynamic> assetsData = data['data'] ?? [];
        
        return assetsData
            .map((asset) => ExchangeAssetModel.fromJson(asset as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to load exchange assets: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching exchange assets: $e');
    }
  }
}
