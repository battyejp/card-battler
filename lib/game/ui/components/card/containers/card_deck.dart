import 'package:card_battler/game/ui/components/card/containers/card_pile.dart';
import 'package:flame/components.dart';
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
    print('CardDeck.onTapUp called at ${event.localPosition}');
    onTap();
    return true;
  }

  @override
  bool containsLocalPoint(Vector2 point) {
    final result = super.containsLocalPoint(point);
    print('CardDeck.containsLocalPoint($point) = $result, size=$size, position=$position');
    return result;
  }
}
