import 'package:card_battler/game/components/shared/card.dart';
import 'package:flame/components.dart';

class Discard extends PositionComponent {
  @override
  bool get debugMode => true;

  @override
  onLoad() {
    final cardWidth = size.x * 0.5;
    final cardHeight = size.y * 0.9;

    final card = Card()
      ..size = Vector2(cardWidth, cardHeight)
      ..position = Vector2((size.x - cardWidth) / 2, (size.y - cardHeight) / 2);

    add(card);
  }
}