import 'package:flutter_test/flutter_test.dart';
import 'package:card_battler/game/components/player.dart';
import 'package:card_battler/game/components/deck.dart';
import 'package:card_battler/game/components/hand.dart';
import 'package:card_battler/game/components/discard.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flame/components.dart';

void main() {
  testWithFlameGame('Player adds Deck, Hand, and Discard', (game) async {
    final player = Player()..size = Vector2(300, 100);
    await game.ensureAdd(player);
    expect(player.children.whereType<Deck>().length, 1);
    expect(player.children.whereType<Hand>().length, 1);
    expect(player.children.whereType<Discard>().length, 1);
  });
}
