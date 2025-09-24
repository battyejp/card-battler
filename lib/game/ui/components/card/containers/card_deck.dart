import 'package:card_battler/game/ui/components/card/containers/card_pile.dart';
import 'package:flame/events.dart';

class CardDeck extends CardPile with TapCallbacks {
  CardDeck(
    this.onTap,
    coordinator, {
    double scale = 1.0,
    String backImageFilename = 'card_face_down_0.08.png',
  }) : super(coordinator, scale: scale, backImageFilename: backImageFilename);

  final void Function() onTap;

  @override
  bool onTapUp(TapUpEvent event) {
    onTap();
    return true;
  }
}
