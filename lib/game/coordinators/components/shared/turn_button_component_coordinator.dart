import 'package:card_battler/game/coordinators/common/reactive_coordinator.dart';
import 'package:card_battler/game/services/game_state/game_phase_manager.dart';

class TurnButtonComponentCoordinator
    with ReactiveCoordinator<TurnButtonComponentCoordinator> {
  final GamePhaseManager _gamePhaseManager;

  String buttonText = "End Turn";
  bool buttonVisible = false;

  TurnButtonComponentCoordinator({required GamePhaseManager gamePhaseManager})
    : _gamePhaseManager = gamePhaseManager {
    _gamePhaseManager.addPhaseChangeListener(_onGamePhaseChanged);
  }

  void handleTurnButtonPressed() {
    _gamePhaseManager.nextPhase();
  }

  void _onGamePhaseChanged(GamePhase previousPhase, GamePhase newPhase) {
    String newButtonText = buttonText;
    bool newButtonVisible = buttonVisible;

    switch (newPhase) {
      case GamePhase.playerCardsDrawnWaitingForEnemyTurn:
        newButtonText = 'Take Enemy Turn';
        break;
      case GamePhase.playerTakeActionsTurn:
        newButtonText = 'End Turn';
        break;
      case GamePhase.playerCardsDrawnWaitingForPlayerSwitch:
        newButtonText = 'Switch Player';
        break;
      case GamePhase.enemyTurnWaitingToDrawCards:
        newButtonText = 'End Enemy Turn';
        break;
      default:
        break;
    }

    newButtonVisible =
        newPhase != GamePhase.waitingToDrawPlayerCards &&
        newPhase != GamePhase.enemyTurnWaitingToDrawCards;

    // Only notify if something changed
    if (newButtonText != buttonText || newButtonVisible != buttonVisible) {
      buttonText = newButtonText;
      buttonVisible = newButtonVisible;
      notifyChange();
    }
  }

  //TODO think this needs to be called somewhere or perhaps is does automatically?
  @override
  void dispose() {
    super.dispose();
    _gamePhaseManager.removePhaseChangeListener(_onGamePhaseChanged);
  }
}
