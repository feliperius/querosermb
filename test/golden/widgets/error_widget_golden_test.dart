import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:querosermb/features/list_exchanges/presentation/widgets/error_widget.dart';
import '../golden_test_helper.dart';

void main() {
  group('Error Widgets Golden Tests', () {
    testWidgets('renders exchange error widget with short message', (tester) async {
      final widget = GoldenTestHelper.wrapWidget(
        SizedBox(
          width: 300,
          height: 250,
          child: ExchangeErrorWidget(
            message: 'Network error',
            onRetry: () {},
          ),
        ),
      );

      await GoldenTestHelper.pumpAndSettle(tester, widget);

      await expectLater(
        find.byType(ExchangeErrorWidget),
        matchesGoldenFile('goldens/exchange_error_widget_short.png'),
      );
    });

    testWidgets('renders exchange error widget with long message', (tester) async {
      final widget = GoldenTestHelper.wrapWidget(
        SizedBox(
          width: 350,
          height: 400,
          child: ExchangeErrorWidget(
            message: 'A very long error message that should wrap properly in the UI and display correctly across multiple lines',
            onRetry: () {},
          ),
        ),
      );

      await GoldenTestHelper.pumpAndSettle(tester, widget);

      await expectLater(
        find.byType(ExchangeErrorWidget),
        matchesGoldenFile('goldens/exchange_error_widget_long.png'),
      );
    });
  });
}
