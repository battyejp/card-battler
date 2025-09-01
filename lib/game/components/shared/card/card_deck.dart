import 'package:card_battler/game/components/shared/card/card_pile.dart';
import 'package:flame/events.dart';

class CardDeck extends CardPile with TapCallbacks {
  final void Function()? onTap;

  CardDeck(super.model, {this.onTap});

  @override
  bool get debugMode => true;

  @override
  bool onTapUp(TapUpEvent event) {
    onTap?.call();
    return true;
  }
}