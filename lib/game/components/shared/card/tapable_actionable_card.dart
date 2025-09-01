import 'package:card_battler/game/components/shared/card/actionable_card.dart';
import 'package:card_battler/game/components/shared/card/card_interaction_controller.dart';
import 'package:flame/events.dart';

class TapableActionableCard extends ActionableCard with TapCallbacks {
  CardInteractionController? _interaction;

  TapableActionableCard(super.cardModel, {super.onButtonPressed});

  @override
  bool onTapUp(TapUpEvent event) => _interaction?.onTapUp(event) ?? false;

  @override
  void onLoad() {
    super.onLoad();
    _interaction = CardInteractionController(this);
  }
}