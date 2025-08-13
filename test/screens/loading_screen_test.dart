import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:card_battler/screens/loading_screen.dart';
import 'package:card_battler/screens/menu_screen.dart';

void main() {
  testWidgets('LoadingScreen shows loading indicator then navigates to MenuScreen', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoadingScreen()));

    // Initially shows CircularProgressIndicator and Loading text
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Loading...'), findsOneWidget);
    expect(find.byType(MenuScreen), findsNothing);

    // Wait for the loading to complete
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    // Should now show MenuScreen
    expect(find.byType(MenuScreen), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.text('Loading...'), findsNothing);
  });
}
