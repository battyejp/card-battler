enum GamePhase {
  /// Initial phase when waiting for player to draw cards
  waitingToDrawPlayerCards,

  /// Phase after player has drawn their cards but before enemy turn
  playerCardsDrawnWaitingForEnemyTurn,

  /// Enemy's turn to play cards and take actions
  enemyTurnWaitingToDrawCards,

  /// Phase after enemy has drawn their cards
  enemiesTurnCardsDrawnWaitingForPlayersTurn,

  /// Player's turn to play cards and take actions
  playerTakeActionsTurn,

  /// Phase to switch to the next player after cards have been drawn
  playerCardsDrawnWaitingForPlayerSwitch,
}

//TODO consider stopping being a singleton as hard to test
/// Dedicated service for managing game state transitions and phase management
/// This extracts state management concerns from the GameStateModel singleton
class GamePhaseManager {
  // Private constructor
  GamePhaseManager._();

  // Static instance variable
  static final GamePhaseManager _instance = GamePhaseManager._();

  // Public getter for the singleton instance
  static GamePhaseManager get instance => _instance;

  // Factory constructor that returns the singleton instance
  factory GamePhaseManager() => _instance;

  // Current phase state
  GamePhase _currentPhase = GamePhase.waitingToDrawPlayerCards;

  // Previous phase state (for reference)
  GamePhase _previousPhase = GamePhase.waitingToDrawPlayerCards;

  // Listeners for phase changes
  final List<Function(GamePhase, GamePhase)> _phaseChangeListeners = [];

  // Listeners for turn button confirmation requests
  //final List<VoidCallback> _confirmationRequestListeners = [];

  /// Get current game phase
  GamePhase get currentPhase {
    return _currentPhase;
  }

  /// Add a listener for phase changes
  /// Callback receives (previousPhase, newPhase)
  void addPhaseChangeListener(Function(GamePhase, GamePhase) listener) {
    _phaseChangeListeners.add(listener);
  }

  /// Remove a phase change listener
  void removePhaseChangeListener(Function(GamePhase, GamePhase) listener) {
    _phaseChangeListeners.remove(listener);
  }

  /// Notify all listeners of phase change
  void _notifyPhaseChange(GamePhase previousPhase, GamePhase newPhase) {
    for (final listener in _phaseChangeListeners) {
      try {
        listener(previousPhase, newPhase);
      } catch (e) {
        // Continue notifying other listeners even if one fails
        // Log error - in production, this should use proper logging
        // print('Error in phase change listener: $e');
      }
    }
  }

  /// Add a listener for turn confirmation requests
  // void addConfirmationRequestListener(VoidCallback listener) {
  //   _confirmationRequestListeners.add(listener);
  // }

  /// Remove a confirmation request listener
  // void removeConfirmationRequestListener(VoidCallback listener) {
  //   _confirmationRequestListeners.remove(listener);
  // }

  /// Request confirmation dialog (for when player wants to end turn with cards)
  // void requestConfirmation() {
  //   for (final listener in _confirmationRequestListeners) {
  //     try {
  //       listener();
  //     } catch (e) {
  //       // Continue notifying other listeners even if one fails
  //       // Log error - in production, this should use proper logging
  //       // print('Error in confirmation request listener: $e');
  //     }
  //   }
  // }

  /// Clear all listeners (useful for testing)
  // void clearListeners() {
  //   _phaseChangeListeners.clear();
  //   _confirmationRequestListeners.clear();
  // }

  /// Set the game phase directly
  /// This should be used sparingly; prefer nextPhase() for normal flow
  // void setPhase(GamePhase newPhase) {
  //   _setPhase(newPhase);
  // }

  /// Advance to the next logical phase
  GamePhase nextPhase() {
    switch (_currentPhase) {
      case GamePhase.playerCardsDrawnWaitingForEnemyTurn:
        _setPhase(GamePhase.enemyTurnWaitingToDrawCards);
        break;
      case GamePhase.enemyTurnWaitingToDrawCards:
        _setPhase(GamePhase.enemiesTurnCardsDrawnWaitingForPlayersTurn);
        break;
      case GamePhase.enemiesTurnCardsDrawnWaitingForPlayersTurn:
        _setPhase(GamePhase.playerTakeActionsTurn);
        break;
      case GamePhase.playerTakeActionsTurn:
        _setPhase(GamePhase.waitingToDrawPlayerCards);
        break;
      case GamePhase.waitingToDrawPlayerCards:
        if (_previousPhase == GamePhase.playerTakeActionsTurn) {
          _setPhase(GamePhase.playerCardsDrawnWaitingForPlayerSwitch);
        } else {
          _setPhase(GamePhase.playerCardsDrawnWaitingForEnemyTurn);
        }
        break;
      case GamePhase.playerCardsDrawnWaitingForPlayerSwitch:
        //_setPhase(GamePhase.playerCardsDrawnWaitingForEnemyTurn);
        _setPhase(GamePhase.waitingToDrawPlayerCards);
        break;
    }

    return _currentPhase;
  }

  /// Set game phase with proper notification
  void _setPhase(GamePhase newPhase) {
    if (_currentPhase != newPhase) {
      _previousPhase = _currentPhase;
      _currentPhase = newPhase;

      // Notify all listeners
      _notifyPhaseChange(_previousPhase, newPhase);
    }
  }

  /// Reset the state manager (useful for testing)
  // void reset() {
  //   _currentPhase = GamePhase.waitingToDrawCards;
  //   _phaseChangeListeners.clear();
  // }
}
