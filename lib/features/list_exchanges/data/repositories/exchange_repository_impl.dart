import '../../domain/entities/exchange.dart';
import '../../domain/repositories/exchange_repository.dart';
import '../datasources/exchange_remote_data_source.dart';

class ExchangeRepositoryImpl implements ExchangeRepository {
  final ExchangeRemoteDataSource remoteDataSource;

  ExchangeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Exchange>> getExchanges({int start = 0, int limit = 20}) async {
    try {
      final exchangeModels = await remoteDataSource.getExchanges(start: start, limit: limit);
      return exchangeModels.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to get exchanges: $e');
    }
  }

  @override
  Future<Exchange> getExchangeById(int id) async {
    try {
      final model = await remoteDataSource.getExchangeById(id);
      return model.toEntity();
    } catch (e) {
      throw Exception('Failed to get exchange by id: $e');
    }
  }
}
