import 'package:flutter_test/flutter_test.dart';
import 'package:card_battler/game/card_battler_game.dart';
import 'package:card_battler/game/components/player.dart';
import 'package:card_battler/game/components/enemies.dart';
import 'package:card_battler/game/components/shop.dart';
import 'package:card_battler/game/components/team.dart';
import 'package:flame_test/flame_test.dart';

void main() {
  testWithGame<CardBattlerGame>('CardBattlerGame adds all main components to the world', CardBattlerGame.new, (game) async {

    expect(game.world.children.whereType<Player>().length, 1);
    expect(game.world.children.whereType<Enemies>().length, 1);
    expect(game.world.children.whereType<Shop>().length, 1);
    expect(game.world.children.whereType<Team>().length, 1);
  });
}
