import '../entities/exchange.dart';
import '../repositories/exchange_repository.dart';

class GetExchanges {
  final ExchangeRepository repository;

  GetExchanges(this.repository);

  Future<List<Exchange>> call() async {
    return await repository.getExchanges();
  }
}
