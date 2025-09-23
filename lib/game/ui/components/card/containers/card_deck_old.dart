import 'package:card_battler/game/ui/components/card/containers/card_pile_old.dart';
import 'package:flame/events.dart';

class CardDeckOld extends CardPileOld with TapCallbacks {
  CardDeckOld({required this.onTap, required coordinator})
    : super(coordinator, showNext: false);

  final void Function() onTap;

  @override
  bool onTapUp(TapUpEvent event) {
    onTap();
    return true;
  }
}
