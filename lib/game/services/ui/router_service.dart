import 'package:card_battler/game/coordinators/components/scenes/enemy_turn_scene_coordinator.dart';
import 'package:card_battler/game/coordinators/components/scenes/game_scene_coordinator.dart';
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
    GameSceneCoordinator playerTurnSceneCoordinator,
    EnemyTurnSceneCoordinator enemyTurnSceneCoordinator,
    GamePhaseManager gamePhaseManager, {
    Map<String, Route>? additionalRoutes,
  }) {
    _playerTurnScene = GameScene(playerTurnSceneCoordinator)..size = gameSize;

    //TODO shopCoordinator should not come from playerTurnSceneCoordinator
    _shopScene = ShopScene(
      playerTurnSceneCoordinator.shopCoordinator.displayCoordinator,
    )..size = gameSize;

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
