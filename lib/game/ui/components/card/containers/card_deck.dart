import 'package:card_battler/game/ui/components/card/containers/card_pile.dart';
import 'package:flame/events.dart';

class CardDeck extends CardPile with TapCallbacks {
  CardDeck({required this.onTap, required coordinator})
    : super(coordinator, showNext: false);

  final void Function() onTap;

  @override
  bool onTapUp(TapUpEvent event) {
    onTap();
    return true;
  }
}
