import '../models/exchange_asset_model.dart';

abstract class ExchangeAssetRemoteDataSource {
  Future<List<ExchangeAssetModel>> getExchangeAssets(int exchangeId);
}
