import 'package:card_battler/game/coordinators/common/reactive_coordinator.dart';
import 'package:card_battler/game/services/game/game_phase_manager.dart';
import 'package:card_battler/game/services/player/active_player_manager.dart';
import 'package:card_battler/game/services/ui/dialog_service.dart';

class TurnButtonComponentCoordinator
    with ReactiveCoordinator<TurnButtonComponentCoordinator> {
  TurnButtonComponentCoordinator({
    required GamePhaseManager gamePhaseManager,
    required DialogService dialogService,
    required ActivePlayerManager activePlayerManager,
  }) : _gamePhaseManager = gamePhaseManager,
       _dialogService = dialogService,
       _activePlayerManager = activePlayerManager {
    _gamePhaseManager.addPhaseChangeListener(_onGamePhaseChanged);
  }

  final GamePhaseManager _gamePhaseManager;
  final DialogService _dialogService;
  final ActivePlayerManager _activePlayerManager;

  String buttonText = "End Turn";
  bool buttonVisible = false;

  void handleTurnButtonPressed() {
    if (_gamePhaseManager.currentPhase == GamePhase.playerTakeActionsTurn &&
        _activePlayerManager
            .activePlayer!
            .handCardsCoordinator
            .cardCoordinators
            .isNotEmpty) {
      _dialogService.showCustomConfirmation(
        title: 'Confirm End Turn',
        message:
            'You still have cards to play, are you sure you want to end your turn?',
        onConfirm: _gamePhaseManager.nextPhase,
        onCancel: () {},
      );
    } else if (_gamePhaseManager.currentPhase ==
        GamePhase.playerCardsDrawnWaitingForPlayerSwitch) {
      _dialogService.showCustomConfirmation(
        title: 'Confirm Player Switch',
        message: 'Pass device to next player.',
        onConfirm: _gamePhaseManager.nextPhase,
        onCancel: () {},
      );
    } else {
      _gamePhaseManager.nextPhase();
    }
  }

  void _onGamePhaseChanged(GamePhase previousPhase, GamePhase newPhase) {
    var newButtonText = buttonText;
    var newButtonVisible = buttonVisible;

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

  @override
  void dispose() {
    super.dispose();
    _gamePhaseManager.removePhaseChangeListener(_onGamePhaseChanged);
  }
}
