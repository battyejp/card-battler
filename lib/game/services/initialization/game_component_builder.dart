import 'package:card_battler/game/coordinators/components/shared/turn_button_component_coordinator.dart';
import 'package:card_battler/game/services/initialization/game_initialization_service.dart';
import 'package:card_battler/game/services/ui/router_service.dart';
import 'package:card_battler/game/ui/components/shared/turn_button_component.dart';
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

  static TurnButtonComponent buildTurnButton({
    required Vector2 gameSize,
    required ServiceContainer services,
  }) {
    final turnButtonComponent = TurnButtonComponent(
      TurnButtonComponentCoordinator(
        gamePhaseManager: services.gamePhaseManager,
        dialogService: services.dialogService,
        activePlayerManager: services.activePlayerManager,
        cardsSelectionManagerService: services.cardsSelectionManagerService,
      ),
      cardsSelectionManagerService: services.cardsSelectionManagerService,
    );

    turnButtonComponent
      ..priority = 10
      ..size = Vector2(200, 50)
      ..position = Vector2(0, ((gameSize.y / 2) * -1) + (gameSize.y * 0.05));

    return turnButtonComponent;
  }

  static RouterComponent buildGameComponents({
    required Vector2 gameSize,
    required ServiceContainer services,
  }) {
    final router = buildGameRouter(
      gameSize: gameSize,
      services: services,
    );

    final turnButton = buildTurnButton(
      gameSize: gameSize,
      services: services,
    );

    router.add(turnButton);
    return router;
  }
}