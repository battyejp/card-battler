import 'package:card_battler/game/components/player/card_pile.dart';
import 'package:flame/events.dart';

class CardDeck extends CardPile with TapCallbacks {
  final void Function()? onTap;

  CardDeck(super.model, {this.onTap});

  @override
  void onTapUp(TapUpEvent event) {
    super.onTapUp(event);
    onTap?.call();
  }
}