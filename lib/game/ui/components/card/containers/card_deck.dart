import 'package:card_battler/game/ui/components/card/containers/card_pile.dart';
import 'package:flame/events.dart';

class CardDeck extends CardPile with TapCallbacks {
  CardDeck(
    this.onTap,
    coordinator, {
    required bool isMini, double scale = 1.0,
  }) : super(coordinator, scale: scale, isMini: isMini);

  final void Function() onTap;

  @override
  bool onTapUp(TapUpEvent event) {
    onTap();
    return true;
  }
}
