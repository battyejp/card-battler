import 'package:card_battler/game_legacy/models/enemy/enemy_turn_model.dart';

/// Service responsible for managing enemy turn state and transitions
/// Follows the Single Responsibility Principle by focusing solely on turn management logic
abstract class EnemyTurnManager {
  /// Completes the current enemy turn and transitions to next phase
  void completeTurn(EnemyTurnModel state);
  
  /// Resets the turn state for a new turn
  void resetTurn();
  
  /// Checks if the current turn is finished
  bool get isTurnFinished;
}

/// Default implementation of EnemyTurnManager
class DefaultEnemyTurnManager implements EnemyTurnManager {
  bool _turnFinished = false;

  DefaultEnemyTurnManager();

  @override
  void completeTurn(EnemyTurnModel state) {
    if (_turnFinished) {
      state.gameStateService.nextPhase(); // Should be playerTurn
    }
  }

  @override
  void resetTurn() {
    _turnFinished = false;
  }

  @override
  bool get isTurnFinished => _turnFinished;

  /// Internal method to mark turn as finished without triggering phase transition
  /// Used by EnemyCardDrawService to mark completion based on card effects
  void markTurnAsFinished() {
    _turnFinished = true;
  }
}