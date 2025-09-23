import 'package:card_battler/game/ui/components/card/card_sprite.dart';
import 'package:flame/components.dart';

class CardPile extends PositionComponent {
  CardPile();

  @override
  Future<void> onLoad() async {
    super.onLoad();

    for (var i = 0; i < 10; i++) {
      add(
        CardSprite(Vector2.zero(), 'card_face_down_0.08.png')
          ..position = Vector2(-i * 1.0 + size.x / 2, -i * 1.0 + size.y / 2)
          ..anchor = Anchor.center,
      );
    }
  }
}
