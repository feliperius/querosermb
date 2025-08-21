import 'package:flutter/material.dart';
import 'package:querosermb/features/list_exchanges/data/models/exchange_model.dart';
import 'package:querosermb/features/detail_exchanges/presentation/pages/exchange_detail_page.dart';

class AppRouter {
  AppRouter._();

  static Future<T?> pushExchangeDetail<T>(
    BuildContext context, {
    required int exchangeId,
    ExchangeModel? initialModel,
  }) {
    return Navigator.push<T>(
      context,
      MaterialPageRoute<T>(
        builder: (context) {
          return ExchangeDetailScreen(
            exchangeId: exchangeId,
            initialExchangeModel: initialModel,
          );
        },
      ),
    );
  }

  static Future<T?> pushNamed<T>(BuildContext context, String routeName, {Object? arguments}) {
    return Navigator.pushNamed<T>(context, routeName, arguments: arguments);
  }

  static Future<T?> pushReplacementNamed<T>(BuildContext context, String routeName, {Object? arguments}) {
    return Navigator.pushReplacementNamed<T, Object?>(context, routeName, arguments: arguments);
  }

  static void pop<T extends Object?>(BuildContext context, [T? result]) => Navigator.pop<T>(context, result);
}
