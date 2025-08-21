import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:querosermb/features/list_exchanges/presentation/widgets/loading_widgets.dart';
import '../golden_test_helper.dart';

void main() {
  group('Loading Widgets Golden Tests', () {
    testWidgets('renders main loading widget', (tester) async {
      final widget = GoldenTestHelper.wrapWidget(
        const SizedBox(
          width: 300,
          height: 200,
          child: LoadingWidget(),
        ),
      );

      await GoldenTestHelper.pumpAndSettle(tester, widget);

      await expectLater(
        find.byType(LoadingWidget),
        matchesGoldenFile('goldens/loading_widget.png'),
      );
    });

    testWidgets('renders loading more widget', (tester) async {
      final widget = GoldenTestHelper.wrapWidget(
        const SizedBox(
          width: 300,
          height: 100,
          child: LoadingMoreWidget(),
        ),
      );

      await GoldenTestHelper.pumpAndSettle(tester, widget);

      await expectLater(
        find.byType(LoadingMoreWidget),
        matchesGoldenFile('goldens/loading_more_widget.png'),
      );
    });
  });
}
