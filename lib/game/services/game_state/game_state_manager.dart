import 'package:card_battler/game/models/game_state_model.dart';
import 'package:card_battler/game/services/game_state/game_state_facade.dart';
import 'package:flutter/foundation.dart';

//TODO lots of methods not used
/// Dedicated service for managing game state transitions and phase management
/// This extracts state management concerns from the GameStateModel singleton
class GameStateManager {
  static final GameStateManager _instance = GameStateManager._internal();
  factory GameStateManager() => _instance;
  GameStateManager._internal();

  // Current phase state
  GamePhase _currentPhase = GamePhase.waitingToDrawCards;

  // Listeners for phase changes
  final List<Function(GamePhase, GamePhase)> _phaseChangeListeners = [];
  
  // Listeners for turn button confirmation requests
  final List<VoidCallback> _confirmationRequestListeners = [];

  /// Get current game phase
  GamePhase get currentPhase {
    return _currentPhase;
  }

  /// Set game phase with proper notification
  void _setPhase(GamePhase newPhase) {
    if (_currentPhase != newPhase) {
      final previousPhase = _currentPhase;
      _currentPhase = newPhase;
      
      // Notify all listeners
      _notifyPhaseChange(previousPhase, newPhase);
    }
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
  void addConfirmationRequestListener(VoidCallback listener) {
    _confirmationRequestListeners.add(listener);
  }

  /// Remove a confirmation request listener
  void removeConfirmationRequestListener(VoidCallback listener) {
    _confirmationRequestListeners.remove(listener);
  }

  /// Request confirmation dialog (for when player wants to end turn with cards)
  void requestConfirmation() {
    for (final listener in _confirmationRequestListeners) {
      try {
        listener();
      } catch (e) {
        // Continue notifying other listeners even if one fails
        // Log error - in production, this should use proper logging
        // print('Error in confirmation request listener: $e');
      }
    }
  }

  /// Clear all listeners (useful for testing)
  void clearListeners() {
    _phaseChangeListeners.clear();
    _confirmationRequestListeners.clear();
  }

  /// Set the game phase directly
  /// This should be used sparingly; prefer nextPhase() for normal flow
  void setPhase(GamePhase newPhase) {
    _setPhase(newPhase);
  }

  /// Advance to the next logical phase
  void nextPhase() {
    switch (_currentPhase) {
      case GamePhase.cardsDrawnWaitingForEnemyTurn:
        _setPhase(GamePhase.enemyTurn);
        break;
      case GamePhase.enemyTurn:
        _setPhase(GamePhase.playerTurn);
        break;
      case GamePhase.playerTurn:
        _setPhase(GamePhase.waitingToDrawCards);
        break;
      case GamePhase.waitingToDrawCards:
        if (GameStateFacade.instance.selectedPlayer!.turnOver) {
          _setPhase(GamePhase.cardsDrawnWaitingForPlayerSwitch);
        } else {
          _setPhase(GamePhase.cardsDrawnWaitingForEnemyTurn);
        }
        break;
      case GamePhase.cardsDrawnWaitingForPlayerSwitch: //Taken card of else where
        break;
    }
  }

  /// Reset the state manager (useful for testing)
  void reset() {
    _currentPhase = GamePhase.waitingToDrawCards;
    _phaseChangeListeners.clear();
  }

  /// Get debug information about current state
  String get debugInfo => 'GameStateManager: currentPhase=$_currentPhase, listeners=${_phaseChangeListeners.length}';
}