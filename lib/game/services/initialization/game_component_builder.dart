import 'package:card_battler/game/services/initialization/game_initialization_service.dart';
import 'package:card_battler/game/services/ui/router_service.dart';
import 'package:flame/game.dart';

class GameComponentBuilder {
  static RouterComponent buildGameRouter({
    required Vector2 gameSize,
    required ServiceContainer services,
  }) {
    final router = RouterService().createRouter(
      gameSize,
      services.coordinatorsManager.gameSceneCoordinator,
      services.coordinatorsManager.enemyTurnSceneCoordinator,
      services.gamePhaseManager,
      services.coordinatorsManager.shopSceneCoordinator,
      additionalRoutes: services.dialogService.getDialogRoutes(),
    );

    services.dialogService.initialize(router: router);
    return router;
  }

  static RouterComponent buildGameComponents({
    required Vector2 gameSize,
    required ServiceContainer services,
  }) => buildGameRouter(gameSize: gameSize, services: services);
}
