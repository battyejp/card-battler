import 'package:flutter_test/flutter_test.dart';
import 'package:card_battler/game/components/enemies.dart';
import 'package:card_battler/game/components/card.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flame/components.dart';

void main() {
  final testCases = [
    {
      'enemiesSize': Vector2(300, 200),
      'cardSize': Vector2(60, 120),
      'positions': [
        Vector2(30, 40),
        Vector2(120, 40),
        Vector2(210, 40),
      ],
    },
    {
      'enemiesSize': Vector2(600, 400),
      'cardSize': Vector2(120, 240),
      'positions': [
        Vector2(60, 80),
        Vector2(240, 80),
        Vector2(420, 80),
      ],
    },
  ];
  for (final testCase in testCases) {
    testWithFlameGame('Enemies children sizes and positions for enemies size ${testCase['enemiesSize']}', (game) async {
      final enemies = Enemies()..size = testCase['enemiesSize'] as Vector2;

      await game.ensureAdd(enemies);

      final cards = enemies.children.whereType<Card>().toList();
      expect(cards.length, 3);
      final cardSize = testCase['cardSize'] as Vector2;
      final positions = testCase['positions'] as List<Vector2>;
      for (int i = 0; i < 3; i++) {
        expect(cards[i].size, cardSize);
        expect(cards[i].position, positions[i]);
      }
    });
  }
}
