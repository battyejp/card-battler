import 'package:card_battler/game/ui/components/card/containers/card_pile.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';

class CardDeck extends CardPile with TapCallbacks {
  CardDeck(this.onTap, coordinator, {required scale})
    : super(coordinator, scale: scale);

  final void Function() onTap;

  @override
  bool onTapUp(TapUpEvent event) {
    onTap();
    return true;
  }

  @override
  bool containsLocalPoint(Vector2 point) {
    final result = super.containsLocalPoint(point);
    return result;
  }
}
