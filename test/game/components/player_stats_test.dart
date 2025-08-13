import 'package:flutter_test/flutter_test.dart';
import 'package:card_battler/game/components/player_stats.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flame/components.dart';

void main() {
  testWithFlameGame('PlayerStats can be added to game', (game) async {
    final stats = PlayerStats()..size = Vector2(50, 20);
    await game.ensureAdd(stats);
    expect(game.children.contains(stats), isTrue);
    expect(stats.size, Vector2(50, 20));
    expect(stats.debugMode, isTrue);
  });
}
