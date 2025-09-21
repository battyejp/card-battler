import 'dart:math' as math;

import 'package:card_battler/game/ui/components/scenes/layout_stuff/player/card_sprite.dart';
import 'package:flame/components.dart';

class CardPile extends PositionComponent {
  CardPile({
    this.cardImagePath = 'card_face_down_0.08.png',
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

    for (var i = 0; i < 10; i++) {
      add(
        CardSprite(Vector2.zero(), cardImagePath)
          ..position = Vector2(-i * 1.0, -i * 1.0),
      );
    }
  }
}
