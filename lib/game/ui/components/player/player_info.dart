import 'package:card_battler/game/coordinators/components/player/player_info_coordinator.dart';
import 'package:card_battler/game/ui/components/common/reactive_position_component.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class PlayerInfo extends ReactivePositionComponent<PlayerInfoCoordinator> {
  PlayerInfo(super.coordinator);

  final Map<String, TextComponent> _labels = {};

  @override
  void updateDisplay() {
    //Don't call super which clears children

    if (hasChildren) {
      _labels['health']?.text = coordinator.healthDisplay;
      _labels['attack']?.text = 'Attack: ${coordinator.attack}';
      _labels['credits']?.text = 'Credits: ${coordinator.credits}';
      _labels['name']?.text = coordinator.name;
      return;
    }

    final statKeys = ['name', 'health', 'attack', 'credits'];
    final padding = 10.0;

    //final statWidth = size.x / statKeys.length;

    for (var i = 0; i < statKeys.length; i++) {
      final key = statKeys[i];
      String text;
      Vector2? position;
      late var anchor = Anchor.topCenter;
      switch (key) {
        case 'name':
          text = coordinator.name;
          position = Vector2(size.x / 2, padding);
          break;
        case 'health':
          text = coordinator.healthDisplay;
          position = Vector2(size.x / 2, size.y - padding);
          anchor = Anchor.bottomCenter;
          break;
        case 'attack':
          text = 'Attack: ${coordinator.attack}';
          position = Vector2(padding, padding);
          anchor = Anchor.topLeft;
          break;
        case 'credits':
          text = 'Credits: ${coordinator.credits}';
          position = Vector2(size.x - padding, padding);
          anchor = Anchor.topRight;
          break;
        default:
          text = '';
      }

      // final comp = PositionComponent()
      //   ..size = Vector2(size.x, size.y)
      //   ..position = position!;

      final label = TextComponent(
        text: text,
        position: position,
        anchor: anchor,
        textRenderer: TextPaint(
          style: const TextStyle(fontSize: 20, color: Colors.white),
        ),
      );

      _labels[key] = label;
      //comp.add(label);
      add(label);
    }
  }
}
