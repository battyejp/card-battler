import 'package:flutter_test/flutter_test.dart';
import 'package:card_battler/game/components/bases.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flame/components.dart';

void main() {
  final testCases = [
    {'size': Vector2(100, 100), 'pos': Vector2(10, 20)},
    {'size': Vector2(200, 200), 'pos': Vector2(0, 0)},
  ];
  for (final testCase in testCases) {
    testWithFlameGame('Bases size and position for size ${testCase['size']} pos ${testCase['pos']}', (game) async {
      final base = Bases()
        ..size = testCase['size'] as Vector2
        ..position = testCase['pos'] as Vector2;

      await game.ensureAdd(base);

      expect(game.children.contains(base), isTrue);
      expect(base.size, testCase['size']);
      expect(base.position, testCase['pos']);
    });
  }
}
