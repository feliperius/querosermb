import 'package:flutter_test/flutter_test.dart';
import 'package:querosermb/features/list_exchanges/domain/entities/exchange.dart';

void main() {
  group('Exchange Entity', () {
    const tExchange = Exchange(
      id: 1,
      name: 'Binance',
      logo: 'https://example.com/logo.png',
      spotVolumeUsd: 1000000.0,
      dateLaunched: '2017-07-14T00:00:00.000Z',
      description: 'Leading exchange',
      website: 'https://binance.com',
      makerFee: 0.1,
      takerFee: 0.1,
      currencies: [
        Currency(name: 'Bitcoin', priceUsd: 50000.0),
        Currency(name: 'Ethereum', priceUsd: 3000.0),
      ],
    );

    test('should be a subclass of Equatable', () {
      expect(tExchange, isA<Exchange>());
    });

    test('should support value equality', () {
      const exchange1 = Exchange(
        id: 1,
        name: 'Binance',
        logo: 'https://example.com/logo.png',
        spotVolumeUsd: 1000000.0,
      );

      const exchange2 = Exchange(
        id: 1,
        name: 'Binance',
        logo: 'https://example.com/logo.png',
        spotVolumeUsd: 1000000.0,
      );

      expect(exchange1, equals(exchange2));
    });

    test('should have correct props', () {
      expect(
        tExchange.props,
        [
          1,
          'Binance',
          'https://example.com/logo.png',
          1000000.0,
          '2017-07-14T00:00:00.000Z',
          'Leading exchange',
          'https://binance.com',
          0.1,
          0.1,
          [
            const Currency(name: 'Bitcoin', priceUsd: 50000.0),
            const Currency(name: 'Ethereum', priceUsd: 3000.0),
          ],
        ],
      );
    });

    test('should create exchange with minimal required fields', () {
      const minimalExchange = Exchange(
        id: 2,
        name: 'Coinbase',
      );

      expect(minimalExchange.id, equals(2));
      expect(minimalExchange.name, equals('Coinbase'));
      expect(minimalExchange.logo, isNull);
      expect(minimalExchange.spotVolumeUsd, isNull);
      expect(minimalExchange.currencies, isEmpty);
    });
  });

  group('Currency Entity', () {
    const tCurrency = Currency(
      name: 'Bitcoin',
      priceUsd: 50000.0,
    );

    test('should be a subclass of Equatable', () {
      expect(tCurrency, isA<Currency>());
    });

    test('should support value equality', () {
      const currency1 = Currency(name: 'Bitcoin', priceUsd: 50000.0);
      const currency2 = Currency(name: 'Bitcoin', priceUsd: 50000.0);

      expect(currency1, equals(currency2));
    });

    test('should have correct props', () {
      expect(tCurrency.props, ['Bitcoin', 50000.0]);
    });

    test('should create currency without price', () {
      const currency = Currency(name: 'Ethereum');

      expect(currency.name, equals('Ethereum'));
      expect(currency.priceUsd, isNull);
    });
  });
}
