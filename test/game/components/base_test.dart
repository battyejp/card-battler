import 'package:flutter_test/flutter_test.dart';
import 'package:card_battler/game/components/base.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flame/components.dart';

void main() {
  testWithFlameGame('Base can be added to game', (game) async {
    final base = Base()..size = Vector2(100, 100);
    await game.ensureAdd(base);
    expect(game.children.contains(base), isTrue);
    expect(base.size, Vector2(100, 100));
    expect(base.debugMode, isTrue);
  });
}
