import 'package:card_battler/game/components/shared/card/actionable_card.dart';
import 'package:card_battler/game/components/shared/card/card_interaction_controller.dart';
import 'package:card_battler/game/services/card_interaction_service.dart';
import 'package:flame/events.dart';

class TapableActionableCard extends ActionableCard with TapCallbacks {
  CardInteractionController? _interaction;
  bool Function()? _determineIfButtonEnabled;
  CardInteractionService? _cardInteractionService;

  TapableActionableCard(
    super.cardModel, 
    {
      super.onButtonPressed, 
      bool Function()? determineIfButtonEnabled,
      CardInteractionService? cardInteractionService,
    }
  ) {
    _determineIfButtonEnabled = determineIfButtonEnabled;
    _cardInteractionService = cardInteractionService;
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
    );
  }
}