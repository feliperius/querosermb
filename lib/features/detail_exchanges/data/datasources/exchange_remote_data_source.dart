import '../models/exchange_model.dart';

abstract class DetailExchangeRemoteDataSource {
  Future<ExchangeModel> getExchangeById(int id);
  Future<List<CurrencyModel>> getExchangeAssets(int exchangeId);
}
