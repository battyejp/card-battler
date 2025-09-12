import 'package:card_battler/game/coordinators/components/player/player_info_coordinator.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

enum PlayerInfoViewMode { summary, detailed }

class PlayerInfo extends PositionComponent {
  final PlayerInfoCoordinator _coordinator;
  final PlayerInfoViewMode _viewMode;

  PlayerInfo({
    required PlayerInfoCoordinator coordinator,
    required PlayerInfoViewMode viewMode,
  }) : _coordinator = coordinator,
       _viewMode = viewMode;

  @override
  void onLoad() {
    super.onLoad();

    var background = RectangleComponent(
      size: size,
      paint: Paint()
        ..color = _coordinator.isActive
            ? Colors.blue.withValues(alpha: 0.3)
            : Colors.transparent,
    );

    add(background);

    //TODO tidy up, loads of repeated code
    var comp1 = PositionComponent()
      ..size = Vector2(size.x / 4, size.y)
      ..position = Vector2(0, 0);

    var comp2 = PositionComponent()
      ..size = Vector2(size.x / 4, size.y)
      ..position = Vector2(size.x / 4, 0);

    var comp3 = PositionComponent()
      ..size = Vector2(size.x / 4, size.y)
      ..position = Vector2((size.x / 4) * 2, 0);

    var comp4 = PositionComponent()
      ..size = Vector2(size.x / 4, size.y)
      ..position = Vector2((size.x / 4) * 3, 0);

    var nameLabel = TextComponent(
      text: _coordinator.name,
      position: Vector2(comp1.size.x / 2, comp1.size.y / 2),
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: const TextStyle(fontSize: 20, color: Colors.white),
      ),
    );

    var healthLabel = TextComponent(
      text: 'Health: ${_coordinator.health}/${_coordinator.maxHealth}',
      position: Vector2(comp2.size.x / 2, comp2.size.y / 2),
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: const TextStyle(fontSize: 20, color: Colors.white),
      ),
    );

    var attackLabel = TextComponent(
      text: 'Attack: ${_coordinator.attack}',
      position: Vector2(comp3.size.x / 2, comp3.size.y / 2),
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: const TextStyle(fontSize: 20, color: Colors.white),
      ),
    );

    var creditsLabel = TextComponent(
      text: 'Credits: ${_coordinator.credits}',
      position: Vector2(comp4.size.x / 2, comp4.size.y / 2),
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: const TextStyle(fontSize: 20, color: Colors.white),
      ),
    );

    comp1.add(nameLabel);
    comp2.add(healthLabel);
    comp3.add(attackLabel);
    comp4.add(creditsLabel);

    add(comp1);
    add(comp2);
    add(comp3);
    add(comp4);
  }
}
