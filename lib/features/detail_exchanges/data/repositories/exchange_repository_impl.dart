import '../../../list_exchanges/domain/entities/exchange.dart';
import '../../../list_exchanges/domain/repositories/exchange_repository.dart';
import '../datasources/exchange_remote_data_source.dart';

class DetailExchangeRepositoryImpl implements ExchangeRepository {
  final DetailExchangeRemoteDataSource remoteDataSource;

  DetailExchangeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Exchange>> getExchanges({int start = 0, int limit = 20}) async {
    throw UnimplementedError('Detail repository does not support list operations');
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
