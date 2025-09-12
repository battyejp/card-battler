import 'package:flame/events.dart';
import 'package:card_battler/game/ui/components/card/card_pile.dart';

class CardDeck extends CardPile with TapCallbacks {
  final void Function() onTap;

  CardDeck({required this.onTap, required coordinator})
    : super(coordinator, showNext: false);

  @override
  bool onTapUp(TapUpEvent event) {
    onTap();
    return true;
  }
}
