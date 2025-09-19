import 'package:card_battler/game/ui/components/scenes/layout_stuff/player/card_sprite.dart';
import 'package:flame/components.dart';

class CardPile extends PositionComponent {
  CardPile({
    this.cardImagePath = 'card_face_down_0.03.png',
    this.cardWidth = 100,
    this.cardHeight = 140,
    Vector2? position,
  }) : super(position: position ?? Vector2.zero());
  final String cardImagePath;
  final double cardWidth;
  final double cardHeight;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // Fan out 4 cards with slight rotation and offset
    final offsets = [
      Vector2(-10, 0),
      Vector2(0, 0),
      Vector2(10, 0),
      Vector2(20, 0),
    ];
    final angles = [-0.15, -0.05, 0.05, 0.15];

    for (var i = 0; i < 4; i++) {
      add(
        CardSprite(Vector2.zero(), cardImagePath)
          ..position = offsets[i]
          ..angle = angles[i],
      );
    }
  }
}
