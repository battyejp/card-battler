import 'package:flame/events.dart';
import 'package:card_battler/game/ui/components/card/card_pile.dart';

class CardDeck extends CardPile with TapCallbacks {
  final void Function()? onTap;

  CardDeck({this.onTap, required super.coordinator})
      : super(showNext: false);

  @override
  bool onTapUp(TapUpEvent event) {
    onTap?.call();
    return true;
  }
}