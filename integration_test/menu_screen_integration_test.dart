import 'package:card_battler/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Menu Screen Integration Test', () {
    testWidgets('should show menu screen after loading screen', (tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Verify that the loading screen is initially displayed
      expect(find.text('Loading...'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Wait for the loading to complete (2 seconds + some buffer)
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Verify that the menu screen appears after loading
      expect(find.text('Card Battler'), findsOneWidget);
      expect(find.text('Start Game'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);

      // Verify that loading screen elements are no longer present
      expect(find.text('Loading...'), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('should navigate to game screen when start button is tapped', (tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Wait for loading to complete
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Verify menu screen is displayed
      expect(find.text('Card Battler'), findsOneWidget);
      expect(find.text('Start Game'), findsOneWidget);

      // Tap the Start Game button
      await tester.tap(find.text('Start Game'));
      await tester.pumpAndSettle();

      // Verify navigation to game screen occurred
      // The game screen should no longer show the menu screen elements
      expect(find.text('Card Battler'), findsNothing);
      expect(find.text('Start Game'), findsNothing);
    });
  });
}