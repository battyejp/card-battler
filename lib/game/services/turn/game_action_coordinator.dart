import 'package:card_battler/game/models/game_state_model.dart';
import 'package:card_battler/game/components/scenes/player_turn_scene.dart';

/// Service responsible for coordinating game actions and background interactions
/// This class handles game logic delegation and user interactions, following the Single Responsibility Principle
class GameActionCoordinator {
  static final GameActionCoordinator _instance = GameActionCoordinator._internal();
  factory GameActionCoordinator() => _instance;
  GameActionCoordinator._internal();

  PlayerTurnScene? _playerTurnScene;

  /// Initialize the coordinator with required scenes
  void initialize({PlayerTurnScene? playerTurnScene}) {
    _playerTurnScene = playerTurnScene;
  }

  /// Handle turn button press - delegates to the model appropriately
  void handleTurnButtonPress() {
    GameStateModel.instance.playerTurn.handleTurnButtonPress();
  }

  /// Handle background tap to deselect any selected cards
  void handleBackgroundDeselection() {
    // For now, only handle player turn scene deselection
    // This can be extended for other scenes if needed
    _playerTurnScene?.cardSelectionService.deselectCard();
  }

  /// Update the player turn scene reference when it changes
  void updatePlayerTurnScene(PlayerTurnScene? scene) {
    _playerTurnScene = scene;
  }

  /// Get debug information about current coordinator state
  String get debugInfo => 'GameActionCoordinator: ${_playerTurnScene != null ? 'scene initialized' : 'no scene'}';
}