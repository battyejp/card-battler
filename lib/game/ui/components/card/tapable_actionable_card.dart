import 'package:card_battler/game/services/card/card_interaction_service.dart';
import 'package:card_battler/game/services/card/card_selection_service.dart';
import 'package:card_battler/game/ui/components/card/card_interaction_controller.dart';
import 'package:card_battler/game/ui/components/card/actionable_card.dart';
import 'package:flame/events.dart';

class TapableActionableCard extends ActionableCard with TapCallbacks {
  CardInteractionController? _interaction;
  bool Function()? _determineIfButtonEnabled;
  CardInteractionService? _cardInteractionService;
  CardSelectionService? _cardSelectionService;

  TapableActionableCard(
    super.cardModel, 
    {
      super.onButtonPressed, 
      bool Function()? determineIfButtonEnabled,
      CardInteractionService? cardInteractionService,
      CardSelectionService? cardSelectionService,
    }
  ) {
    _determineIfButtonEnabled = determineIfButtonEnabled;
    _cardInteractionService = cardInteractionService;
    _cardSelectionService = cardSelectionService;
  }

  @override
  bool onTapUp(TapUpEvent event) => _interaction?.onTapUp(event) ?? false;

  @override
  void onLoad() {
    super.onLoad();
    _interaction = CardInteractionController.withServices(
      this, 
      determineIfButtonEnabled: _determineIfButtonEnabled,
      cardInteractionService: _cardInteractionService,
      cardSelectionService: _cardSelectionService,
    );
  }
  
  @override
  void onRemove() {
    _interaction?.dispose();
    super.onRemove();
  }
}