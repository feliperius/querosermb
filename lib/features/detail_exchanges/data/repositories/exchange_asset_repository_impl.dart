import '../../domain/entities/exchange_asset.dart';
import '../../domain/repositories/exchange_asset_repository.dart';
import '../datasources/exchange_asset_remote_data_source.dart';

class ExchangeAssetRepositoryImpl implements ExchangeAssetRepository {
  final ExchangeAssetRemoteDataSource remoteDataSource;

  ExchangeAssetRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<ExchangeAsset>> getExchangeAssets(int exchangeId) async {
    try {
      final assetsModels = await remoteDataSource.getExchangeAssets(exchangeId);
      return assetsModels.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to get exchange assets: $e');
    }
  }
}
