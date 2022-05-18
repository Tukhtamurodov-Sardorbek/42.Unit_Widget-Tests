// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:unit_widget_testing/pages/home_page.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  // /// Called once before ALL tests
  // setUpAll(() {});
  //
  // /// Called once before EVERY test
  // setUp(() {
  //   // reset(MockNavigatorObserver());
  //   debugPrint('Test');
  // });
  //
  // /// Called once after ALL tests
  // tearDownAll(() {});
  //
  // /// Called once after EVERY test
  // tearDown(() {});

  /// In order to test a page not touching to the whole app (My App)
  Widget testWidgetSeparatelyFromTheMyApp(
      {required Widget child, required MockNavigatorObserver mockObserver}) {
    return MaterialApp(
      home: child,
      // Receives all navigation events that happen in the app.
      navigatorObservers: [mockObserver],
    );
  }

  testWidgets(
    'Home Page Widget Testing',
    (WidgetTester tester) async {
      // Build our app and trigger a frame.
      // await tester.pumpWidget(const MyApp());

      HomePage page = const HomePage();
      final mockObserver = MockNavigatorObserver();
      await tester.pumpWidget(
        testWidgetSeparatelyFromTheMyApp(
            child: page, mockObserver: mockObserver),
      );

      // Check if our app has a ListView.
      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(GridView), findsNothing);

      // Check if our app has a text 'set State'.
      expect(find.text('set State'), findsOneWidget);
      expect(find.text('Detail Page'), findsNothing);
    },
  );

  testWidgets(
    'Navigation between pages HomePage and EditCreatePage',
    (WidgetTester tester) async {
      HomePage page = const HomePage();
      final mockObserver = MockNavigatorObserver();
      await tester.pumpWidget(
        testWidgetSeparatelyFromTheMyApp(
            child: page, mockObserver: mockObserver),
      );

      // Check if we are currently in HomePage
      expect(find.text('set State'), findsOneWidget);
      expect(find.text('Detail Page'), findsNothing);

      // Tap the '+' icon and trigger a frame.
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // Check if we are currently in EditCreatePage.
      expect(find.text('set State'), findsNothing);
      expect(find.text('Create post'), findsOneWidget);
      expect(find.byKey(const Key('TextField1')), findsOneWidget);
    },
  );

  testWidgets(
    'Navigation between pages EditCreatePage and HomePage',
    (WidgetTester tester) async {
      HomePage page = const HomePage();
      final mockObserver = MockNavigatorObserver();
      await tester.pumpWidget(
        testWidgetSeparatelyFromTheMyApp(
            child: page, mockObserver: mockObserver),
      );

      // Check if we are currently in HomePage
      expect(find.text('set State'), findsOneWidget);
      expect(find.text('Detail Page'), findsNothing);

      // Tap the '+' icon and trigger a frame.
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // Check if we are currently in EditCreatePage.
      expect(find.text('set State'), findsNothing);
      expect(find.text('Create post'), findsOneWidget);
      expect(find.byKey(const Key('TextField1')), findsOneWidget);

      // Tap the '<-' icon and trigger a frame.
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // Check if we are currently in HomePage again.
      expect(find.text('set State'), findsOneWidget);
      expect(find.text('Create post'), findsNothing);
    },
  );
}
