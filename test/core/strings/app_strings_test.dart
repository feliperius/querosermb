import 'package:flutter_test/flutter_test.dart';
import 'package:querosermb/core/strings/app_strings.dart';

void main() {
  group('AppStrings', () {
    group('Static Strings', () {
      test('should have correct app strings', () {
        expect(AppStrings.appTitle, 'QueroSerMB');
        expect(AppStrings.homeTitle, 'Desafio MB');
        expect(AppStrings.exchangeDetailsTitle, 'Detalhes da Exchange');
        expect(AppStrings.notAvailable, 'N/A');
        expect(AppStrings.tryAgain, 'Tentar novamente');
      });

      test('should have correct loading strings', () {
        expect(AppStrings.loadingExchange, 'Carregando Exchange');
        expect(AppStrings.loadingExchanges, 'Carregando exchanges...');
        expect(AppStrings.loadingAssets, 'Carregando assets...');
      });

      test('should have correct error strings', () {
        expect(AppStrings.errorLoadingDetails, 'Erro ao carregar detalhes');
        expect(AppStrings.errorLoadingExchanges, 'Erro ao carregar exchanges');
        expect(AppStrings.errorLoadingAssets, 'Erro ao carregar assets');
      });

      test('should have correct asset strings', () {
        expect(AppStrings.assetsTitle, 'Assets da Exchange');
        expect(AppStrings.noAssetsFound, 'Nenhum asset encontrado');
        expect(AppStrings.assetsSingular, 'asset');
        expect(AppStrings.assetsPlural, 'assets');
      });
    });

    group('Helper Methods', () {
      group('getAssetsCount', () {
        test('should return singular form for count 1', () {
          final result = AppStrings.getAssetsCount(1);
          expect(result, '1 asset encontrado');
        });

        test('should return plural form for count > 1', () {
          final result = AppStrings.getAssetsCount(5);
          expect(result, '5 assets encontrados');
        });

        test('should return plural form for count 0', () {
          final result = AppStrings.getAssetsCount(0);
          expect(result, '0 assets encontrados');
        });
      });

      group('getCoinsCount', () {
        test('should format coins count correctly', () {
          final result = AppStrings.getCoinsCount(10);
          expect(result, 'Moedas (10)');
        });

        test('should handle zero coins', () {
          final result = AppStrings.getCoinsCount(0);
          expect(result, 'Moedas (0)');
        });
      });

      group('getAllAssetsTitle', () {
        test('should format all assets title correctly', () {
          final result = AppStrings.getAllAssetsTitle(25);
          expect(result, 'Todos os Assets (25)');
        });
      });

      group('getViewAllAssetsLabel', () {
        test('should format view all assets label correctly', () {
          final result = AppStrings.getViewAllAssetsLabel(10);
          expect(result, 'Ver todos os 10 assets');
        });
      });

      group('formatPercentage', () {
        test('should format percentage with value', () {
          final result = AppStrings.formatPercentage(2.5);
          expect(result, '2.5%');
        });

        test('should return N/A for null value', () {
          final result = AppStrings.formatPercentage(null);
          expect(result, 'N/A');
        });

        test('should handle zero percentage', () {
          final result = AppStrings.formatPercentage(0.0);
          expect(result, '0.0%');
        });
      });

      group('formatCurrency', () {
        test('should format currency correctly', () {
          final result = AppStrings.formatCurrency(1234.56);
          expect(result, '\$1.2K');
        });

        test('should format large numbers correctly', () {
          final result = AppStrings.formatCurrency(1000000.0);
          expect(result, '\$1.00M');
        });

        test('should handle decimal places correctly', () {
          final result = AppStrings.formatCurrency(99.9);
          expect(result, '\$99.90');
        });

        test('should format billions correctly', () {
          final result = AppStrings.formatCurrency(2500000000.0);
          expect(result, '\$2.50B');
        });

        test('should format trillions correctly', () {
          final result = AppStrings.formatCurrency(1500000000000.0);
          expect(result, '\$1.50T');
        });
      });

      group('formatId', () {
        test('should format ID correctly', () {
          final result = AppStrings.formatId(123);
          expect(result, 'ID: 123');
        });
      });

      group('formatLaunchedAt', () {
        test('should format launched date correctly', () {
          final result = AppStrings.formatLaunchedAt('2017-07-14');
          expect(result, 'Lançado em: 2017-07-14');
        });
      });

      group('formatVolume', () {
        test('should format volume with value', () {
          final result = AppStrings.formatVolume(1000000.0);
          expect(result, 'Vol: \$1.00M');
        });

        test('should return N/A for null volume', () {
          final result = AppStrings.formatVolume(null);
          expect(result, 'Vol: N/A');
        });

        test('should handle zero volume', () {
          final result = AppStrings.formatVolume(0.0);
          expect(result, 'Vol: \$0.00');
        });

        test('should format billions volume correctly', () {
          final result = AppStrings.formatVolume(5600000000.0);
          expect(result, 'Vol: \$5.60B');
        });
      });
    });
  });
}
