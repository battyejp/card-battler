import 'package:flutter_test/flutter_test.dart';
import 'package:card_battler/game/components/ui/shop.dart';
import 'package:card_battler/game/components/shared/card.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flame/components.dart';

void main() {
  final testCases = [
    {
      'shopSize': Vector2(300, 200),
      'cardSize': Vector2(78.947368, 76.0),
      'positions': [
        Vector2(15.789474, 16.0),
        Vector2(110.526316, 16.0),
        Vector2(205.263158, 16.0),
        Vector2(15.789474, 108.0),
        Vector2(110.526316, 108.0),
        Vector2(205.263158, 108.0),
      ],
    },
    {
      'shopSize': Vector2(600, 400),
      'cardSize': Vector2(157.894737, 152.0),
      'positions': [
        Vector2(31.578947, 32.0),
        Vector2(221.052632, 32.0),
        Vector2(410.526316, 32.0),
        Vector2(31.578947, 216.0),
        Vector2(221.052632, 216.0),
        Vector2(410.526316, 216.0),
      ],
    },
  ];
  for (final testCase in testCases) {
    testWithFlameGame('Shop children sizes and positions for shop size ${testCase['shopSize']}', (game) async {
      final shop = Shop()..size = testCase['shopSize'] as Vector2;

      await game.ensureAdd(shop);

      final cards = shop.children.whereType<Card>().toList();
      expect(cards.length, 6);
      final cardSize = testCase['cardSize'] as Vector2;
      final positions = testCase['positions'] as List<Vector2>;
      for (int i = 0; i < 6; i++) {
        expect(cards[i].size.x, closeTo(cardSize.x, 0.0001));
        expect(cards[i].size.y, closeTo(cardSize.y, 0.0001));
        expect(cards[i].position.x, closeTo(positions[i].x, 0.0001));
        expect(cards[i].position.y, closeTo(positions[i].y, 0.0001));
      }
    });
  }
}
