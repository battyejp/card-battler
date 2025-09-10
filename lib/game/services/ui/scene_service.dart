import 'package:card_battler/game/services/ui/dialog_service.dart';
import 'package:card_battler/game/services/ui/router_service.dart';
import 'package:flame/game.dart';

/// Orchestrates scene management by coordinating specialized services
/// This class now follows SRP by delegating specific responsibilities to dedicated services
class SceneService {
  static final SceneService _instance = SceneService._internal();
  factory SceneService() => _instance;
  SceneService._internal();

  final RouterService _routerService = RouterService();
  final DialogService _dialogManager = DialogService();
  //final GameActionCoordinator _gameActionCoordinator = GameActionCoordinator();


  /// Create and configure the router component with all routes
  RouterComponent createRouter(Vector2 gameSize) {
    final dialogRoutes = _dialogManager.getDialogRoutes();
    final router = _routerService.createRouter(gameSize, additionalRoutes: dialogRoutes);
    _dialogManager.initialize(router: router);
    //_gameActionCoordinator.updatePlayerTurnScene(_routerService.playerTurnScene);
    return router;
  }

  /// Transition to player turn scene
  void goToPlayerTurn() {
    _routerService.goToPlayerTurn();
  }

  /// Transition to enemy turn scene
  void goToEnemyTurn() {
    _routerService.goToEnemyTurn();
  }

  /// Show confirmation dialog for ending turn with cards
  void showEndTurnConfirmation() {
    _dialogManager.showEndTurnConfirmation();
  }

  /// Pop current route (generic navigation)
  void pop() {
    _routerService.pop();
  }

  /// Handle turn button press - delegates to the model appropriately
  // void handleTurnButtonPress() {
  //   _gameActionCoordinator.handleTurnButtonPress();
  // }

  /// Handle background tap to deselect any selected cards
  // void handleBackgroundDeselection() {
  //   _gameActionCoordinator.handleBackgroundDeselection();
  // }
}