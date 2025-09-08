import 'package:card_battler/game/models/game_state_model.dart';
import 'package:card_battler/game/models/player/player_turn_state.dart';
import 'package:card_battler/game/services/game_state/game_state_facade.dart';
import 'package:card_battler/game/services/game_state/game_state_service.dart';
import 'package:card_battler/game/services/ui/scene_manager.dart';

/// Service responsible for managing turn state and transitions
/// Follows the Single Responsibility Principle by focusing solely on turn management logic
abstract class TurnManager {
  /// Ends the current turn and transitions to next phase
  void endTurn(PlayerTurnState state);
  
  /// Handles turn button press logic based on current game state
  void handleTurnButtonPress(PlayerTurnState state);
}

/// Default implementation of TurnManager
class DefaultTurnManager implements TurnManager {
  final GameStateService _gameStateService;
  final SceneManager _sceneManager = SceneManager();

  DefaultTurnManager(this._gameStateService);

  @override
  void endTurn(PlayerTurnState state) {
    //TODO clear coins
    //TODO clear Attack

    GameStateFacade.instance.selectedPlayer!.turnOver = true;
    state.playerModel.discardHand();
    state.shopModel.refillShop();
    _gameStateService.nextPhase(); // Should be waitingToDrawCards

    if (state.playerModel.deckCards.hasNoCards) {
      state.playerModel.moveDiscardCardsToDeck();
    }
  }

  void _handleSwitchToNextPlayer() {
    GameStateFacade.instance.selectedPlayer!.turnOver = false;
    final newPlayer = GameStateFacade.instance.switchToNextPlayer();
    
    // Inform PlayerTurnScene to update player component with the new active player
    if (newPlayer != null) {
      _sceneManager.playerTurnScene?.addPlayerComponent(newPlayer);
    }

    if (!GameStateFacade.instance.selectedPlayer!.handCards.cards.isNotEmpty) {
      _gameStateService.setPhase(GamePhase.waitingToDrawCards);
    }
    else {
      _gameStateService.setPhase(GamePhase.cardsDrawnWaitingForEnemyTurn);
    }
  }

  void _handleEndPlayerTurn(PlayerTurnState state) {
    if (state.playerModel.handCards.cards.isNotEmpty) {
      _gameStateService.requestConfirmation();
    }
    else {
      endTurn(state);
    }
  }

  @override
  void handleTurnButtonPress(PlayerTurnState state) {
    switch (_gameStateService.currentPhase) { //currentPhase is the last state as it is about to change
      case GamePhase.playerTurn:
        _handleEndPlayerTurn(state);
        break;
      case GamePhase.cardsDrawnWaitingForPlayerSwitch:
        _handleSwitchToNextPlayer();
        break;
      default:
        _gameStateService.nextPhase();
        return;
    }
  }
}