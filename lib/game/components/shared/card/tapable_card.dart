import 'package:card_battler/game/components/shared/card/card.dart';
import 'package:card_battler/game/components/shared/card/card_interaction_controller.dart';
import 'package:flame/events.dart';

class TapableCard extends Card with TapCallbacks {
  final void Function()? onTap;
    CardInteractionController? _interaction;

  TapableCard(super.cardModel, {this.onTap});

  @override
  bool onTapUp(TapUpEvent event) => _interaction?.onTapUp(event) ?? false;

  @override
  void onLoad() {
    super.onLoad();
    _interaction = CardInteractionController(this);
  }
}