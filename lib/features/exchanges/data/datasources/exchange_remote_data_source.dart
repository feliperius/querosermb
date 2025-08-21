import '../models/exchange_model.dart';

abstract class ExchangeRemoteDataSource {
  Future<List<ExchangeModel>> getExchanges({int start = 0, int limit = 20});
  Future<ExchangeModel> getExchangeById(int id);
}
