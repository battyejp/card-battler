import 'package:card_battler/game_legacy/components/enemy/enemy.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:card_battler/game_legacy/models/enemy/enemies_model.dart';

class Enemies extends PositionComponent {
  final EnemiesModel _model;
  late TextComponent _textComponent;
  late List<Enemy> _enemyComponents;

  static const double enemyHeightFactor = 0.6;
  static const double enemyWidthFactor = 0.2;

  Enemies({required EnemiesModel model}) : _model = model;

  @override
  void onLoad() {
    final cardWidth = size.x * enemyWidthFactor;
    final cardHeight = size.y * enemyHeightFactor;
    final totalCardsWidth = _model.maxNumberOfEnemiesInPlay * cardWidth;
    final spacing =
        (size.x - totalCardsWidth) / (_model.maxNumberOfEnemiesInPlay + 1);
    final y = (size.y - cardHeight) / 2;

    // Create UI components for each enemy model
    _enemyComponents = [];
    final allEnemies = _model.allEnemies;
    for (int i = 0; i < _model.maxNumberOfEnemiesInPlay; i++) {
      final x = spacing + i * (cardWidth + spacing);
      final enemyComponent = Enemy(model: allEnemies[i])
        ..size = Vector2(cardWidth, cardHeight)
        ..position = Vector2(x, y);

      _enemyComponents.add(enemyComponent);
      add(enemyComponent);
    }

    _textComponent = TextComponent(
      text: _model.displayText,
      textRenderer: TextPaint(
        style: const TextStyle(fontSize: 20, color: Colors.white),
      ),
      anchor: Anchor.center,
    );
    _textComponent.position = Vector2(size.x / 2, size.y - size.y * 0.1);
    add(_textComponent);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final paint = Paint()
      ..color = const Color.fromARGB(77, 8, 201, 37); // Red with 0.3 opacity
    canvas.drawRect(size.toRect(), paint);
  }
}
