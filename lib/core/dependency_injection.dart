import 'package:dio/dio.dart';
import '../features/exchanges/data/datasources/exchange_remote_data_source.dart';
import '../features/exchanges/data/datasources/exchange_remote_data_source_impl.dart';
import '../features/exchanges/data/repositories/exchange_repository_impl.dart';
import '../features/exchanges/domain/repositories/exchange_repository.dart';
import '../features/exchanges/domain/usecases/get_exchanges.dart';
import '../features/exchanges/domain/usecases/get_exchange_by_id.dart';
import '../features/exchanges/presentation/bloc/exchange_bloc.dart';

class DependencyInjection {
  static const String _apiKey = '';

  static Dio get dio => Dio();

  static ExchangeRemoteDataSource get exchangeRemoteDataSource =>
      ExchangeRemoteDataSourceImpl(
        dio: dio,
        apiKey: _apiKey,
      );

  static ExchangeRepository get exchangeRepository =>
      ExchangeRepositoryImpl(
        remoteDataSource: exchangeRemoteDataSource,
      );

  static GetExchanges get getExchanges =>
      GetExchanges(exchangeRepository);

  static GetExchangeById get getExchangeById =>
      GetExchangeById(exchangeRepository);

  static ExchangeBloc get exchangeBloc => ExchangeBloc(
        getExchanges: getExchanges,
        getExchangeById: getExchangeById,
      );
}
