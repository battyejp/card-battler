import 'package:flutter_test/flutter_test.dart';
import 'package:card_battler/game/components/hand.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flame/components.dart';

void main() {
  testWithFlameGame('Hand can be added to game', (game) async {
    final hand = Hand()..size = Vector2(100, 40);
    await game.ensureAdd(hand);
    expect(game.children.contains(hand), isTrue);
    expect(hand.size, Vector2(100, 40));
    expect(hand.debugMode, isTrue);
  });
}
