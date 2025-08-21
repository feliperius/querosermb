import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:querosermb/features/list_exchanges/domain/entities/exchange.dart';
import 'package:querosermb/features/list_exchanges/domain/usecases/get_exchanges.dart';
import 'package:querosermb/features/list_exchanges/presentation/bloc/exchange_bloc.dart';
import 'package:querosermb/features/list_exchanges/presentation/bloc/exchange_event.dart';
import 'package:querosermb/features/list_exchanges/presentation/bloc/exchange_state.dart';

class MockGetExchanges extends Mock implements GetExchanges {}

void main() {
  late ExchangeBloc bloc;
  late MockGetExchanges mockGetExchanges;

  setUp(() {
    mockGetExchanges = MockGetExchanges();
    bloc = ExchangeBloc(getExchanges: mockGetExchanges);
  });

  tearDown(() {
    bloc.close();
  });

  group('ExchangeBloc', () {
    const tExchanges = [
      Exchange(
        id: 1,
        name: 'Binance',
        logo: 'https://example.com/binance.png',
        spotVolumeUsd: 1000000.0,
      ),
      Exchange(
        id: 2,
        name: 'Coinbase',
        logo: 'https://example.com/coinbase.png',
        spotVolumeUsd: 500000.0,
      ),
    ];

    const tMoreExchanges = [
      Exchange(
        id: 3,
        name: 'Kraken',
        logo: 'https://example.com/kraken.png',
        spotVolumeUsd: 300000.0,
      ),
    ];

    test('initial state is ExchangeInitial', () {
      expect(bloc.state, equals(ExchangeInitial()));
    });

    group('LoadExchanges', () {
      blocTest<ExchangeBloc, ExchangeState>(
        'emits [ExchangeLoading, ExchangeLoaded] when successful',
        build: () {
          when(() => mockGetExchanges(limit: 10, start: 1))
              .thenAnswer((_) async => tExchanges);
          return bloc;
        },
        act: (bloc) => bloc.add(const LoadExchanges(limit: 10)),
        expect: () => [
          ExchangeLoading(),
          const ExchangeLoaded(tExchanges, hasReachedMax: true), // 2 < 10, so true
        ],
      );

      blocTest<ExchangeBloc, ExchangeState>(
        'emits [ExchangeLoading, ExchangeLoaded] with hasReachedMax true when fewer items returned',
        build: () {
          when(() => mockGetExchanges(limit: any(named: 'limit'), start: any(named: 'start')))
              .thenAnswer((_) async => [tExchanges.first]);
          return bloc;
        },
        act: (bloc) => bloc.add(const LoadExchanges(limit: 20)),
        expect: () => [
          ExchangeLoading(),
          const ExchangeLoaded([
            Exchange(
              id: 1,
              name: 'Binance',
              logo: 'https://example.com/binance.png',
              spotVolumeUsd: 1000000.0,
            ),
          ], hasReachedMax: true),
        ],
        verify: (_) {
          verify(() => mockGetExchanges(limit: 20, start: 1)).called(1);
        },
      );

      blocTest<ExchangeBloc, ExchangeState>(
        'emits [ExchangeLoading, ExchangeError] when get exchanges fails',
        build: () {
          when(() => mockGetExchanges(limit: any(named: 'limit'), start: any(named: 'start')))
              .thenThrow(Exception('Network error'));
          return bloc;
        },
        act: (bloc) => bloc.add(const LoadExchanges(limit: 20)),
        expect: () => [
          ExchangeLoading(),
          const ExchangeError('Exception: Network error'),
        ],
        verify: (_) {
          verify(() => mockGetExchanges(limit: 20, start: 1)).called(1);
        },
      );

      blocTest<ExchangeBloc, ExchangeState>(
        'emits [ExchangeLoading, ExchangeLoaded] with refresh flag',
        build: () {
          when(() => mockGetExchanges(limit: any(named: 'limit'), start: any(named: 'start')))
              .thenAnswer((_) async => tExchanges);
          return bloc;
        },
        act: (bloc) => bloc.add(const LoadExchanges(limit: 20, refresh: true)),
        expect: () => [
          ExchangeLoading(),
          const ExchangeLoaded(tExchanges, hasReachedMax: true), // 2 < 20, so true
        ],
        verify: (_) {
          verify(() => mockGetExchanges(limit: 20, start: 1)).called(1);
        },
      );
    });

    group('LoadMoreExchanges', () {
      blocTest<ExchangeBloc, ExchangeState>(
        'emits [ExchangeLoadingMore, ExchangeLoaded] when successful',
        build: () {
          when(() => mockGetExchanges(limit: any(named: 'limit'), start: any(named: 'start')))
              .thenAnswer((_) async => tMoreExchanges);
          return bloc;
        },
        seed: () => const ExchangeLoaded(tExchanges, hasReachedMax: false),
        act: (bloc) => bloc.add(const LoadMoreExchanges(limit: 20)),
        expect: () => [
          const ExchangeLoadingMore(tExchanges),
          const ExchangeLoaded([...tExchanges, ...tMoreExchanges], hasReachedMax: true),
        ],
        verify: (_) {
          verify(() => mockGetExchanges(limit: 20, start: 3)).called(1);
        },
      );

      blocTest<ExchangeBloc, ExchangeState>(
        'does not emit when hasReachedMax is true',
        build: () => bloc,
        seed: () => const ExchangeLoaded(tExchanges, hasReachedMax: true),
        act: (bloc) => bloc.add(const LoadMoreExchanges(limit: 20)),
        expect: () => [],
        verify: (_) {
          verifyNever(() => mockGetExchanges(limit: any(named: 'limit'), start: any(named: 'start')));
        },
      );

      blocTest<ExchangeBloc, ExchangeState>(
        'emits [ExchangeLoadingMore, ExchangeError] when load more fails',
        build: () {
          when(() => mockGetExchanges(limit: any(named: 'limit'), start: any(named: 'start')))
              .thenThrow(Exception('Network error'));
          return bloc;
        },
        seed: () => const ExchangeLoaded(tExchanges, hasReachedMax: false),
        act: (bloc) => bloc.add(const LoadMoreExchanges(limit: 20)),
        expect: () => [
          const ExchangeLoadingMore(tExchanges),
          const ExchangeError('Exception: Network error'),
        ],
        verify: (_) {
          verify(() => mockGetExchanges(limit: 20, start: 3)).called(1);
        },
      );

      blocTest<ExchangeBloc, ExchangeState>(
        'does not emit when current state is not ExchangeLoaded',
        build: () => bloc,
        seed: () => ExchangeLoading(),
        act: (bloc) => bloc.add(const LoadMoreExchanges(limit: 20)),
        expect: () => [],
        verify: (_) {
          verifyNever(() => mockGetExchanges(limit: any(named: 'limit'), start: any(named: 'start')));
        },
      );
    });
  });
}
