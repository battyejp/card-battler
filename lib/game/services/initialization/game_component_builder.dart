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
      services.coordinatorsManager.playerTurnSceneCoordinator,
      services.coordinatorsManager.enemyTurnSceneCoordinator,
      services.gamePhaseManager,
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
