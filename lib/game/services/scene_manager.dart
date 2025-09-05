import 'package:card_battler/game/components/shared/confirm_dialog.dart';
import 'package:card_battler/game/models/game_state_model.dart';
import 'package:card_battler/game/scenes/enemy_turn_scene.dart';
import 'package:card_battler/game/scenes/player_turn_scene.dart';
import 'package:card_battler/game/services/game_state_manager.dart';
import 'package:flame/game.dart';

/// Dedicated service for managing scene transitions and routing operations
/// This separates navigation concerns from the game class and provides clean API for scene changes
class SceneManager {
  static final SceneManager _instance = SceneManager._internal();
  factory SceneManager() => _instance;
  SceneManager._internal();

  late RouterComponent _router;
  late PlayerTurnScene _playerTurnScene;
  final GameStateManager _gameStateManager = GameStateManager();

  /// Initialize the scene manager with required components
  void initialize({
    required RouterComponent router,
    required PlayerTurnScene playerTurnScene,
  }) {
    _router = router;
    _playerTurnScene = playerTurnScene;
  }

  /// Create and configure the router component with all routes
  RouterComponent createRouter(Vector2 gameSize) {
    _playerTurnScene = PlayerTurnScene(
      model: GameStateModel.instance.playerTurn,
      size: gameSize,
    );

    _router = RouterComponent(
      routes: {
        'playerTurn': Route(() => _playerTurnScene),
        'enemyTurn': Route(() => EnemyTurnScene(
          model: GameStateModel.instance.enemyTurnArea,
          size: gameSize,
        )),
        'confirm': OverlayRoute((context, game) {
          return ConfirmDialog(
            title: 'You still have cards in your hand!',
            onCancel: _handleConfirmCancel,
            onConfirm: _handleConfirmAccept,
          );
        }),
      },
      initialRoute: 'playerTurn',
    );

    // Set up listeners for automatic scene transitions
    _setupPhaseListener();
    _setupConfirmationListener();

    return _router;
  }

  /// Transition to player turn scene
  void goToPlayerTurn() {
    _router.pushNamed('playerTurn');
  }

  /// Transition to enemy turn scene
  void goToEnemyTurn() {
    _router.pushNamed('enemyTurn');
  }

  /// Show confirmation dialog for ending turn with cards
  void showEndTurnConfirmation() {
    _router.pushNamed('confirm');
  }

  /// Handle enemy turn completion with delay (called via phase transitions)
  void _handleEnemyTurnToPlayerTurn() {
    Future.delayed(const Duration(seconds: 1), () {
      _router.pop();
    });
  }

  /// End player turn properly through the model
  void endPlayerTurn() {
    GameStateModel.instance.playerTurn.endTurn();
  }

  /// Handle confirmation dialog cancel
  void _handleConfirmCancel() {
    _router.pop();
  }

  /// Handle confirmation dialog accept
  void _handleConfirmAccept() {
    _router.pop();
    endPlayerTurn();
  }

  /// Pop current route (generic navigation)
  void pop() {
    _router.pop();
  }

  /// Set up phase change listener for automatic scene transitions
  void _setupPhaseListener() {
    _gameStateManager.addPhaseChangeListener((previousPhase, newPhase) {
      if (newPhase == GamePhase.enemyTurn) {
        goToEnemyTurn();
      } else if (previousPhase == GamePhase.enemyTurn && newPhase == GamePhase.playerTurn) {
        _handleEnemyTurnToPlayerTurn();
      }
    });
  }

  /// Set up confirmation request listener
  void _setupConfirmationListener() {
    _gameStateManager.addConfirmationRequestListener(() {
      showEndTurnConfirmation();
    });
  }

  /// Handle turn button press - delegates to the model appropriately
  void handleTurnButtonPress() {
    GameStateModel.instance.playerTurn.handleTurnButtonPress();
  }

  /// Handle background tap to deselect any selected cards
  void handleBackgroundDeselection() {
    // For now, only handle player turn scene deselection
    // This can be extended for other scenes if needed
    _playerTurnScene.cardSelectionService.deselectCard();
  }

  /// Get debug information about current routing state
  String get debugInfo => 'SceneManager: router initialized';
}