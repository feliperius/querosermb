import '../entities/exchange.dart';
import '../repositories/exchange_repository.dart';

class GetExchangeById {
  final ExchangeRepository repository;

  GetExchangeById(this.repository);

  Future<Exchange> call(int id) async {
    return await repository.getExchangeById(id);
  }
}
