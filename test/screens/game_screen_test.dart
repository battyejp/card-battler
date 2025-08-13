import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:card_battler/screens/game_screen.dart';

void main() {
  testWidgets('GameScreen renders GameWidget', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: GameScreen()));

    // Match any GameWidget regardless of generic type
    expect(
      find.byWidgetPredicate((widget) => widget.runtimeType.toString().startsWith('GameWidget')),
      findsOneWidget,
    );
  });
}
