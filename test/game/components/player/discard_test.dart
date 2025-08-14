import 'package:flutter_test/flutter_test.dart';
import 'package:card_battler/game/components/player/discard.dart';
import 'package:card_battler/game/components/shared/card.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flame/components.dart';

void main() {
  final testCases = [
    {
      'discardSize': Vector2(100, 150),
      'cardSize': Vector2(50, 135),
      'cardPos': Vector2(25, 7.5),
    },
    {
      'discardSize': Vector2(200, 300),
      'cardSize': Vector2(100, 270),
      'cardPos': Vector2(50, 15),
    },
  ];
  for (final testCase in testCases) {
    testWithFlameGame('Discard child size and position for discard size ${testCase['discardSize']}', (game) async {
      final discard = Discard()..size = testCase['discardSize'] as Vector2;

      await game.ensureAdd(discard);

      final cards = discard.children.whereType<Card>().toList();
      expect(cards.length, 1);
      final card = cards.first;
      expect(card.size, testCase['cardSize']);
      expect(card.position, testCase['cardPos']);
    });
  }
}
