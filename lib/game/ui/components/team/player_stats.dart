import 'package:card_battler/game/coordinators/components/team/player_stat_coordinator.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class PlayerStats extends PositionComponent {
  final PlayerStatsCoordinator _coordinator;

  PlayerStats({required PlayerStatsCoordinator coordinator})
    : _coordinator = coordinator;

  // bool _wasRemoved = false;

  @override
  void onLoad() {
    super.onLoad();

    var background = RectangleComponent(
      size: size,
      paint: Paint()..color = _coordinator.isActive ? Colors.blue.withValues(alpha: 0.3) : Colors.transparent,
    );
    add(background);
    
    var textComponent = TextComponent(
      text: _coordinator.name,
      position: Vector2(10, 10),
      anchor: Anchor.topLeft,
    );

    add(textComponent);

    var healthComponent = TextComponent(
      text: '${_coordinator.health} / ${_coordinator.maxHealth}',
      anchor: Anchor.centerLeft,
      position: Vector2(size.x / 2, size.y / 2),
    );

    add(healthComponent);
  }

  // @override
  // void onMount(){
  //   super.onMount();

  //   if (_wasRemoved) {
  //     updateDisplay();
  //   }
  // }

  // @override
  // void onRemove() {
  //   super.onRemove();
  //   _wasRemoved = true;
  // }
}