import 'package:card_battler/game_legacy/components/shared/health.dart';
import 'package:card_battler/game_legacy/components/shared/reactive_position_component.dart';
import 'package:card_battler/game_legacy/models/team/player_stats_model.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class PlayerStats extends ReactivePositionComponent<PlayerStatsModel> {
  PlayerStats(super.model);

  bool _wasRemoved = false;

  @override
  void updateDisplay() {
    super.updateDisplay();
    
    var background = RectangleComponent(
      size: size,
      paint: Paint()..color = model.isActive ? Colors.blue.withValues(alpha: 0.3) : Colors.transparent,
    );
    add(background);
    
    var textComponent = TextComponent(
      text: model.name,
      position: Vector2(10, 10),
      anchor: Anchor.topLeft,
    );

    add(textComponent);

    var healthComponent = Health(model.health)
      ..anchor = Anchor.centerLeft
      ..position = Vector2(size.x / 2, size.y / 2);

    add(healthComponent);
  }

  @override
  void onMount(){
    super.onMount();

    if (_wasRemoved) {
      updateDisplay();
    }
  }

  @override
  void onRemove() {
    super.onRemove();
    _wasRemoved = true;
  }
}