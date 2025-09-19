import 'package:card_battler/game/ui/components/scenes/layout_stuff/player/card_fan.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class TeamMate extends PositionComponent {
  @override
  void onLoad() {
    super.onLoad();

    final cardFan = CardFan(
      position: Vector2(0, 0),
      initialCardCount: 5,
      cardScale: 1.0,
      cardImagePath: 'card_face_up_0.02.png',
      fanRadius: 50.0,
    );
    add(cardFan);

    final healthTextComponent = TextComponent(
      text: "HP: 10/10",
      anchor: Anchor.center,
      position: Vector2(size.x / 2, size.y / 2 + 10),
      textRenderer: TextPaint(
        style: const TextStyle(fontSize: 14, color: Colors.white),
      ),
    );
    add(healthTextComponent);

    final creditsTextComponent = TextComponent(
      text: "Credits: 0",
      anchor: Anchor.center,
      position: Vector2(size.x / 2, healthTextComponent.position.y + 20),
      textRenderer: TextPaint(
        style: const TextStyle(fontSize: 14, color: Colors.white),
      ),
    );
    add(creditsTextComponent);

    final attackTextComponent = TextComponent(
      text: "Attack: 5",
      anchor: Anchor.center,
      position: Vector2(size.x / 2, creditsTextComponent.position.y + 20),
      textRenderer: TextPaint(
        style: const TextStyle(fontSize: 14, color: Colors.white),
      ),
    );
    add(attackTextComponent);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final paint = Paint()
      ..color = const Color.fromARGB(77, 173, 10, 173); // Red with 0.3 opacity
    canvas.drawRect(size.toRect(), paint);
  }
}
