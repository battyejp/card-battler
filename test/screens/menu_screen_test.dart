import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:card_battler/screens/menu_screen.dart';

void main() {
  testWidgets('MenuScreen displays title and Start Game button', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: MenuScreen()));

    expect(find.text('Card Battler'), findsOneWidget);
    expect(find.text('Start Game'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
  });
}
