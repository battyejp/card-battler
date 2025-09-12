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

    add(
      RectangleComponent(
        size: size,
        paint: Paint()
          ..color = _coordinator.isActive
              ? Colors.blue.withValues(alpha: 0.3)
              : Colors.transparent,
      ),
    );

    final isSummary = _viewMode == PlayerInfoViewMode.summary;
    final statData = isSummary
        ? [
            _coordinator.name,
            'Health: ${_coordinator.health}/${_coordinator.maxHealth}',
          ]
        : [
            _coordinator.name,
            'Health: ${_coordinator.health}/${_coordinator.maxHealth}',
            'Attack: ${_coordinator.attack}',
            'Credits: ${_coordinator.credits}',
          ];

    final statWidth = size.x / statData.length;

    for (var i = 0; i < statData.length; i++) {
      final comp = PositionComponent()
        ..size = Vector2(statWidth, size.y)
        ..position = Vector2(statWidth * i, 0);

      final label = TextComponent(
        text: statData[i],
        position: Vector2(statWidth / 2, size.y / 2),
        anchor: Anchor.center,
        textRenderer: TextPaint(
          style: const TextStyle(fontSize: 20, color: Colors.white),
        ),
      );

      comp.add(label);
      add(comp);
    }
  }
}
