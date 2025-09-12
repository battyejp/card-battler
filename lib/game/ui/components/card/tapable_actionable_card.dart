import 'package:card_battler/game/services/card/card_selection_service.dart';
import 'package:card_battler/game/ui/components/card/actionable_card.dart';
import 'package:flame/events.dart';

class SelectedActionableCard extends ActionableCard with TapCallbacks {
  late final CardSelectionService _interactionService;
  // bool Function()? _determineIfButtonEnabled;
  // CardInteractionService? _cardInteractionService;
  // CardSelectionService? _cardSelectionService;

  SelectedActionableCard(super.coordinator);

  @override
  void onLoad() {
    super.onLoad();
    _interactionService = CardSelectionService(
      card: this,
      cardsSelectionManagerService: coordinator.selectionManagerService,
      gamePhaseManager: coordinator.gamePhaseManager,
    );
  }

  // {
  // bool Function()? determineIfButtonEnabled,
  // CardInteractionService? cardInteractionService,
  // CardSelectionService? cardSelectionService,) {
  // _determineIfButtonEnabled = determineIfButtonEnabled;
  // _cardInteractionService = cardInteractionService;
  // _cardSelectionService = cardSelectionService;
  //}

  @override
  bool onTapUp(TapUpEvent event) => _interactionService.onSelected(event);

  // @override
  // void onLoad() {
  //   super.onLoad();
  //   _interaction = CardInteractionController.withServices(
  //     this,
  //     determineIfButtonEnabled: _determineIfButtonEnabled,
  //     cardInteractionService: _cardInteractionService,
  //     cardSelectionService: _cardSelectionService,
  //   );
  // }

  // @override
  // void onRemove() {
  //   _interaction?.dispose();
  //   super.onRemove();
  // }
}
