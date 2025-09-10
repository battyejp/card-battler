import 'package:flame/events.dart';
import 'package:card_battler/game/ui/components/card/card_pile.dart';

class CardDeck extends CardPile with TapCallbacks {
  final void Function()? onTap;

  CardDeck(super.model, {this.onTap});

  @override
  bool onTapUp(TapUpEvent event) {
    onTap?.call();
    return true;
  }
}