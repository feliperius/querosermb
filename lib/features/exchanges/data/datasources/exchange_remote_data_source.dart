import '../models/exchange_model.dart';

abstract class ExchangeRemoteDataSource {
  Future<List<ExchangeModel>> getExchanges();
  Future<ExchangeModel> getExchangeById(int id);
}
