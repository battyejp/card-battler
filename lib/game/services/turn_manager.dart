import 'package:card_battler/game/models/game_state_model.dart';
import 'package:card_battler/game/models/player/player_turn_state.dart';
import 'package:card_battler/game/services/game_state_service.dart';

/// Service responsible for managing turn state and transitions
/// Follows the Single Responsibility Principle by focusing solely on turn management logic
abstract class TurnManager {
  /// Discards all cards from player's hand
  void discardHand(PlayerTurnState state);
  
  /// Ends the current turn and transitions to next phase
  void endTurn(PlayerTurnState state);
  
  /// Handles turn button press logic based on current game state
  void handleTurnButtonPress(PlayerTurnState state);
}

/// Default implementation of TurnManager
class DefaultTurnManager implements TurnManager {
  final GameStateService _gameStateService;

  DefaultTurnManager(this._gameStateService);

  @override
  void discardHand(PlayerTurnState state) {
    state.playerModel.discardModel.addCards(state.playerModel.handModel.cards);
    state.playerModel.handModel.clearCards();
  }

  @override
  void endTurn(PlayerTurnState state) {
    //TODO clear coins
    //TODO clear Attack
    //TODO might need to shuffle discard back into deck

    discardHand(state);
    state.shopModel.refillShop();
    _gameStateService.nextPhase(); // Should be waitingToDrawCards
  }

  @override
  void handleTurnButtonPress(PlayerTurnState state) {
    if (_gameStateService.currentPhase == GamePhase.playerTurn) {
      if (state.playerModel.handModel.cards.isNotEmpty) {
        _gameStateService.requestConfirmation();
        return;
      }

      endTurn(state);
    } else {
      _gameStateService.nextPhase();
    }
  }
}