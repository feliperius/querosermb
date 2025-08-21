import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:querosermb/features/list_exchanges/domain/entities/exchange.dart';
import '../golden_test_helper.dart';
import 'mock_exchange_list_item.dart';

void main() {
  group('ExchangeListItem Golden Tests', () {
    testWidgets('renders exchange list item with complete data', (tester) async {
      const exchange = Exchange(
        id: 1,
        name: 'Binance',
        logo: 'https://example.com/binance.png',
        spotVolumeUsd: 1000000000.0,
        dateLaunched: '2017-07-14T00:00:00.000Z',
        description: 'Binance is the world\'s largest cryptocurrency exchange by trading volume.',
        website: 'https://www.binance.com',
        makerFee: 0.1,
        takerFee: 0.1,
        currencies: [
          Currency(name: 'Bitcoin', priceUsd: 50000.0),
          Currency(name: 'Ethereum', priceUsd: 3000.0),
        ],
      );

      final widget = GoldenTestHelper.wrapListItem(
        SizedBox(
          width: 400,
          child: MockExchangeListItem(
            exchange: exchange,
            onTap: () {},
          ),
        ),
      );

      await GoldenTestHelper.pumpAndSettle(tester, widget);

      await expectLater(
        find.byType(MockExchangeListItem),
        matchesGoldenFile('goldens/exchange_list_item_complete.png'),
      );
    });

    testWidgets('renders exchange list item with minimal data', (tester) async {
      const exchange = Exchange(
        id: 2,
        name: 'Coinbase',
        logo: null,
        spotVolumeUsd: null,
        dateLaunched: null,
        description: null,
        website: null,
        makerFee: null,
        takerFee: null,
        currencies: [],
      );

      final widget = GoldenTestHelper.wrapListItem(
        SizedBox(
          width: 400,
          child: MockExchangeListItem(
            exchange: exchange,
            onTap: () {},
          ),
        ),
      );

      await GoldenTestHelper.pumpAndSettle(tester, widget);

      await expectLater(
        find.byType(MockExchangeListItem),
        matchesGoldenFile('goldens/exchange_list_item_minimal.png'),
      );
    });

    testWidgets('renders exchange list item with long name', (tester) async {
      const exchange = Exchange(
        id: 3,
        name: 'Very Long Exchange Name That Should Be Truncated Properly',
        logo: 'https://example.com/exchange.png',
        spotVolumeUsd: 500000000.0,
        dateLaunched: '2020-01-01T00:00:00.000Z',
        description: 'A very long description that should wrap properly in the UI',
        website: 'https://www.example.com',
        makerFee: 0.25,
        takerFee: 0.25,
        currencies: [
          Currency(name: 'Bitcoin', priceUsd: 50000.0),
        ],
      );

      final widget = GoldenTestHelper.wrapListItem(
        SizedBox(
          width: 400,
          child: MockExchangeListItem(
            exchange: exchange,
            onTap: () {},
          ),
        ),
      );

      await GoldenTestHelper.pumpAndSettle(tester, widget);

      await expectLater(
        find.byType(MockExchangeListItem),
        matchesGoldenFile('goldens/exchange_list_item_long_name.png'),
      );
    });

    testWidgets('renders exchange list item with zero volume', (tester) async {
      const exchange = Exchange(
        id: 4,
        name: 'Small Exchange',
        logo: 'https://example.com/small.png',
        spotVolumeUsd: 0.0,
        dateLaunched: '2023-01-01T00:00:00.000Z',
        description: 'A small exchange with zero volume',
        website: 'https://www.small.com',
        makerFee: 0.5,
        takerFee: 0.5,
        currencies: [],
      );

      final widget = GoldenTestHelper.wrapListItem(
        SizedBox(
          width: 400,
          child: MockExchangeListItem(
            exchange: exchange,
            onTap: () {},
          ),
        ),
      );

      await GoldenTestHelper.pumpAndSettle(tester, widget);

      await expectLater(
        find.byType(MockExchangeListItem),
        matchesGoldenFile('goldens/exchange_list_item_zero_volume.png'),
      );
    });
  });
}
