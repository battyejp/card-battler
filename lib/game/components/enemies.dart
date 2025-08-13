import 'package:flame/components.dart';
import 'card.dart';

class Enemies extends PositionComponent {
  static const int enemyCount = 3;
  static const double enemyHeightFactor = 0.6;
  static const double enemyWidthFactor = 0.2;

  @override
  bool get debugMode => true;

  @override
  onLoad() {
    final cardWidth = size.x * enemyWidthFactor;
    final cardHeight = size.y * enemyHeightFactor;
    final totalCardsWidth = enemyCount * cardWidth;
    final spacing = (size.x - totalCardsWidth) / (enemyCount + 1);
    final y = (size.y - cardHeight) / 2;

    for (int i = 0; i < enemyCount; i++) {
      final x = spacing + i * (cardWidth + spacing);
      final card = Card()
        ..size = Vector2(cardWidth, cardHeight)
        ..position = Vector2(x, y);

      add(card);
    }
  }
}