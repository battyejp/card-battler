import 'package:card_battler/game/models/shared/card_model.dart';
import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';

class Card extends PositionComponent with TapCallbacks {
  final CardModel cardModel;
  final VoidCallback? onTap;
  
  @protected
  late TextComponent nameTextComponent;

  Card(this.cardModel, {this.onTap});

  @override
  bool get debugMode => true;

  @override
  void onLoad() {
    super.onLoad();
    addTextComponent();
  }

  @protected
  void addTextComponent() {
    if (cardModel.isFaceUp) {
      createNameTextComponent(Vector2(size.x / 2, size.y / 2));
      add(nameTextComponent);
    } else {
      createBackTextComponent();
      add(nameTextComponent);
    }
  }

  @protected
  void createNameTextComponent(Vector2 position) {
    nameTextComponent = TextComponent(
      text: cardModel.name,
      anchor: Anchor.center,
      position: position,
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 20,
          color: Colors.white,
        ),
      ),
    );
  }

  @protected
  void createBackTextComponent() {
    nameTextComponent = TextComponent(
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
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final paint = Paint()..color = const Color.fromARGB(77, 21, 6, 193);
    canvas.drawRect(size.toRect(), paint);
  }
  
  @override
  void onTapUp(TapUpEvent event) {
    super.onTapUp(event);
    onTap?.call();
  }
}