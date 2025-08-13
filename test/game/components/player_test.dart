import 'package:flutter_test/flutter_test.dart';
import 'package:card_battler/game/components/player.dart';
import 'package:card_battler/game/components/deck.dart';
import 'package:card_battler/game/components/hand.dart';
import 'package:card_battler/game/components/discard.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flame/components.dart';

void main() {
  final testCases = [
    {'size': Vector2(300, 100), 'deck': Vector2(60, 100), 'hand': Vector2(180, 100), 'discard': Vector2(60, 100)},
    {'size': Vector2(400, 200), 'deck': Vector2(80, 200), 'hand': Vector2(240, 200), 'discard': Vector2(80, 200)},
  ];

  for (final testCase in testCases) {
    testWithFlameGame(
      'Player children sizes for size [32m${testCase['size']}[0m',
      (game) async {
        final player = Player()..size = testCase['size'] as Vector2;

        await game.ensureAdd(player);

        final deck = player.children.whereType<Deck>().first;
        final hand = player.children.whereType<Hand>().first;
        final discard = player.children.whereType<Discard>().first;
        expect(deck.size, testCase['deck']);
        expect(hand.size, testCase['hand']);
        expect(discard.size, testCase['discard']);
        expect(player.children.whereType<Deck>().length, 1);
        expect(player.children.whereType<Hand>().length, 1);
        expect(player.children.whereType<Discard>().length, 1);
      },
    );
  }
}
