import 'package:flame/components.dart';
import 'package:card_battler/game/components/shared/card.dart';

class Shop extends PositionComponent {
  static const int rows = 2;
  static const int cols = 3;
  static const double cardHeightFactor = 0.38;
  static const double hSpacingFactor = 0.2;

  @override
  bool get debugMode => true;

  @override
  onLoad() {
    final cardWidth = size.x / (cols + (cols + 1) * hSpacingFactor);
    final cardHeight = size.y * cardHeightFactor;
    final totalWidth = cols * cardWidth + (cols - 1) * cardWidth * hSpacingFactor;
    final totalHeight = rows * cardHeight;
    final hSpacing = cardWidth * hSpacingFactor;
    final vSpacing = (size.y - totalHeight) / (rows + 1);
    final startX = (size.x - totalWidth) / 2;

    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < cols; col++) {
      final x = startX + col * (cardWidth + hSpacing);
        final y = vSpacing + row * (cardHeight + vSpacing);
        final card = Card()
          ..size = Vector2(cardWidth, cardHeight)
          ..position = Vector2(x, y);

        add(card);
      }
    }
  }
}