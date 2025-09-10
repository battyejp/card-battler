import 'package:flame/game.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:card_battler/game_legacy/card_battler_game.dart';
import 'package:card_battler/game_legacy/components/player/player.dart';
import 'package:card_battler/game_legacy/components/enemy/enemies.dart';
import 'package:card_battler/game_legacy/components/shop/shop.dart';
import 'package:card_battler/game_legacy/components/team/team.dart';
import 'package:card_battler/game_legacy/components/scenes/player_turn_scene.dart';
import 'package:flame_test/flame_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  testWithGame<CardBattlerGame>('CardBattlerGame adds router with PlayerTurnScene to the world', CardBattlerGame.new, (game) async {
    expect(game.world.children.whereType<RouterComponent>().length, 1);
    
    final router = game.world.children.whereType<RouterComponent>().first;
    final route = router.children.whereType<Route>().first;
    final playerTurnScene = route.children.whereType<PlayerTurnScene>().first;
    
    expect(playerTurnScene.children.whereType<Player>().length, 1);
    expect(playerTurnScene.children.whereType<Enemies>().length, 1);
    expect(playerTurnScene.children.whereType<Shop>().length, 1);
    expect(playerTurnScene.children.whereType<Team>().length, 1);
  });

  testWithGame<CardBattlerGame>(
    'CardBattlerGame main components have correct size and position for game size 800x600',
    () => CardBattlerGame.withSize(Vector2(800, 600)),
    (game) async {
      final router = game.world.children.whereType<RouterComponent>().first;
      final route = router.children.whereType<Route>().first;
      final playerTurnScene = route.children.whereType<PlayerTurnScene>().first;
      
      final player = playerTurnScene.children.whereType<Player>().first;
      expect(player.size, closeToVector(Vector2(760, 224)));
      expect(player.position, closeToVector(Vector2(-380, 56)));

      final enemies = playerTurnScene.children.whereType<Enemies>().first;
      expect(enemies.size, closeToVector(Vector2(380, 336)));
      expect(enemies.position, closeToVector(Vector2(-190, -280)));

      final shop = playerTurnScene.children.whereType<Shop>().first;
      expect(shop.size, closeToVector(Vector2(190, 336)));
      expect(shop.position, closeToVector(Vector2(190, -280)));

      final team = playerTurnScene.children.whereType<Team>().first;
      expect(team.size, closeToVector(Vector2(190, 336)));
      expect(team.position, closeToVector(Vector2(-380, -280)));
    },
  );

  testWithGame<CardBattlerGame>(
    'CardBattlerGame main components have correct size and position for game size 1024x768',
    () => CardBattlerGame.withSize(Vector2(1024, 768)),
    (game) async {
      final router = game.world.children.whereType<RouterComponent>().first;
      final route = router.children.whereType<Route>().first;
      final playerTurnScene = route.children.whereType<PlayerTurnScene>().first;
      
      final player = playerTurnScene.children.whereType<Player>().first;
      expect(player.size, closeToVector(Vector2(984, 291.2)));
      expect(player.position, closeToVector(Vector2(-492, 72.8)));

      final enemies = playerTurnScene.children.whereType<Enemies>().first;
      expect(enemies.size, closeToVector(Vector2(492, 436.8)));
      expect(enemies.position, closeToVector(Vector2(-246, -364)));

      final shop = playerTurnScene.children.whereType<Shop>().first;
      expect(shop.size, closeToVector(Vector2(246, 436.8)));
      expect(shop.position, closeToVector(Vector2(246, -364)));

      final team = playerTurnScene.children.whereType<Team>().first;
      expect(team.size, closeToVector(Vector2(246, 436.8)));
      expect(team.position, closeToVector(Vector2(-492, -364)));
    },
  );
}