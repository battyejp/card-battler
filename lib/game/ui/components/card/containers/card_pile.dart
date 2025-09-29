import 'package:card_battler/game/coordinators/components/cards/card_list_coordinator.dart';
import 'package:card_battler/game/game_variables.dart';
import 'package:card_battler/game/ui/components/card/card_sprite.dart';
import 'package:card_battler/game/ui/components/common/reactive_position_component.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class CardPile extends ReactivePositionComponent<CardListCoordinator> {
  CardPile(
    super.coordinator, {
    required bool isMini,
    bool showTopCard = false,
    double scale = 1.0,
  }) : _showTopCard = showTopCard,
       _scale = scale,
       _isMini = isMini;

  final bool _showTopCard;
  final double _scale;
  final bool _isMini;

  @override
  void updateDisplay() async {
    super.updateDisplay();

    for (var i = 0; i < coordinator.cardCoordinators.length; i++) {
      final cardCoordinator = coordinator.cardCoordinators[i];
      final cardSprite = CardSprite(cardCoordinator, _isMini)
        ..position = Vector2(-i * 1.0 + size.x / 2, -i * 1.0 + size.y / 2)
        ..anchor = Anchor.center
        ..scale = Vector2.all(_scale);
      cardSprite.coordinator.isFaceUp = _showTopCard;
      add(cardSprite);
    }

    if (coordinator.cardCoordinators.isEmpty) {
      final emptyIndicator = RectangleComponent(
        size: Vector2(
          _isMini
              ? GameVariables.defaultCardBackSizeWidth * _scale
              : GameVariables.defaultCardSizeWidth * _scale,
          _isMini
              ? GameVariables.defaultCardBackSizeHeight * _scale
              : GameVariables.defaultCardSizeHeight * _scale,
        ),
        position: Vector2(size.x / 2, size.y / 2),
        anchor: Anchor.center,
        paint: Paint()
          ..color = const Color(0xFFAAAAAA)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0 * _scale,
      );
      add(emptyIndicator);
    }

    final counter = TextComponent(
      text: coordinator.cardCoordinators.length.toString(),
      position: Vector2(size.x / 2, size.y / 2),
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: TextStyle(
          fontSize: 24,
          color: const Color(0xFFFFFFFF),
          shadows: [
            Shadow(
              offset: Offset(1.5 * _scale, 1.5 * _scale),
              blurRadius: 2.0 * _scale,
            ),
          ],
        ),
      ),
    );

    add(counter);
  }
}
