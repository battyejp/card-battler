import 'package:flutter_test/flutter_test.dart';
import 'package:card_battler/game/components/team.dart';
import 'package:card_battler/game/components/player_stats.dart';
import 'package:card_battler/game/components/base.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flame/components.dart';

void main() {
  testWithFlameGame('Team adds 3 PlayerStats and 1 Base', (game) async {
    final team = Team()..size = Vector2(200, 300);
    await game.ensureAdd(team);
    expect(team.children.whereType<PlayerStats>().length, 3);
    expect(team.children.whereType<Base>().length, 1);
  });
}
