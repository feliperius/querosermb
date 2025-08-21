import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:querosermb/features/list_exchanges/domain/entities/exchange.dart';
import 'package:querosermb/features/list_exchanges/domain/repositories/exchange_repository.dart';
import 'package:querosermb/features/list_exchanges/domain/usecases/get_exchange_by_id.dart';

class MockExchangeRepository extends Mock implements ExchangeRepository {}

void main() {
  late GetExchangeById usecase;
  late MockExchangeRepository mockRepository;

  setUp(() {
    mockRepository = MockExchangeRepository();
    usecase = GetExchangeById(mockRepository);
  });

  group('GetExchangeById', () {
    const tExchangeId = 1;
    const tExchange = Exchange(
      id: 1,
      name: 'Binance',
      logo: 'https://example.com/binance.png',
      spotVolumeUsd: 1000000.0,
      dateLaunched: '2017-07-14T00:00:00.000Z',
      description: 'Leading cryptocurrency exchange',
      website: 'https://binance.com',
      makerFee: 0.1,
      takerFee: 0.1,
      currencies: [
        Currency(name: 'Bitcoin', priceUsd: 50000.0),
        Currency(name: 'Ethereum', priceUsd: 3000.0),
      ],
    );

    test('should get exchange by id from the repository', () async {
      // arrange
      when(() => mockRepository.getExchangeById(any()))
          .thenAnswer((_) async => tExchange);

      // act
      final result = await usecase(tExchangeId);

      // assert
      expect(result, tExchange);
      verify(() => mockRepository.getExchangeById(tExchangeId)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should throw exception when repository fails', () async {
      // arrange
      when(() => mockRepository.getExchangeById(any()))
          .thenThrow(Exception('Network error'));

      // act & assert
      expect(
        () async => await usecase(tExchangeId),
        throwsA(isA<Exception>()),
      );
      verify(() => mockRepository.getExchangeById(tExchangeId)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should throw exception when exchange not found', () async {
      // arrange
      when(() => mockRepository.getExchangeById(any()))
          .thenThrow(Exception('Exchange not found'));

      // act & assert
      expect(
        () async => await usecase(999),
        throwsA(isA<Exception>()),
      );
      verify(() => mockRepository.getExchangeById(999)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
