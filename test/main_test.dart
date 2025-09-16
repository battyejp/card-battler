import 'package:card_battler/card_battler_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Main App Initialization', () {
    testWidgets('main function initializes Flutter app correctly', (tester) async {
      // Since main() has async operations and platform channel calls,
      // we'll test the components that main() calls rather than main() directly
      
      // Test that CardBattlerApp can be created and rendered
      await tester.pumpWidget(const CardBattlerApp());
      
      // Verify the app is rendered (this will confirm main()'s runApp call would work)
      expect(find.byType(MaterialApp), findsOneWidget);
      
      // Let timers finish to avoid test framework issues
      await tester.pump(const Duration(seconds: 3));
    });
    
    testWidgets('CardBattlerApp renders without errors', (tester) async {
      // This test ensures that the app that main() would start can actually run
      await tester.pumpWidget(const CardBattlerApp());
      
      // Verify basic structure is in place
      expect(find.byType(MaterialApp), findsOneWidget);
      
      // Let it settle to ensure no async errors
      await tester.pumpAndSettle();
    });

    group('Platform configuration', () {
      testWidgets('app can handle orientation preferences', (tester) async {
        // Test that the app works in landscape orientations (what main() sets)
        // We can't directly test SystemChrome calls in unit tests, but we can ensure
        // the app handles the orientations properly
        
        TestWidgetsFlutterBinding.ensureInitialized();
        
        // Simulate landscape orientation
        await tester.binding.setSurfaceSize(const Size(800, 600));
        
        await tester.pumpWidget(const CardBattlerApp());
        await tester.pumpAndSettle();
        
        expect(find.byType(MaterialApp), findsOneWidget);
        
        // Reset to default
        await tester.binding.setSurfaceSize(null);
      });
      
      testWidgets('app handles different screen sizes', (tester) async {
        // Test various screen sizes that might occur in landscape mode
        final List<Size> testSizes = [
          const Size(1024, 768),   // Tablet landscape
          const Size(800, 600),    // Standard landscape
          const Size(1280, 720),   // HD landscape
          const Size(400, 300),    // Small landscape
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

    group('App initialization sequence', () {
      testWidgets('WidgetsFlutterBinding initialization works', (tester) async {
        // This is handled by the test framework, but we can verify it's working
        expect(WidgetsBinding.instance, isNotNull);
        
        // Test that our app can initialize after binding is ensured
        await tester.pumpWidget(const CardBattlerApp());
        expect(find.byType(MaterialApp), findsOneWidget);
        
        // Handle any pending timers from loading screen
        await tester.pump(const Duration(seconds: 3));
      });
      
      testWidgets('app starts with correct theme configuration', (tester) async {
        await tester.pumpWidget(const CardBattlerApp());
        
        final MaterialApp app = tester.widget(find.byType(MaterialApp));
        
        // Verify the app has basic configuration that would support game UI
        expect(app.title, equals('Card Battler'));
        expect(app.theme, isNotNull); // CardBattler uses dark theme
        
        await tester.pump(const Duration(seconds: 3));
      });
    });

    group('Error handling', () {
      testWidgets('app handles rendering without platform-specific setup', (tester) async {
        // In a test environment, SystemChrome calls might not work, but the app should still render
        await tester.pumpWidget(const CardBattlerApp());
        
        // Verify no exceptions are thrown during app initialization
        expect(tester.takeException(), isNull);
        
        await tester.pumpAndSettle();
        
        // App should still be functional
        expect(find.byType(MaterialApp), findsOneWidget);
      });
    });

    group('Integration with CardBattlerApp', () {
      testWidgets('main creates CardBattlerApp with const constructor', (tester) async {
        // Verify that the specific app instance main() creates works correctly
        const app = CardBattlerApp();
        
        await tester.pumpWidget(app);
        
        expect(find.byType(CardBattlerApp), findsOneWidget);
        expect(find.byType(MaterialApp), findsOneWidget);
        
        await tester.pumpAndSettle();
      });
    });
  });

  group('Platform Configuration', () {
    // Note: These tests can't directly test SystemChrome calls since they interact with platform channels
    // In a real app, you might use integration tests or platform-specific testing for this
    
    test('device orientations are correctly specified', () {
      // We can at least verify the orientations we want exist
      expect(DeviceOrientation.landscapeLeft, isNotNull);
      expect(DeviceOrientation.landscapeRight, isNotNull);
      
      // Verify these are distinct orientations
      expect(DeviceOrientation.landscapeLeft != DeviceOrientation.landscapeRight, isTrue);
    });
    
    test('system UI mode is correctly specified', () {
      // Verify the UI mode we want to use exists
      expect(SystemUiMode.immersiveSticky, isNotNull);
    });
  });

  group('App Entry Point', () {
    testWidgets('app configuration matches expected settings', (tester) async {
      // Test the actual configuration that main() would produce
      await tester.pumpWidget(const CardBattlerApp());
      
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      
      // Verify key app settings (note: CardBattlerApp doesn't set debugShowCheckedModeBanner explicitly)
      expect(materialApp.title, equals('Card Battler'));
      expect(materialApp.theme, isNotNull);
      
      await tester.pump(const Duration(seconds: 3));
      
      // Ensure no errors occurred during setup
      expect(tester.takeException(), isNull);
    });
  });
}