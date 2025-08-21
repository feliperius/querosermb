import '../entities/exchange_asset.dart';

abstract class ExchangeAssetRepository {
  Future<List<ExchangeAsset>> getExchangeAssets(int exchangeId);
}
