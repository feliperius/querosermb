import 'package:flutter_test/flutter_test.dart';
import '../robot/home_page_robot.dart';

void main() {
  group('Home Page Robot Tests', () {
    late HomePageRobot robot;

    setUp(() {
      TestWidgetsFlutterBinding.ensureInitialized();
    });

    testWidgets('should display loading state correctly', (tester) async {
      robot = HomePageRobot(tester);
      
      await robot.performCompleteLoadingFlow();
    });

    testWidgets('should display error state correctly', (tester) async {
      robot = HomePageRobot(tester);
      
      const errorMessage = 'Network connection failed';
      await robot.performErrorFlow(errorMessage);
    });

    testWidgets('should display loaded exchanges correctly', (tester) async {
      robot = HomePageRobot(tester);
      
      final exchanges = HomePageRobot.mockExchanges;
      await robot.performSuccessfulLoadingFlow(exchanges);
    });

    testWidgets('should display empty state correctly', (tester) async {
      robot = HomePageRobot(tester);
      
      await robot.mockLoadedState([], hasReachedMax: true);
      await robot.launchApp();
      await tester.pump();
      
      robot.seeEmptyState();
      robot.dontSeeLoadingIndicator();
      robot.dontSeeErrorMessage();
    });

    testWidgets('should handle single exchange correctly', (tester) async {
      robot = HomePageRobot(tester);
      
      final singleExchange = [HomePageRobot.singleExchange];
      await robot.performSuccessfulLoadingFlow(singleExchange);
      
      robot.seeExchange('Test Exchange');
    });
  });
}
