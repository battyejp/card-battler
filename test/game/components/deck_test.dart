import 'package:flutter_test/flutter_test.dart';
import 'package:card_battler/game/components/deck.dart';
import 'package:card_battler/game/components/card.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flame/components.dart';

void main() {
  testWithFlameGame('Deck adds a Card component', (game) async {
    final deck = Deck()..size = Vector2(100, 150);
    await game.ensureAdd(deck);
    expect(deck.children.whereType<Card>().length, 1);
  });
}
