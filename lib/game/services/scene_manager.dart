import 'package:card_battler/game/services/router_service.dart';
import 'package:card_battler/game/services/dialog_manager_service.dart';
import 'package:card_battler/game/services/game_action_coordinator.dart';
import 'package:card_battler/game/scenes/player_turn_scene.dart';
import 'package:flame/game.dart';

/// Orchestrates scene management by coordinating specialized services
/// This class now follows SRP by delegating specific responsibilities to dedicated services
class SceneManager {
  static final SceneManager _instance = SceneManager._internal();
  factory SceneManager() => _instance;
  SceneManager._internal();

  final RouterService _routerService = RouterService();
  final DialogManagerService _dialogManager = DialogManagerService();
  final GameActionCoordinator _gameActionCoordinator = GameActionCoordinator();


  /// Create and configure the router component with all routes
  RouterComponent createRouter(Vector2 gameSize) {
    final dialogRoutes = _dialogManager.getDialogRoutes();
    final router = _routerService.createRouter(gameSize, additionalRoutes: dialogRoutes);
    _dialogManager.initialize(router: router);
    _gameActionCoordinator.updatePlayerTurnScene(_routerService.playerTurnScene);
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
  void handleTurnButtonPress() {
    _gameActionCoordinator.handleTurnButtonPress();
  }

  /// Handle background tap to deselect any selected cards
  void handleBackgroundDeselection() {
    _gameActionCoordinator.handleBackgroundDeselection();
  }

  /// Get the current player turn scene for updating components
  PlayerTurnScene? get playerTurnScene => _routerService.playerTurnScene;

  /// Get debug information about current scene management state
  String get debugInfo => 'SceneManager: ${_routerService.debugInfo}, ${_dialogManager.debugInfo}, ${_gameActionCoordinator.debugInfo}';
}