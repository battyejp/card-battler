import 'package:card_battler/game/ui/components/scenes/layout_stuff/card_sprite.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class CardFan extends PositionComponent {
  CardFan({
    required Vector2 position,
    this.cardCount = 5,
    this.fanAngle = math.pi / 6, // 30 degrees spread
    this.fanRadius = 100.0,
    this.cardImagePath = 'card_face_up0.2.png',
    this.cardScale = 0.4,
  }) : super(position: position);

  @override
  bool get debugMode => true; // Set to true to see bounding box

  final int cardCount;
  final double fanAngle;
  final double fanRadius;
  final String cardImagePath;
  final double cardScale;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Add transparent background for the fan area
    add(
      RectangleComponent(
        size: Vector2(
          fanRadius * 2.5,
          fanRadius * 1.2,
        ), // Size to cover fan area
        paint: Paint()
          ..color = const Color.fromARGB(255, 125, 5, 5).withValues(alpha: 0.3),
        anchor: Anchor.center,
      ),
    );

    await _createCardFan();
  }

  Future<void> _createCardFan() async {
    final startAngle = -fanAngle / 2; // Start from left side of fan
    final angleStep = fanAngle / (cardCount - 1); // Angle between cards

    for (int i = 0; i < cardCount; i++) {
      final angle = startAngle + (i * angleStep);

      // Calculate card position on the fan arc
      final cardX = fanRadius * math.sin(angle);
      final cardY = -fanRadius * math.cos(angle);

      // Create card sprite component
      final card = CardSprite(Vector2(cardX, cardY), cardImagePath)
        ..scale = Vector2.all(cardScale)
        ..anchor = Anchor.center
        ..size = Vector2(100, 140); // Set a default size for the card

      // Rotate card to follow fan angle for realistic hand appearance
      card.angle = angle * 0.5; // Reduced rotation for subtle effect

      add(card);
    }
  }
}
