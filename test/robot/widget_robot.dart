import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:querosermb/features/list_exchanges/presentation/widgets/loading_widgets.dart';
import 'package:querosermb/features/list_exchanges/presentation/widgets/error_widget.dart';
import 'package:querosermb/core/theme/app_theme.dart';

/// Robot class for testing individual UI widgets
class WidgetRobot {
  final WidgetTester tester;

  WidgetRobot(this.tester);

  /// Actions for Loading Widgets

  Future<void> pumpLoadingWidget() async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.theme,
        home: const Scaffold(
          body: LoadingWidget(),
        ),
      ),
    );
  }

  Future<void> pumpLoadingMoreWidget() async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.theme,
        home: const Scaffold(
          body: LoadingMoreWidget(),
        ),
      ),
    );
  }

  Future<void> pumpErrorWidget(String message, VoidCallback onRetry) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.theme,
        home: Scaffold(
          body: ExchangeErrorWidget(
            message: message,
            onRetry: onRetry,
          ),
        ),
      ),
    );
  }

  Future<void> pumpMultipleWidgets() async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.theme,
        home: const Scaffold(
          body: Column(
            children: [
              LoadingWidget(),
              SizedBox(height: 20),
              LoadingMoreWidget(),
            ],
          ),
        ),
      ),
    );
  }

  /// Widget-specific actions

  Future<void> tapRetryButton() async {
    await tester.tap(find.text('Tentar novamente'));
    await tester.pump();
  }

  Future<void> waitForAnimation() async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
  }

  Future<void> resizeScreen(Size size) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;
    await tester.pump();
  }

  void resetScreen() {
    tester.view.reset();
  }

  /// Assertions for Loading Widgets

  void seeLoadingWidget() {
    expect(find.byType(LoadingWidget), findsOneWidget);
  }

  void seeLoadingMoreWidget() {
    expect(find.byType(LoadingMoreWidget), findsOneWidget);
  }

  void seeCircularProgressIndicator() {
    expect(find.byType(CircularProgressIndicator), findsAtLeastNWidgets(1));
  }

  void seeLoadingText() {
    expect(find.text('Carregando exchanges...'), findsOneWidget);
  }

  void seeMultipleProgressIndicators(int count) {
    expect(find.byType(CircularProgressIndicator), findsNWidgets(count));
  }

  /// Assertions for Error Widgets

  void seeErrorWidget() {
    expect(find.byType(ExchangeErrorWidget), findsOneWidget);
  }

  void seeErrorIcon() {
    expect(find.byIcon(Icons.error), findsOneWidget);
  }

  void seeErrorTitle() {
    expect(find.text('Erro ao carregar exchanges'), findsOneWidget);
  }

  void seeErrorMessage(String message) {
    expect(find.text(message), findsOneWidget);
  }

  void seeRetryButton() {
    expect(find.text('Tentar novamente'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
  }

  /// Complex Widget Testing Scenarios

  Future<void> testLoadingWidgetRendering() async {
    await pumpLoadingWidget();
    
    seeLoadingWidget();
    seeCircularProgressIndicator();
    seeLoadingText();
  }

  Future<void> testLoadingMoreWidgetRendering() async {
    await pumpLoadingMoreWidget();
    
    seeLoadingMoreWidget();
    seeCircularProgressIndicator();
  }

  Future<void> testErrorWidgetWithMessage(String message) async {
    bool retryPressed = false;
    
    await pumpErrorWidget(message, () {
      retryPressed = true;
    });
    
    seeErrorWidget();
    seeErrorIcon();
    seeErrorTitle();
    seeErrorMessage(message);
    seeRetryButton();
    
    await tapRetryButton();
    
    expect(retryPressed, isTrue, reason: 'Retry callback should be called');
  }

  Future<void> testMultipleWidgetsCoexistence() async {
    await pumpMultipleWidgets();
    
    seeLoadingWidget();
    seeLoadingMoreWidget();
    seeMultipleProgressIndicators(2);
  }

  Future<void> testWidgetResponsiveness() async {
    await pumpLoadingWidget();
    
    // Test on mobile size
    await resizeScreen(const Size(400, 800));
    seeLoadingWidget();
    
    // Test on tablet size
    await resizeScreen(const Size(800, 1200));
    seeLoadingWidget();
    
    // Test on desktop size
    await resizeScreen(const Size(1920, 1080));
    seeLoadingWidget();
    
    resetScreen();
  }

  Future<void> testErrorWidgetWithEmptyMessage() async {
    bool retryPressed = false;
    
    await pumpErrorWidget('', () {
      retryPressed = true;
    });
    
    seeErrorWidget();
    seeErrorTitle();
    seeRetryButton();
    
    await tapRetryButton();
    expect(retryPressed, isTrue);
  }

  Future<void> testErrorWidgetWithLongMessage() async {
    const longMessage = 'This is a very long error message that should wrap properly '
        'and be displayed correctly in the UI without causing any overflow issues '
        'or layout problems in the error widget container.';
    
    bool retryPressed = false;
    
    await pumpErrorWidget(longMessage, () {
      retryPressed = true;
    });
    
    seeErrorWidget();
    seeErrorMessage(longMessage);
    seeRetryButton();
    
    await tapRetryButton();
    expect(retryPressed, isTrue);
  }

  Future<void> testMultipleRetryButtonPresses() async {
    int retryCount = 0;
    
    await pumpErrorWidget('Test error', () {
      retryCount++;
    });
    
    seeRetryButton();
    
    // Press retry button multiple times
    await tapRetryButton();
    expect(retryCount, equals(1));
    
    await tapRetryButton();
    expect(retryCount, equals(2));
    
    await tapRetryButton();
    expect(retryCount, equals(3));
  }

  /// Verification helpers

  void verifyWidgetIsAccessible() {
    // Basic accessibility checks
    final semantics = tester.getSemantics(find.byType(Semantics).first);
    expect(semantics, isNotNull);
  }

  void verifyNoOverflow() {
    // Check that no RenderFlex overflow occurs
    expect(tester.takeException(), isNull);
  }

  void verifyWidgetUsesTheme() {
    final context = tester.element(find.byType(MaterialApp));
    final theme = Theme.of(context);
    expect(theme, isNotNull);
    expect(theme.colorScheme.primary, isNotNull);
  }
}
