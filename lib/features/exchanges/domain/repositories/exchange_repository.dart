import '../entities/exchange.dart';

abstract class ExchangeRepository {
  Future<List<Exchange>> getExchanges();
  Future<Exchange> getExchangeById(int id);
}
