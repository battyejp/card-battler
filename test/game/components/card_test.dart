import 'package:flutter_test/flutter_test.dart';
import 'package:card_battler/game/components/card.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flame/components.dart';

void main() {
  final testCases = [
    {'size': Vector2(100, 150), 'pos': Vector2(10, 20)},
    {'size': Vector2(200, 300), 'pos': Vector2(0, 0)},
  ];
  for (final testCase in testCases) {
    testWithFlameGame('Card size and position for size ${testCase['size']} pos ${testCase['pos']}', (game) async {
      final card = Card()
        ..size = testCase['size'] as Vector2
        ..position = testCase['pos'] as Vector2;

      await game.ensureAdd(card);

      expect(game.children.contains(card), isTrue);
      expect(card.size, testCase['size']);
      expect(card.position, testCase['pos']);
    });
  }
}