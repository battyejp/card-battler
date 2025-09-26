import 'package:card_battler/game/services/game/game_phase_manager.dart';
import 'package:card_battler/game/ui/components/card/actionable_card.dart';
import 'package:card_battler/game/ui/components/card/selectable_card.dart';

class CardUIStateService {
  CardUIStateService({
    required ActionableCard card,
    required GamePhaseManager gamePhaseManager,
    // required ActivePlayerManager activePlayerManager,
  }) : _card = card,
       _gamePhaseManager = gamePhaseManager;
      //  _activePlayerManager = activePlayerManager;

  final ActionableCard _card;
  final GamePhaseManager _gamePhaseManager;
  // final ActivePlayerManager _activePlayerManager;

  void updateSelectionUIState() {
    _card.isActionButtonVisible =
        _gamePhaseManager.currentPhase == GamePhase.playerTakeActionsTurn;

    // _card.actionButtonDisabled = _card.coordinator.isActionDisabled(
    //   _activePlayerManager.activePlayer!.playerInfoCoordinator,
    // );
  }

  void updateDeselectionUIState() {
    _card.isActionButtonVisible = false;

    if (_card is SelectableCard) {
      _card.isCloseButtonVisible = false;
    }
  }
}
