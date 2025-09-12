import 'package:card_battler/game/services/ui/dialog_service.dart';
import 'package:card_battler/game/services/ui/router_service.dart';
import 'package:flame/game.dart';

class SceneService {
  final RouterService _routerService;
  final DialogService _dialogManager;

  SceneService(this._routerService, this._dialogManager);

  RouterComponent createRouter(Vector2 gameSize) {
    final dialogRoutes = _dialogManager.getDialogRoutes();
    final router = _routerService.createRouter(
      gameSize,
      additionalRoutes: dialogRoutes,
    );
    _dialogManager.initialize(router: router);
    return router;
  }
}
