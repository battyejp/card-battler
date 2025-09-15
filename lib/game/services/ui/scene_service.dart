import 'package:card_battler/game/coordinators/components/scenes/enemy_turn_scene_coordinator.dart';
import 'package:card_battler/game/coordinators/components/scenes/player_turn_scene_coordinator.dart';
import 'package:card_battler/game/services/ui/dialog_service.dart';
import 'package:card_battler/game/services/ui/router_service.dart';
import 'package:flame/game.dart';

class SceneService {
  final RouterService _routerService;
  final DialogService _dialogManager;
  final PlayerTurnSceneCoordinator _playerTurnSceneCoordinator;
  final EnemyTurnSceneCoordinator _enemyTurnSceneCoordinator;

  SceneService(
    this._routerService,
    this._dialogManager,
    this._playerTurnSceneCoordinator,
    this._enemyTurnSceneCoordinator,
  );

  RouterComponent createRouter(Vector2 gameSize) {
    final dialogRoutes = _dialogManager.getDialogRoutes();
    final router = _routerService.createRouter(
      gameSize,
      _playerTurnSceneCoordinator,
      _enemyTurnSceneCoordinator,
      additionalRoutes: dialogRoutes,
    );
    _dialogManager.initialize(router: router);
    return router;
  }
}
