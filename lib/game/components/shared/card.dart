import 'package:card_battler/game/models/shared/card_model.dart';
import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'dart:ui';

class Card extends PositionComponent {
  final CardModel cardModel;
  late TextComponent _nameTextComponent;

  Card(this.cardModel);

  @override
  bool get debugMode => true;

  @override
  void onLoad() {
    super.onLoad();
    _addTextComponent();
  }

  void _addTextComponent() {
    _nameTextComponent = TextComponent(
      text: cardModel.isFaceUp ? "${cardModel.name} - Cost: ${cardModel.cost}" : "Back",
      anchor: Anchor.center,
      position: Vector2(size.x / 2, size.y / 2),
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 20,
          color: Colors.white,
        ),
      ),
    );
    add(_nameTextComponent);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final paint = Paint()..color = const Color.fromARGB(77, 21, 6, 193);
    canvas.drawRect(size.toRect(), paint);
  }
}