import 'package:card_battler/game/coordinators/components/enemy/enemy_turn_coordinator.dart';
import 'package:card_battler/game/coordinators/components/scenes/game_scene_coordinator.dart';
import 'package:card_battler/game/coordinators/components/scenes/shop_scene_coordinator.dart';
import 'package:card_battler/game/services/game/game_phase_manager.dart';
import 'package:card_battler/game/ui/components/scenes/game_scene.dart';
import 'package:card_battler/game/ui/components/scenes/shop_scene.dart';
import 'package:flame/game.dart';

class RouterService {
  RouterComponent? _router;
  GameScene? _playerTurnScene;
  ShopScene? _shopScene;

  RouterComponent createRouter(
    Vector2 gameSize,
    GameSceneCoordinator gameSceneCoordinator,
    EnemyTurnCoordinator enemyTurnSceneCoordinator,
    GamePhaseManager gamePhaseManager,
    ShopSceneCoordinator shopCoordinator, {
    Map<String, Route>? additionalRoutes,
  }) {
    _playerTurnScene = GameScene(gameSceneCoordinator)..size = gameSize;

    _shopScene = ShopScene(shopCoordinator)..size = gameSize;

    final routes = {
      'playerTurn': Route(() => _playerTurnScene!),
      'shop': Route(() => _shopScene!),
    };

    // Add additional routes if provided
    if (additionalRoutes != null) {
      routes.addAll(additionalRoutes);
    }

    _router = RouterComponent(routes: routes, initialRoute: 'playerTurn');
    return _router!;
  }
}
