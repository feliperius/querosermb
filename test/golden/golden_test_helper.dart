import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:querosermb/core/theme/theme.dart';

/// Helper class for golden tests
class GoldenTestHelper {
  /// Creates a widget wrapped with Material App and theme for golden tests
  static Widget wrapWidget(Widget widget, {ThemeData? theme}) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme ?? AppTheme.theme,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: widget,
        ),
      ),
    );
  }

  /// Creates a widget wrapped for list item testing
  static Widget wrapListItem(Widget widget) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: Scaffold(
        backgroundColor: AppColors.background,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: widget,
        ),
      ),
    );
  }

  /// Creates a widget wrapped for screen testing
  static Widget wrapScreen(Widget screen) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: screen,
    );
  }

  /// Standard pump and settle for golden tests
  static Future<void> pumpAndSettle(WidgetTester tester, Widget widget) async {
    await tester.pumpWidget(widget);
    // Use pump instead of pumpAndSettle for widgets with animations
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
  }

  /// Creates test data for golden tests
  static Map<String, dynamic> createTestData() {
    return {
      'mockExchange': {
        'id': 1,
        'name': 'Binance',
        'logo': 'https://example.com/binance.png',
        'spotVolumeUsd': 1000000000.0,
        'dateLaunched': '2017-07-14T00:00:00.000Z',
        'description': 'Binance is the world\'s largest cryptocurrency exchange by trading volume.',
        'website': 'https://www.binance.com',
        'makerFee': 0.1,
        'takerFee': 0.1,
      },
      'mockAssets': [
        {
          'id': 'BTC',
          'balance': 1.5,
          'platform': {
            'id': 1,
            'name': 'Bitcoin',
            'symbol': 'BTC',
          },
          'currency': {
            'id': 1,
            'priceUsd': 50000.0,
            'name': 'Bitcoin',
            'symbol': 'BTC',
          }
        },
        {
          'id': 'ETH',
          'balance': 10.0,
          'platform': {
            'id': 1027,
            'name': 'Ethereum',
            'symbol': 'ETH',
          },
          'currency': {
            'id': 1027,
            'priceUsd': 3000.0,
            'name': 'Ethereum',
            'symbol': 'ETH',
          }
        },
      ],
    };
  }
}
