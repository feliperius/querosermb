import '../entities/exchange_asset.dart';
import '../repositories/exchange_asset_repository.dart';

class GetExchangeAssets {
  final ExchangeAssetRepository repository;

  GetExchangeAssets(this.repository);

  Future<List<ExchangeAsset>> call(int exchangeId) async {
    return await repository.getExchangeAssets(exchangeId);
  }
}
