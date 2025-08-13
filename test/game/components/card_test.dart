import 'package:flutter_test/flutter_test.dart';
import 'package:card_battler/game/components/card.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flame/components.dart';

void main() {
  testWithFlameGame('Card component can be added to game', (game) async {
    final card = Card()
      ..size = Vector2(100, 150)
      ..position = Vector2(10, 20);
    await game.ensureAdd(card);
    expect(game.children.contains(card), isTrue);
    expect(card.size, Vector2(100, 150));
    expect(card.position, Vector2(10, 20));
    expect(card.debugMode, isTrue);
  });
}
