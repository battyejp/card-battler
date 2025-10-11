import 'package:card_battler/game/coordinators/components/enemy/enemies_coordinator.dart';
import 'package:card_battler/game/ui/components/common/base_sprite.dart';
import 'package:card_battler/game/ui/components/enemy/enemy.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Enemies extends PositionComponent with HasVisibility {
  Enemies({required EnemiesCoordinator coordinator})
    : _coordinator = coordinator;

  final EnemiesCoordinator _coordinator;
  final double _enemyHeightFactor = 0.6;
  final double _enemyWidthFactor = 0.2;

  @override
  void onMount() {
    super.onMount();
    removeWhere((component) => true);

    const width = 704 * 0.5;
    const height = 228 * 0.5;

    //TODO don't scale base create smaller image asset
    final baseSprite = BaseSprite("enemies.png")
      ..scale = Vector2.all(0.5)
      ..position = Vector2(size.x / 2 - width / 2, size.y / 2 - height / 2);
    add(baseSprite);

    final cardWidth = size.x * _enemyWidthFactor;
    final cardHeight = size.y * _enemyHeightFactor;
    final totalCardsWidth = _coordinator.maxNumberOfEnemiesInPlay * cardWidth;
    final spacing =
        (size.x - totalCardsWidth) /
        (_coordinator.maxNumberOfEnemiesInPlay + 1);
    final y = (size.y - cardHeight) / 2;

    // Create UI components for each enemy model
    final enemyComponents = <Enemy>[];
    final allEnemyCoordinators = _coordinator.allEnemyCoordinators;
    for (var i = 0; i < _coordinator.maxNumberOfEnemiesInPlay; i++) {
      final x = spacing + i * (cardWidth + spacing);
      final enemyComponent = Enemy(coordinator: allEnemyCoordinators[i])
        ..size = Vector2(cardWidth, cardHeight)
        ..position = Vector2(x, y);

      enemyComponents.add(enemyComponent);
      add(enemyComponent);
    }

    final textComponent = TextComponent(
      text: "Enemies to come: ${_coordinator.numberOfEnemiesNotInPlay}",
      textRenderer: TextPaint(
        style: const TextStyle(fontSize: 20, color: Colors.white),
      ),
      anchor: Anchor.center,
    );
    textComponent.position = Vector2(size.x / 2, size.y - size.y * 0.1);
    add(textComponent);
  }
}
