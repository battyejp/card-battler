import 'package:flutter_test/flutter_test.dart';
import 'package:card_battler/game/components/discard.dart';
import 'package:card_battler/game/components/card.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flame/components.dart';

void main() {
  testWithFlameGame('Discard adds a Card component', (game) async {
    final discard = Discard()..size = Vector2(100, 150);
    await game.ensureAdd(discard);
    expect(discard.children.whereType<Card>().length, 1);
  });
}
