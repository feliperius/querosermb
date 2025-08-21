import '../entities/exchange.dart';

abstract class ExchangeRepository {
  Future<List<Exchange>> getExchanges({int start = 0, int limit = 20});
  Future<Exchange> getExchangeById(int id);
}
