import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:querosermb/features/detail_exchanges/domain/entities/exchange_asset.dart';
import 'package:querosermb/features/detail_exchanges/domain/usecases/get_exchange_assets.dart';
import 'package:querosermb/features/detail_exchanges/presentation/bloc/exchange_assets_state.dart';
import 'package:querosermb/features/detail_exchanges/presentation/cubit/exchange_assets_cubit.dart';

class MockGetExchangeAssets extends Mock implements GetExchangeAssets {}

void main() {
  late ExchangeAssetsCubit cubit;
  late MockGetExchangeAssets mockGetExchangeAssets;

  setUp(() {
    mockGetExchangeAssets = MockGetExchangeAssets();
    cubit = ExchangeAssetsCubit(getExchangeAssets: mockGetExchangeAssets);
  });

  tearDown(() {
    cubit.close();
  });

  group('ExchangeAssetsCubit', () {
    const tExchangeId = 1;
    const tAssets = [
      ExchangeAsset(
        walletAddress: '1A1zP1eP5QGefi2DMPTfTL5SLmv7DivfNa',
        balance: 1.5,
        platform: Platform(cryptoId: 1, symbol: 'BTC', name: 'Bitcoin'),
        currency: AssetCurrency(
          cryptoId: 1,
          priceUsd: 50000.0,
          symbol: 'BTC',
          name: 'Bitcoin',
        ),
      ),
      ExchangeAsset(
        walletAddress: '0x742d35Cc6634C0532925a3b8D4cb38a48D5639F0',
        balance: 10.0,
        platform: Platform(cryptoId: 1027, symbol: 'ETH', name: 'Ethereum'),
        currency: AssetCurrency(
          cryptoId: 1027,
          priceUsd: 3000.0,
          symbol: 'ETH',
          name: 'Ethereum',
        ),
      ),
    ];

    test('initial state is ExchangeAssetsInitial', () {
      expect(cubit.state, equals(ExchangeAssetsInitial()));
    });

    group('loadAssets', () {
      blocTest<ExchangeAssetsCubit, ExchangeAssetsState>(
        'emits [ExchangeAssetsLoading, ExchangeAssetsLoaded] when successful',
        build: () {
          when(() => mockGetExchangeAssets(any()))
              .thenAnswer((_) async => tAssets);
          return cubit;
        },
        act: (cubit) => cubit.loadAssets(tExchangeId),
        expect: () => [
          ExchangeAssetsLoading(),
          ExchangeAssetsLoaded(tAssets),
        ],
        verify: (_) {
          verify(() => mockGetExchangeAssets(tExchangeId)).called(1);
        },
      );

      blocTest<ExchangeAssetsCubit, ExchangeAssetsState>(
        'emits [ExchangeAssetsLoading, ExchangeAssetsEmpty] when no assets found',
        build: () {
          when(() => mockGetExchangeAssets(any()))
              .thenAnswer((_) async => []);
          return cubit;
        },
        act: (cubit) => cubit.loadAssets(tExchangeId),
        expect: () => [
          ExchangeAssetsLoading(),
          ExchangeAssetsEmpty(),
        ],
        verify: (_) {
          verify(() => mockGetExchangeAssets(tExchangeId)).called(1);
        },
      );

      blocTest<ExchangeAssetsCubit, ExchangeAssetsState>(
        'emits [ExchangeAssetsLoading, ExchangeAssetsError] when get assets fails',
        build: () {
          when(() => mockGetExchangeAssets(any()))
              .thenThrow(Exception('Network error'));
          return cubit;
        },
        act: (cubit) => cubit.loadAssets(tExchangeId),
        expect: () => [
          ExchangeAssetsLoading(),
          ExchangeAssetsError('Exception: Network error'),
        ],
        verify: (_) {
          verify(() => mockGetExchangeAssets(tExchangeId)).called(1);
        },
      );
    });

    group('refreshAssets', () {
      blocTest<ExchangeAssetsCubit, ExchangeAssetsState>(
        'emits [ExchangeAssetsLoaded] when refresh successful',
        build: () {
          when(() => mockGetExchangeAssets(any()))
              .thenAnswer((_) async => tAssets);
          return cubit;
        },
        seed: () => ExchangeAssetsEmpty(), // Start from empty state
        act: (cubit) => cubit.refreshAssets(tExchangeId),
        expect: () => [
          ExchangeAssetsLoaded(tAssets),
        ],
        verify: (_) {
          verify(() => mockGetExchangeAssets(tExchangeId)).called(1);
        },
      );

      blocTest<ExchangeAssetsCubit, ExchangeAssetsState>(
        'emits [ExchangeAssetsEmpty] when refresh returns empty list',
        build: () {
          when(() => mockGetExchangeAssets(any()))
              .thenAnswer((_) async => []);
          return cubit;
        },
        seed: () => ExchangeAssetsLoaded(tAssets),
        act: (cubit) => cubit.refreshAssets(tExchangeId),
        expect: () => [
          ExchangeAssetsEmpty(),
        ],
        verify: (_) {
          verify(() => mockGetExchangeAssets(tExchangeId)).called(1);
        },
      );

      blocTest<ExchangeAssetsCubit, ExchangeAssetsState>(
        'emits [ExchangeAssetsError] when refresh fails',
        build: () {
          when(() => mockGetExchangeAssets(any()))
              .thenThrow(Exception('Network error'));
          return cubit;
        },
        seed: () => ExchangeAssetsLoaded(tAssets),
        act: (cubit) => cubit.refreshAssets(tExchangeId),
        expect: () => [
          ExchangeAssetsError('Exception: Network error'),
        ],
        verify: (_) {
          verify(() => mockGetExchangeAssets(tExchangeId)).called(1);
        },
      );
    });

    group('reset', () {
      blocTest<ExchangeAssetsCubit, ExchangeAssetsState>(
        'emits [ExchangeAssetsInitial] when reset is called',
        build: () => cubit,
        seed: () => ExchangeAssetsLoaded(tAssets),
        act: (cubit) => cubit.reset(),
        expect: () => [
          ExchangeAssetsInitial(),
        ],
      );

      blocTest<ExchangeAssetsCubit, ExchangeAssetsState>(
        'emits [ExchangeAssetsInitial] when reset is called from error state',
        build: () => cubit,
        seed: () => ExchangeAssetsError('Some error'),
        act: (cubit) => cubit.reset(),
        expect: () => [
          ExchangeAssetsInitial(),
        ],
      );
    });
  });
}
