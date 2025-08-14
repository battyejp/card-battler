import 'package:card_battler/game/components/enemy/enemy.dart';
import 'package:card_battler/game/game_constants.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:card_battler/game/models/enemy/enemies_model.dart';

class Enemies extends PositionComponent {
  final EnemiesModel _model;
  late TextComponent _textComponent;
  late List<Enemy> _enemyComponents;

  static const double enemyHeightFactor = 0.6;
  static const double enemyWidthFactor = 0.2;

  Enemies({required EnemiesModel model}) : _model = model;

  @override
  bool get debugMode => true;

  @override
  void onLoad() {
    // Create text component with correct styling and positioning
    _textComponent = TextComponent(
      text: _model.displayText,
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 20,
          color: Colors.white,
        ),
      ),
      anchor: Anchor.center,
    );
    _textComponent.position = Vector2(size.x / 2, 20);
    add(_textComponent);

    final cardWidth = size.x * enemyWidthFactor;
    final cardHeight = size.y * enemyHeightFactor;
    final totalCardsWidth = GameConstants.maxEnemiesInPlay * cardWidth;
    final spacing = (size.x - totalCardsWidth) / (GameConstants.maxEnemiesInPlay + 1);
    final y = (size.y - cardHeight) / 2;

    // Create UI components for each enemy model
    _enemyComponents = [];
    final allEnemies = _model.allEnemies;
    for (int i = 0; i < GameConstants.maxEnemiesInPlay; i++) {

      final x = spacing + i * (cardWidth + spacing);
      final enemyComponent = Enemy(model: allEnemies[i])
        ..size = Vector2(cardWidth, cardHeight)
        ..position = Vector2(x, y);

      _enemyComponents.add(enemyComponent);
      add(enemyComponent);
    }

  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final paint = Paint()..color = const Color.fromARGB(77, 8, 201, 37); // Red with 0.3 opacity
    canvas.drawRect(size.toRect(), paint);
  }
}