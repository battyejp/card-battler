import 'package:flutter_test/flutter_test.dart';
import 'package:card_battler/game/components/deck.dart';
import 'package:card_battler/game/components/card.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flame/components.dart';

void main() {
  final testCases = [
    {
      'deckSize': Vector2(100, 150),
      'cardSize': Vector2(50, 135),
      'cardPos': Vector2(25, 7.5),
    },
    {
      'deckSize': Vector2(200, 300),
      'cardSize': Vector2(100, 270),
      'cardPos': Vector2(50, 15),
    },
  ];
  for (final testCase in testCases) {
    testWithFlameGame('Deck child size and position for deck size ${testCase['deckSize']}', (game) async {
      final deck = Deck()..size = testCase['deckSize'] as Vector2;

      await game.ensureAdd(deck);

      final cards = deck.children.whereType<Card>().toList();
      expect(cards.length, 1);
      final card = cards.first;
      expect(card.size, testCase['cardSize']);
      expect(card.position, testCase['cardPos']);
    });
  }
}