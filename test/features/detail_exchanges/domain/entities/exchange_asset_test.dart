import 'package:flutter_test/flutter_test.dart';
import 'package:querosermb/features/detail_exchanges/domain/entities/exchange_asset.dart';

void main() {
  group('ExchangeAsset Entity', () {
    const tPlatform = Platform(
      cryptoId: 1,
      symbol: 'BTC',
      name: 'Bitcoin',
    );

    const tAssetCurrency = AssetCurrency(
      cryptoId: 1,
      priceUsd: 50000.0,
      symbol: 'BTC',
      name: 'Bitcoin',
    );

    const tExchangeAsset = ExchangeAsset(
      walletAddress: '1A1zP1eP5QGefi2DMPTfTL5SLmv7DivfNa',
      balance: 1.5,
      platform: tPlatform,
      currency: tAssetCurrency,
    );

    test('should be a subclass of Equatable', () {
      expect(tExchangeAsset, isA<ExchangeAsset>());
    });

    test('should support value equality', () {
      const asset1 = ExchangeAsset(
        walletAddress: '1A1zP1eP5QGefi2DMPTfTL5SLmv7DivfNa',
        balance: 1.5,
        platform: tPlatform,
        currency: tAssetCurrency,
      );

      const asset2 = ExchangeAsset(
        walletAddress: '1A1zP1eP5QGefi2DMPTfTL5SLmv7DivfNa',
        balance: 1.5,
        platform: tPlatform,
        currency: tAssetCurrency,
      );

      expect(asset1, equals(asset2));
    });

    test('should have correct props', () {
      expect(
        tExchangeAsset.props,
        [
          '1A1zP1eP5QGefi2DMPTfTL5SLmv7DivfNa',
          1.5,
          tPlatform,
          tAssetCurrency,
        ],
      );
    });
  });

  group('Platform Entity', () {
    const tPlatform = Platform(
      cryptoId: 1,
      symbol: 'BTC',
      name: 'Bitcoin',
    );

    test('should be a subclass of Equatable', () {
      expect(tPlatform, isA<Platform>());
    });

    test('should support value equality', () {
      const platform1 = Platform(cryptoId: 1, symbol: 'BTC', name: 'Bitcoin');
      const platform2 = Platform(cryptoId: 1, symbol: 'BTC', name: 'Bitcoin');

      expect(platform1, equals(platform2));
    });

    test('should have correct props', () {
      expect(tPlatform.props, [1, 'BTC', 'Bitcoin']);
    });
  });

  group('AssetCurrency Entity', () {
    const tAssetCurrency = AssetCurrency(
      cryptoId: 1,
      priceUsd: 50000.0,
      symbol: 'BTC',
      name: 'Bitcoin',
    );

    test('should be a subclass of Equatable', () {
      expect(tAssetCurrency, isA<AssetCurrency>());
    });

    test('should support value equality', () {
      const currency1 = AssetCurrency(
        cryptoId: 1,
        priceUsd: 50000.0,
        symbol: 'BTC',
        name: 'Bitcoin',
      );

      const currency2 = AssetCurrency(
        cryptoId: 1,
        priceUsd: 50000.0,
        symbol: 'BTC',
        name: 'Bitcoin',
      );

      expect(currency1, equals(currency2));
    });

    test('should have correct props', () {
      expect(tAssetCurrency.props, [1, 50000.0, 'BTC', 'Bitcoin']);
    });
  });
}
