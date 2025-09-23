import 'package:card_battler/game/coordinators/components/player/player_info_coordinator.dart';
import 'package:card_battler/game/ui/components/card/containers/card_fan.dart';
import 'package:card_battler/game/ui/components/common/reactive_position_component.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class TeamMate extends ReactivePositionComponent<PlayerInfoCoordinator> {
  TeamMate(super.coordinator);

  final double margin = 5.0;

  @override
  void updateDisplay() {
    super.updateDisplay();

    final playerName = TextComponent(
      text: coordinator.name,
      anchor: Anchor.topCenter,
      position: Vector2(size.x / 2, 10),
      textRenderer: TextPaint(
        style: const TextStyle(fontSize: 14, color: Colors.white),
      ),
    );
    add(playerName);

    final cardFan = CardFan(
      initialCardCount: coordinator.handCardsCoordinator.length,
      cardScale: 1.0,
      mini: true,
      fanRadius: 50.0,
    )..position = Vector2(size.x / 2, 110);

    add(cardFan);

    final healthTextComponent = TextComponent(
      text: coordinator.healthDisplay,
      anchor: Anchor.center,
      position: Vector2(size.x / 2, cardFan.position.y + margin),
      textRenderer: TextPaint(
        style: const TextStyle(fontSize: 14, color: Colors.white),
      ),
    );
    add(healthTextComponent);

    final creditsTextComponent = TextComponent(
      text: "Credits: ${coordinator.credits}",
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
      text: "Attack: ${coordinator.attack}",
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
