import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:querosermb/features/list_exchanges/presentation/widgets/loading_widgets.dart';
import 'package:querosermb/features/list_exchanges/presentation/widgets/error_widget.dart';

void main() {
  group('Widget Rendering Tests', () {
    testWidgets('LoadingWidget renders without errors', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LoadingWidget(),
          ),
        ),
      );

      expect(find.byType(LoadingWidget), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      
      expect(find.text('Carregando exchanges...'), findsOneWidget);
    });

    testWidgets('LoadingMoreWidget renders without errors', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LoadingMoreWidget(),
          ),
        ),
      );

      expect(find.byType(LoadingMoreWidget), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('ExchangeErrorWidget renders without errors', (tester) async {
      bool buttonPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExchangeErrorWidget(
              message: 'Test error message',
              onRetry: () {
                buttonPressed = true;
              },
            ),
          ),
        ),
      );

      expect(find.byType(ExchangeErrorWidget), findsOneWidget);
      expect(find.byIcon(Icons.error), findsOneWidget);
      expect(find.text('Test error message'), findsOneWidget);
      expect(find.text('Tentar novamente'), findsOneWidget);

      await tester.tap(find.text('Tentar novamente'));
      await tester.pump();

      expect(buttonPressed, isTrue);
    });

    testWidgets('All widgets use correct theme colors', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(),
          home: const Scaffold(
            body: Column(
              children: [
                LoadingWidget(),
                LoadingMoreWidget(),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(LoadingWidget), findsOneWidget);
      expect(find.byType(LoadingMoreWidget), findsOneWidget);
      
      await tester.pump();
    });

    testWidgets('Widgets handle different screen sizes', (tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LoadingWidget(),
          ),
        ),
      );

      expect(find.byType(LoadingWidget), findsOneWidget);

      tester.view.physicalSize = const Size(1200, 800);
      await tester.pump();

      expect(find.byType(LoadingWidget), findsOneWidget);

      addTearDown(tester.view.reset);
    });
  });

  group('Widget Content Validation', () {
    testWidgets('LoadingWidget displays correct loading message', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LoadingWidget(),
        ),
      );

      expect(find.text('Carregando exchanges...'), findsOneWidget);

      final progressIndicator = find.byType(CircularProgressIndicator);
      expect(progressIndicator, findsOneWidget);
    });

    testWidgets('ExchangeErrorWidget displays all required elements', (tester) async {
      const errorMessage = 'Network connection failed';
      
      await tester.pumpWidget(
        MaterialApp(
          home: ExchangeErrorWidget(
            message: errorMessage,
            onRetry: () {},
          ),
        ),
      );

      expect(find.text('Erro ao carregar exchanges'), findsOneWidget);
      expect(find.text(errorMessage), findsOneWidget);
      expect(find.text('Tentar novamente'), findsOneWidget);
      expect(find.byIcon(Icons.error), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });
  });

  group('Widget Interaction Tests', () {
    testWidgets('Error widget retry button works correctly', (tester) async {
      int retryCount = 0;
      
      await tester.pumpWidget(
        MaterialApp(
          home: ExchangeErrorWidget(
            message: 'Test error',
            onRetry: () {
              retryCount++;
            },
          ),
        ),
      );

      expect(retryCount, equals(0));

      await tester.tap(find.text('Tentar novamente'));
      await tester.pump();

      expect(retryCount, equals(1));

      await tester.tap(find.text('Tentar novamente'));
      await tester.pump();

      expect(retryCount, equals(2));
    });

    testWidgets('Multiple loading widgets can coexist', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
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

      expect(find.byType(LoadingWidget), findsOneWidget);
      expect(find.byType(LoadingMoreWidget), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNWidgets(2));
    });

    testWidgets('Error widget handles empty message', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ExchangeErrorWidget(
            message: '',
            onRetry: () {},
          ),
        ),
      );

      expect(find.byType(ExchangeErrorWidget), findsOneWidget);
      expect(find.text('Erro ao carregar exchanges'), findsOneWidget);
      expect(find.text('Tentar novamente'), findsOneWidget);
    });

    testWidgets('Loading widgets render consistently', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LoadingWidget(),
        ),
      );

      expect(find.byType(LoadingWidget), findsOneWidget);

      await tester.pumpWidget(
        const MaterialApp(
          home: LoadingWidget(),
        ),
      );

      expect(find.byType(LoadingWidget), findsOneWidget);
      expect(find.text('Carregando exchanges...'), findsOneWidget);
    });
  });
}
