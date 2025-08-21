import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:querosermb/features/list_exchanges/domain/entities/exchange.dart';
import 'package:querosermb/features/list_exchanges/presentation/bloc/exchange_bloc.dart';
import 'package:querosermb/features/list_exchanges/presentation/bloc/exchange_state.dart';
import 'package:querosermb/features/list_exchanges/presentation/pages/home_page.dart';
import 'package:querosermb/features/list_exchanges/presentation/widgets/loading_widgets.dart';
import 'package:querosermb/features/list_exchanges/presentation/widgets/error_widget.dart';
import 'package:querosermb/core/theme/app_theme.dart';

class MockExchangeBloc extends Mock implements ExchangeBloc {}

/// Robot class for testing the Home Page functionality
class HomePageRobot {
  final WidgetTester tester;
  late MockExchangeBloc mockBloc;

  HomePageRobot(this.tester) {
    mockBloc = MockExchangeBloc();
  }

  /// Actions - Things the user can do
  
  Future<void> launchApp() async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.theme,
        home: BlocProvider<ExchangeBloc>.value(
          value: mockBloc,
          child: const HomePage(),
        ),
      ),
    );
  }

  Future<void> mockLoadingState() async {
    when(() => mockBloc.state).thenReturn(ExchangeLoading());
    when(() => mockBloc.stream).thenAnswer(
      (_) => Stream.fromIterable([ExchangeLoading()]),
    );
  }

  Future<void> mockLoadedState(List<Exchange> exchanges, {bool hasReachedMax = false}) async {
    final state = ExchangeLoaded(exchanges, hasReachedMax: hasReachedMax);
    when(() => mockBloc.state).thenReturn(state);
    when(() => mockBloc.stream).thenAnswer(
      (_) => Stream.fromIterable([state]),
    );
  }

  Future<void> mockErrorState(String errorMessage) async {
    final state = ExchangeError(errorMessage);
    when(() => mockBloc.state).thenReturn(state);
    when(() => mockBloc.stream).thenAnswer(
      (_) => Stream.fromIterable([state]),
    );
  }

  Future<void> tapRefreshButton() async {
    await tester.tap(find.byIcon(Icons.refresh));
    await tester.pumpAndSettle();
  }

  Future<void> tapRetryButton() async {
    await tester.tap(find.text('Tentar novamente'));
    await tester.pumpAndSettle();
  }

  Future<void> pullToRefresh() async {
    await tester.fling(
      find.byType(RefreshIndicator),
      const Offset(0, 300),
      1000,
    );
    await tester.pumpAndSettle();
  }

  Future<void> scrollDown() async {
    await tester.drag(
      find.byType(ListView),
      const Offset(0, -300),
    );
    await tester.pumpAndSettle();
  }

  Future<void> tapExchangeItem(String exchangeName) async {
    await tester.tap(find.text(exchangeName));
    await tester.pumpAndSettle();
  }

  /// Assertions - Things we want to verify

  void seeLoadingIndicator() {
    expect(find.byType(LoadingWidget), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsAtLeastNWidgets(1));
  }

  void seeLoadingText() {
    expect(find.text('Carregando exchanges...'), findsOneWidget);
  }

  void seeExchangesList() {
    expect(find.byType(ListView), findsOneWidget);
  }

  void seeExchange(String exchangeName) {
    expect(find.text(exchangeName), findsOneWidget);
  }

  void seeExchanges(List<String> exchangeNames) {
    for (final name in exchangeNames) {
      expect(find.text(name), findsOneWidget);
    }
  }

  void seeErrorMessage(String message) {
    expect(find.byType(ExchangeErrorWidget), findsOneWidget);
    expect(find.text(message), findsOneWidget);
  }

  void seeErrorIcon() {
    expect(find.byIcon(Icons.error), findsOneWidget);
  }

  void seeRetryButton() {
    expect(find.text('Tentar novamente'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
  }

  void seeAppBar() {
    expect(find.byType(AppBar), findsOneWidget);
  }

  void seeRefreshIcon() {
    expect(find.byIcon(Icons.refresh), findsOneWidget);
  }

  void dontSeeLoadingIndicator() {
    expect(find.byType(LoadingWidget), findsNothing);
  }

  void dontSeeErrorMessage() {
    expect(find.byType(ExchangeErrorWidget), findsNothing);
  }

  void seeEmptyState() {
    expect(find.byType(ListView), findsOneWidget);
    // Empty list should still show ListView but with no items
  }

  void seeNumberOfExchanges(int count) {
    // Count the actual exchange items, excluding loading indicators
    final exchangeItems = find.byType(Card);
    expect(exchangeItems.evaluate().length, equals(count));
  }

  /// Complex scenarios combining multiple actions

  Future<void> performCompleteLoadingFlow() async {
    await mockLoadingState();
    await launchApp();
    await tester.pump();
    
    seeLoadingIndicator();
    seeLoadingText();
    dontSeeErrorMessage();
  }

  Future<void> performErrorFlow(String errorMessage) async {
    await mockErrorState(errorMessage);
    await launchApp();
    await tester.pump();
    
    seeErrorMessage(errorMessage);
    seeErrorIcon();
    seeRetryButton();
    dontSeeLoadingIndicator();
  }

  Future<void> performSuccessfulLoadingFlow(List<Exchange> exchanges) async {
    await mockLoadedState(exchanges);
    await launchApp();
    await tester.pump();
    
    seeExchangesList();
    dontSeeLoadingIndicator();
    dontSeeErrorMessage();
    
    for (final exchange in exchanges) {
      seeExchange(exchange.name);
    }
  }

  /// Test data helpers

  static List<Exchange> get mockExchanges => [
    const Exchange(
      id: 1,
      name: 'Binance',
      logo: 'https://example.com/binance.png',
      spotVolumeUsd: 1000000000.0,
      dateLaunched: '2017-07-14T00:00:00.000Z',
    ),
    const Exchange(
      id: 2,
      name: 'Coinbase',
      logo: 'https://example.com/coinbase.png',
      spotVolumeUsd: 500000000.0,
      dateLaunched: '2012-06-20T00:00:00.000Z',
    ),
    const Exchange(
      id: 3,
      name: 'Kraken',
      logo: 'https://example.com/kraken.png',
      spotVolumeUsd: 300000000.0,
      dateLaunched: '2011-07-28T00:00:00.000Z',
    ),
  ];

  static Exchange get singleExchange => const Exchange(
    id: 1,
    name: 'Test Exchange',
    logo: 'https://example.com/test.png',
    spotVolumeUsd: 1000000.0,
    dateLaunched: '2020-01-01T00:00:00.000Z',
  );
}
