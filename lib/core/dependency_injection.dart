import 'package:dio/dio.dart';
import 'package:querosermb/core/api_urls.dart';
import 'network_service.dart';
import '../features/exchanges/data/datasources/exchange_remote_data_source.dart';
import '../features/exchanges/data/datasources/exchange_remote_data_source_impl.dart';
import '../features/exchanges/data/repositories/exchange_repository_impl.dart';
import '../features/exchanges/domain/repositories/exchange_repository.dart';
import '../features/exchanges/domain/usecases/get_exchanges.dart';
import '../features/exchanges/domain/usecases/get_exchange_by_id.dart';
import '../features/exchanges/presentation/bloc/exchange_bloc.dart';

class DependencyInjection {

  static Dio get dio => Dio();

  static NetworkService get networkService => NetworkService(
        dio: dio,
        apiKey: ApiUrls.apiKey,
      );

  static ExchangeRemoteDataSource get exchangeRemoteDataSource =>
      ExchangeRemoteDataSourceImpl(
        networkService: networkService,
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
