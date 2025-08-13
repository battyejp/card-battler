import 'package:flutter_test/flutter_test.dart';
import 'package:card_battler/game/components/enemies.dart';
import 'package:card_battler/game/components/card.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flame/components.dart';

void main() {
  testWithFlameGame('Enemies adds 3 Card components', (game) async {
    final enemies = Enemies()..size = Vector2(300, 200);
    await game.ensureAdd(enemies);
    expect(enemies.children.whereType<Card>().length, 3);
  });
}
