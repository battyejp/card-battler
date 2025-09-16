import 'package:card_battler/game/coordinators/components/player/player_info_coordinator.dart';
import 'package:card_battler/game/ui/components/common/reactive_position_component.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

enum PlayerInfoViewMode { summary, detailed }

class PlayerInfo extends ReactivePositionComponent<PlayerInfoCoordinator> {
  PlayerInfo(super.coordinator, {required PlayerInfoViewMode viewMode})
    : _viewMode = viewMode;

  final PlayerInfoViewMode _viewMode;
  final Map<String, TextComponent> _labels = {};

  @override
  void updateDisplay() {
    //Don't call super which clears children

    if (hasChildren) {
      _labels['health']?.text = coordinator.healthDisplay;
      _labels['attack']?.text = 'Attack: ${coordinator.attack}';
      _labels['credits']?.text = 'Credits: ${coordinator.credits}';
      _labels['name']?.text = coordinator.name;
    }
  }

  @override
  void onLoad() {
    super.onLoad();

    add(
      RectangleComponent(
        size: size,
        paint: Paint()
          ..color = coordinator.isActive
              ? Colors.blue.withValues(alpha: 0.3)
              : Colors.transparent,
      ),
    );

    final isSummary = _viewMode == PlayerInfoViewMode.summary;
    final statKeys = isSummary
        ? ['name', 'health']
        : ['name', 'health', 'attack', 'credits'];

    final statWidth = size.x / statKeys.length;

    for (var i = 0; i < statKeys.length; i++) {
      final key = statKeys[i];
      String text;
      switch (key) {
        case 'name':
          text = coordinator.name;
          break;
        case 'health':
          text = coordinator.healthDisplay;
          break;
        case 'attack':
          text = 'Attack: ${coordinator.attack}';
          break;
        case 'credits':
          text = 'Credits: ${coordinator.credits}';
          break;
        default:
          text = '';
      }

      final comp = PositionComponent()
        ..size = Vector2(statWidth, size.y)
        ..position = Vector2(statWidth * i, 0);

      final label = TextComponent(
        text: text,
        position: Vector2(statWidth / 2, size.y / 2),
        anchor: Anchor.center,
        textRenderer: TextPaint(
          style: const TextStyle(fontSize: 20, color: Colors.white),
        ),
      );

      _labels[key] = label;
      comp.add(label);
      add(comp);
    }
  }
}
