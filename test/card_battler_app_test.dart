import 'package:flutter_test/flutter_test.dart';
import 'package:card_battler/card_battler_app.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('CardBattlerApp renders MaterialApp', (WidgetTester tester) async {
    await tester.pumpWidget(const CardBattlerApp());
    await tester.pumpAndSettle();

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
