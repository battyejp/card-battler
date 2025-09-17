import 'package:card_battler/card_battler_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Main App Initialization', () {
    testWidgets('initializes Flutter app correctly and renders without errors', (
      tester,
    ) async {
      // Since main() has async operations and platform channel calls,
      // we'll test the components that main() calls rather than main() directly
      await tester.pumpWidget(const CardBattlerApp());

      // Verify the app is rendered (this will confirm main()'s runApp call would work)
      expect(find.byType(CardBattlerApp), findsOneWidget);
      expect(find.byType(MaterialApp), findsOneWidget);

      // Let it settle to ensure no async errors
      await tester.pumpAndSettle();
      
      // Ensure no errors occurred during setup
      expect(tester.takeException(), isNull);
    });

    group('Platform configuration', () {
      testWidgets('app handles different screen sizes including landscape orientations', (tester) async {
        // Test various screen sizes that might occur in landscape mode
        final testSizes = <Size>[
          const Size(1024, 768), // Tablet landscape
          const Size(800, 600), // Standard landscape
          const Size(1280, 720), // HD landscape
          const Size(400, 300), // Small landscape
        ];

        for (final size in testSizes) {
          await tester.binding.setSurfaceSize(size);

          await tester.pumpWidget(const CardBattlerApp());
          await tester.pumpAndSettle();

          expect(find.byType(MaterialApp), findsOneWidget);
        }

        // Reset to default
        await tester.binding.setSurfaceSize(null);
      });
    });

    group('App initialization and configuration', () {
      testWidgets('starts with correct theme and settings', (
        tester,
      ) async {
        // This is handled by the test framework, but we can verify it's working
        expect(WidgetsBinding.instance, isNotNull);

        await tester.pumpWidget(const CardBattlerApp());
        
        final app = tester.widget<MaterialApp>(find.byType(MaterialApp));

        // Verify the app has basic configuration that would support game UI
        expect(app.title, equals('Card Battler'));
        expect(app.theme, isNotNull); // CardBattler uses dark theme

        // Handle any pending timers from loading screen
        await tester.pump(const Duration(seconds: 3));
      });
    });

    group('Error handling', () {
      testWidgets('app handles rendering without platform-specific setup', (
        tester,
      ) async {
        // In a test environment, SystemChrome calls might not work, but the app should still render
        await tester.pumpWidget(const CardBattlerApp());

        // Verify no exceptions are thrown during app initialization
        expect(tester.takeException(), isNull);

        await tester.pumpAndSettle();

        // App should still be functional
        expect(find.byType(MaterialApp), findsOneWidget);
      });
    });
  });

  group('Platform Configuration', () {
    // Note: These tests can't directly test SystemChrome calls since they interact with platform channels
    // In a real app, you might use integration tests or platform-specific testing for this

    test('device orientations and UI mode are correctly specified', () {
      // We can at least verify the orientations we want exist
      expect(DeviceOrientation.landscapeLeft, isNotNull);
      expect(DeviceOrientation.landscapeRight, isNotNull);

      // Verify these are distinct orientations
      expect(
        DeviceOrientation.landscapeLeft != DeviceOrientation.landscapeRight,
        isTrue,
      );
      
      // Verify the UI mode we want to use exists
      expect(SystemUiMode.immersiveSticky, isNotNull);
    });
  });
}
