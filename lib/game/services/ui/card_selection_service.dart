import 'package:card_battler/game/services/card/cards_selection_manager_service.dart';
import 'package:card_battler/game/services/game/game_phase_manager.dart';
import 'package:card_battler/game/services/player/active_player_manager.dart';
import 'package:card_battler/game/services/ui/card_animation_service.dart';
import 'package:card_battler/game/services/ui/card_ui_state_service.dart';
import 'package:card_battler/game/ui/components/card/actionable_card.dart';

class CardSelectionService {
  CardSelectionService({
    required ActionableCard card,
    required CardsSelectionManagerService cardsSelectionManagerService,
    required GamePhaseManager gamePhaseManager,
    required ActivePlayerManager activePlayerManager,
  }) : _card = card,
       _cardsSelectionManagerService = cardsSelectionManagerService,
       _animationService = CardAnimationService(card: card),
       _uiStateService = CardUIStateService(
         card: card,
         gamePhaseManager: gamePhaseManager,
         //  activePlayerManager: activePlayerManager,
       );

  final ActionableCard _card;
  final CardsSelectionManagerService _cardsSelectionManagerService;
  final CardAnimationService _animationService;
  final CardUIStateService _uiStateService;

  bool get isAnyCardSelected => _cardsSelectionManagerService.hasSelection;

  void onDeselect() {
    _deselect();
  }

  void _deselect() {
    if (_animationService.isAnimating) {
      return;
    }

    _cardsSelectionManagerService.deselectCard();
    _uiStateService.updateDeselectionUIState();

    _animationService.animateToDeselection(() {
      // Animation complete
    });
  }
}
