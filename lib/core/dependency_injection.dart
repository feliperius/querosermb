import 'package:dio/dio.dart';
import 'api_urls.dart';
import 'network_service.dart';
import '../features/list_exchanges/data/datasources/exchange_remote_data_source.dart';
import '../features/list_exchanges/data/datasources/exchange_remote_data_source_impl.dart';
import '../features/list_exchanges/data/repositories/exchange_repository_impl.dart';
import '../features/list_exchanges/domain/repositories/exchange_repository.dart';
import '../features/list_exchanges/domain/usecases/get_exchanges.dart';
import '../features/list_exchanges/domain/usecases/get_exchange_by_id.dart';
import '../features/list_exchanges/presentation/bloc/exchange_bloc.dart';
import '../features/detail_exchanges/presentation/bloc/detail_exchange_bloc.dart';
import '../features/detail_exchanges/data/datasources/exchange_remote_data_source_impl.dart' as detail_ds_impl;
import '../features/detail_exchanges/data/repositories/exchange_repository_impl.dart' as detail_repo_impl;
import '../features/detail_exchanges/data/datasources/exchange_asset_remote_data_source_impl.dart';
import '../features/detail_exchanges/data/repositories/exchange_asset_repository_impl.dart';
import '../features/detail_exchanges/domain/repositories/exchange_asset_repository.dart';
import '../features/detail_exchanges/domain/usecases/get_exchange_assets.dart';
import '../features/detail_exchanges/presentation/bloc/exchange_assets_bloc.dart';
import '../features/detail_exchanges/presentation/cubit/exchange_assets_cubit.dart';

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
      );

  static DetailExchangeBloc detailExchangeBloc(int id) => DetailExchangeBloc(
        getExchangeById: GetExchangeById(
          detail_repo_impl.DetailExchangeRepositoryImpl(
            remoteDataSource: detail_ds_impl.DetailExchangeRemoteDataSourceImpl(
              networkService: networkService,
            ),
          ),
        ),
      );

  // Exchange Assets dependencies
  static ExchangeAssetRemoteDataSourceImpl get exchangeAssetRemoteDataSource =>
      ExchangeAssetRemoteDataSourceImpl(networkService);

  static ExchangeAssetRepository get exchangeAssetRepository =>
      ExchangeAssetRepositoryImpl(exchangeAssetRemoteDataSource);

  static GetExchangeAssets get getExchangeAssets =>
      GetExchangeAssets(exchangeAssetRepository);

  static ExchangeAssetsBloc get exchangeAssetsBloc => ExchangeAssetsBloc(
        getExchangeAssets: getExchangeAssets,
      );

  static ExchangeAssetsCubit get exchangeAssetsCubit => ExchangeAssetsCubit(
        getExchangeAssets: getExchangeAssets,
      );
}
