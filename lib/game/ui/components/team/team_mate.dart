import 'package:card_battler/game/ui/components/card/containers/card_fan.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class TeamMate extends PositionComponent {
  final double margin = 5.0;

  @override
  void onLoad() {
    super.onLoad();

    final playerName = TextComponent(
      text: "Player Name",
      anchor: Anchor.topCenter,
      position: Vector2(size.x / 2, 10),
      textRenderer: TextPaint(
        style: const TextStyle(fontSize: 14, color: Colors.white),
      ),
    );
    add(playerName);

    final cardFan = CardFan(
      initialCardCount: 5,
      cardScale: 1.0,
      mini: true,
      fanRadius: 50.0,
    )..position = Vector2(size.x / 2, 110);

    add(cardFan);

    final healthTextComponent = TextComponent(
      text: "HP: 10/10",
      anchor: Anchor.center,
      position: Vector2(size.x / 2, cardFan.position.y + margin),
      textRenderer: TextPaint(
        style: const TextStyle(fontSize: 14, color: Colors.white),
      ),
    );
    add(healthTextComponent);

    final creditsTextComponent = TextComponent(
      text: "Credits: 0",
      anchor: Anchor.center,
      position: Vector2(
        size.x / 2,
        healthTextComponent.position.y + healthTextComponent.size.y + margin,
      ),
      textRenderer: TextPaint(
        style: const TextStyle(fontSize: 14, color: Colors.white),
      ),
    );
    add(creditsTextComponent);

    final attackTextComponent = TextComponent(
      text: "Attack: 5",
      anchor: Anchor.center,
      position: Vector2(
        size.x / 2,
        creditsTextComponent.position.y + creditsTextComponent.size.y + margin,
      ),
      textRenderer: TextPaint(
        style: const TextStyle(fontSize: 14, color: Colors.white),
      ),
    );
    add(attackTextComponent);
  }
}
