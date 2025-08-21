import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:querosermb/features/list_exchanges/domain/entities/exchange.dart';
import 'package:querosermb/features/list_exchanges/domain/repositories/exchange_repository.dart';
import 'package:querosermb/features/list_exchanges/domain/usecases/get_exchanges.dart';

class MockExchangeRepository extends Mock implements ExchangeRepository {}

void main() {
  late GetExchanges usecase;
  late MockExchangeRepository mockRepository;

  setUp(() {
    mockRepository = MockExchangeRepository();
    usecase = GetExchanges(mockRepository);
  });

  group('GetExchanges', () {
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

    test('should get exchanges from the repository', () async {
      // arrange
      when(() => mockRepository.getExchanges(start: any(named: 'start'), limit: any(named: 'limit')))
          .thenAnswer((_) async => tExchanges);

      // act
      final result = await usecase(start: 0, limit: 20);

      // assert
      expect(result, tExchanges);
      verify(() => mockRepository.getExchanges(start: 0, limit: 20)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should get exchanges with default parameters', () async {
      // arrange
      when(() => mockRepository.getExchanges(start: any(named: 'start'), limit: any(named: 'limit')))
          .thenAnswer((_) async => tExchanges);

      // act
      final result = await usecase();

      // assert
      expect(result, tExchanges);
      verify(() => mockRepository.getExchanges(start: 0, limit: 20)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should get exchanges with custom parameters', () async {
      // arrange
      when(() => mockRepository.getExchanges(start: any(named: 'start'), limit: any(named: 'limit')))
          .thenAnswer((_) async => tExchanges);

      // act
      final result = await usecase(start: 10, limit: 50);

      // assert
      expect(result, tExchanges);
      verify(() => mockRepository.getExchanges(start: 10, limit: 50)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should throw exception when repository fails', () async {
      // arrange
      when(() => mockRepository.getExchanges(start: any(named: 'start'), limit: any(named: 'limit')))
          .thenThrow(Exception('Network error'));

      // act & assert
      expect(
        () async => await usecase(start: 0, limit: 20),
        throwsA(isA<Exception>()),
      );
      verify(() => mockRepository.getExchanges(start: 0, limit: 20)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
