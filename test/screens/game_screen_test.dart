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
    
    // Allow timers to complete before test ends (now we have chained announcements)
    await tester.pump(const Duration(seconds: 5)); // First announcement
    await tester.pump(const Duration(seconds: 1)); // Wait for second announcement trigger
    await tester.pump(const Duration(seconds: 3)); // Second announcement duration
    await tester.pump(const Duration(milliseconds: 600)); // Complete all timers
  });
}
