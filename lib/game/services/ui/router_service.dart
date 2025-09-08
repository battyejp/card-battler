import 'package:card_battler/game/models/game_state_model.dart';
import 'package:card_battler/game/scenes/enemy_turn_scene.dart';
import 'package:card_battler/game/scenes/player_turn_scene.dart';
import 'package:card_battler/game/services/game_state/game_state_manager.dart';
import 'package:flame/game.dart';

/// Service responsible for managing scene transitions and routing operations
/// This class handles all navigation logic, following the Single Responsibility Principle
class RouterService {
  static final RouterService _instance = RouterService._internal();
  factory RouterService() => _instance;
  RouterService._internal();

  RouterComponent? _router;
  PlayerTurnScene? _playerTurnScene;
  final GameStateManager _gameStateManager = GameStateManager();

  /// Create and configure the router component with scene routes
  RouterComponent createRouter(Vector2 gameSize, {Map<String, Route>? additionalRoutes}) {
    _playerTurnScene = PlayerTurnScene(
      model: GameStateModel.instance.playerTurn,
      size: gameSize,
    );

    final routes = {
      'playerTurn': Route(() => _playerTurnScene!),
      'enemyTurn': Route(() => EnemyTurnScene(
        model: GameStateModel.instance.enemyTurnArea,
        size: gameSize,
      )),
    };

    if (additionalRoutes != null) {
      routes.addAll(additionalRoutes);
    }

    _router = RouterComponent(
      routes: routes,
      initialRoute: 'playerTurn',
    );

    _setupPhaseListener();
    return _router!;
  }

  /// Transition to player turn scene
  void goToPlayerTurn() {
    _router?.pushNamed('playerTurn');
  }

  /// Transition to enemy turn scene
  void goToEnemyTurn() {
    _router?.pushNamed('enemyTurn');
  }

  /// Pop current route (generic navigation)
  void pop() {
    _router?.pop();
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

  /// Handle enemy turn completion with delay (called via phase transitions)
  void _handleEnemyTurnToPlayerTurn() {
    Future.delayed(const Duration(seconds: 1), () {
      // Reset the enemy turn state for the next enemy turn
      GameStateModel.instance.enemyTurnArea.resetTurn();
      _router?.pop();
    });
  }

  /// Get the player turn scene reference (needed for background interactions)
  PlayerTurnScene? get playerTurnScene => _playerTurnScene;

  /// Get debug information about current routing state
  String get debugInfo => 'RouterService: router initialized';
}