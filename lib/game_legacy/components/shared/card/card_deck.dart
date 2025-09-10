import 'package:card_battler/game_legacy/components/shared/card/card_pile.dart';
import 'package:flame/events.dart';

class CardDeck extends CardPile with TapCallbacks {
  final void Function()? onTap;

  CardDeck(super.model, {this.onTap});

  @override
  bool onTapUp(TapUpEvent event) {
    onTap?.call();
    return true;
  }
}