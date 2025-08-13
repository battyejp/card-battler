import 'package:flutter_test/flutter_test.dart';
import 'package:card_battler/game/components/player.dart';
import 'package:card_battler/game/components/deck.dart';
import 'package:card_battler/game/components/hand.dart';
import 'package:card_battler/game/components/discard.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flame/components.dart';

void main() {
  final testCases = [
    {
      'size': Vector2(300, 100),
      'deck': {'size': Vector2(60, 100), 'pos': Vector2(0, 0)},
      'hand': {'size': Vector2(180, 100), 'pos': Vector2(60, 0)},
      'discard': {'size': Vector2(60, 100), 'pos': Vector2(240, 0)},
    },
    {
      'size': Vector2(400, 200),
      'deck': {'size': Vector2(80, 200), 'pos': Vector2(0, 0)},
      'hand': {'size': Vector2(240, 200), 'pos': Vector2(80, 0)},
      'discard': {'size': Vector2(80, 200), 'pos': Vector2(320, 0)},
    },
  ];

  for (final testCase in testCases) {
    testWithFlameGame(
      'Player children sizes and positions for size ${testCase['size']}',
      (game) async {
        final player = Player()..size = testCase['size'] as Vector2;

        await game.ensureAdd(player);

        final deck = player.children.whereType<Deck>().first;
        final hand = player.children.whereType<Hand>().first;
        final discard = player.children.whereType<Discard>().first;
        final deckCase = testCase['deck'] as Map<String, Vector2>;
        final handCase = testCase['hand'] as Map<String, Vector2>;
        final discardCase = testCase['discard'] as Map<String, Vector2>;
        expect(deck.size, deckCase['size']);
        expect(deck.position, deckCase['pos']);
        expect(hand.size, handCase['size']);
        expect(hand.position, handCase['pos']);
        expect(discard.size, discardCase['size']);
        expect(discard.position, discardCase['pos']);
        expect(player.children.whereType<Deck>().length, 1);
        expect(player.children.whereType<Hand>().length, 1);
        expect(player.children.whereType<Discard>().length, 1);
      },
    );
  }
}
