import 'package:card_battler/game/models/game_state_model.dart';

/// Interface for game state operations
/// This abstracts game state management away from domain models
abstract class GameStateService {
  /// Get the current game phase
  GamePhase get currentPhase;
  
  /// Advance to the next game phase
  void nextPhase();
  
  /// Request confirmation dialog (for when player wants to end turn with cards)
  void requestConfirmation();
}

/// Default implementation that delegates to GameStateManager
/// This allows models to be decoupled from the concrete GameStateManager
class DefaultGameStateService implements GameStateService {
  final dynamic _gameStateManager;
  
  DefaultGameStateService(this._gameStateManager);
  
  @override
  GamePhase get currentPhase => _gameStateManager.currentPhase;
  
  @override
  void nextPhase() => _gameStateManager.nextPhase();
  
  @override
  void requestConfirmation() => _gameStateManager.requestConfirmation();
}