import '../entities/exchange.dart';
import '../repositories/exchange_repository.dart';

class GetExchanges {
  final ExchangeRepository repository;

  GetExchanges(this.repository);

  Future<List<Exchange>> call({int start = 0, int limit = 20}) async {
    return await repository.getExchanges(start: start, limit: limit);
  }
}
