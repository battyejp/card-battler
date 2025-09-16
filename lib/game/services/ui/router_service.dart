import 'package:card_battler/game/coordinators/components/scenes/enemy_turn_scene_coordinator.dart';
import 'package:card_battler/game/coordinators/components/scenes/player_turn_scene_coordinator.dart';
import 'package:card_battler/game/services/game/game_phase_manager.dart';
import 'package:card_battler/game/ui/components/scenes/enemy_turn_scene.dart';
import 'package:card_battler/game/ui/components/scenes/player_turn_scene.dart';
import 'package:flame/game.dart';

class RouterService {
  RouterComponent? _router;
  PlayerTurnScene? _playerTurnScene;
  EnemyTurnScene? _enemyTurnScene;
  GamePhaseManager? _gamePhaseManager;

  /// Create and configure the router component with scene routes
  RouterComponent createRouter(
    Vector2 gameSize,
    PlayerTurnSceneCoordinator playerTurnSceneCoordinator,
    EnemyTurnSceneCoordinator enemyTurnSceneCoordinator,
    GamePhaseManager gamePhaseManager, {
    Map<String, Route>? additionalRoutes,
  }) {
    _gamePhaseManager = gamePhaseManager;

    _playerTurnScene = PlayerTurnScene(
      playerTurnSceneCoordinator,
      size: gameSize,
    );

    _enemyTurnScene = EnemyTurnScene(
      coordinator: enemyTurnSceneCoordinator,
      size: gameSize,
    );

    final routes = {
      'playerTurn': Route(() => _playerTurnScene!),
      'enemyTurn': Route(() => _enemyTurnScene!),
    };

    // Add additional routes if provided
    if (additionalRoutes != null) {
      routes.addAll(additionalRoutes);
    }

    _router = RouterComponent(routes: routes, initialRoute: 'playerTurn');
    _gamePhaseManager?.addPhaseChangeListener(_onGamePhaseChanged);
    return _router!;
  }

  void _onGamePhaseChanged(GamePhase previousPhase, GamePhase newPhase) {
    if (newPhase == GamePhase.enemyTurnWaitingToDrawCards) {
      goToEnemyTurn();
    } else if (previousPhase == GamePhase.enemyTurnWaitingToDrawCards &&
        newPhase == GamePhase.playerTakeActionsTurn) {
      _handleEnemyTurnToPlayerTurn();
    }

    switch (newPhase) {
      case GamePhase.enemyTurnWaitingToDrawCards:
        goToEnemyTurn();
        break;
      case GamePhase.playerTakeActionsTurn:
        goToPlayerTurn();
        break;
      default:
        break;
    }
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

  void _handleEnemyTurnToPlayerTurn() {
    pop();
  }

  void dispose() {
    _gamePhaseManager?.removePhaseChangeListener(_onGamePhaseChanged);
  }
}
