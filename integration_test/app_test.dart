import 'package:card_battler/main.dart' as app;
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('App launches and shows menu', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    // Look for the menu item labeled 'Start Game'
    final startGameFinder = find.text('Start Game');
    expect(startGameFinder, findsOneWidget);

    // Tap the 'Start Game' menu item
    await tester.tap(startGameFinder);
  });
}
