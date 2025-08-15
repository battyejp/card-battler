import 'package:card_battler/game/models/shared/card_model.dart';
import 'package:flutter/material.dart';
import 'package:flame/components.dart';

class Card extends PositionComponent {
  final CardModel cardModel;
  late TextComponent _nameTextComponent;
  late TextComponent _costTextComponent;

  Card(this.cardModel);

  @override
  bool get debugMode => true;

  @override
  void onLoad() {
    super.onLoad();
    _addTextComponent();
  }

  void _addTextComponent() {
    if (cardModel.isFaceUp) {
      _nameTextComponent = TextComponent(
        text: cardModel.name,
        anchor: Anchor.center,
        position: Vector2(size.x / 2, size.y / 2 - 15),
        textRenderer: TextPaint(
          style: const TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      );
      
      _costTextComponent = TextComponent(
        text: "Cost: ${cardModel.cost}",
        anchor: Anchor.center,
        position: Vector2(size.x / 2, size.y / 2 + 15),
        textRenderer: TextPaint(
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      );
      
      add(_nameTextComponent);
      add(_costTextComponent);
    } else {
      _nameTextComponent = TextComponent(
        text: "Back",
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
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final paint = Paint()..color = const Color.fromARGB(77, 21, 6, 193);
    canvas.drawRect(size.toRect(), paint);
  }
}