import 'package:card_battler/game/coordinators/components/player/player_info_coordinator.dart';
import 'package:card_battler/game/ui/components/common/reactive_position_component.dart';
import 'package:card_battler/game/ui/icon_manager.dart';
import 'package:flame/components.dart';
import 'package:flame_svg/svg_component.dart';
import 'package:flutter/material.dart';

//TODO look at hardcode layout parameters in hear and base on screen size
class PlayerInfo extends ReactivePositionComponent<PlayerInfoCoordinator> {
  PlayerInfo(
    super.coordinator, {
    bool isActivePlayer = true,
    double gapBetweenNameAndFirstLabel = 0.0,
  }) : _isActivePlayer = isActivePlayer,
       _gapBetweenNameAndFirstLabel = gapBetweenNameAndFirstLabel;

  final Map<String, TextComponent> _labels = {};
  final bool _isActivePlayer;
  final double _gapBetweenNameAndFirstLabel;
  late TextComponent lastLabel;

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
    const padding = 10.0;

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
          position = _isActivePlayer
              ? Vector2(size.x / 2, size.y - padding)
              : Vector2(
                  size.x / 2,
                  lastLabel.position.y +
                      lastLabel.size.y +
                      _gapBetweenNameAndFirstLabel,
                );
          anchor = _isActivePlayer ? Anchor.bottomCenter : Anchor.center;
          break;
        case 'attack':
          text = 'Attack: ${coordinator.attack}';
          position = _isActivePlayer
              ? Vector2(padding, padding)
              : Vector2(
                  size.x / 2,
                  lastLabel.position.y + lastLabel.size.y + 5.0,
                );
          anchor = _isActivePlayer ? Anchor.topLeft : Anchor.center;
          break;
        case 'credits':
          text = 'Credits: ${coordinator.credits}';
          position = _isActivePlayer
              ? Vector2(size.x - padding, padding)
              : Vector2(
                  size.x / 2,
                  lastLabel.position.y + lastLabel.size.y + 5.0,
                );
          anchor = _isActivePlayer ? Anchor.topRight : Anchor.center;
          break;
        default:
          text = '';
      }

      final label = TextComponent(
        text: text,
        position: position,
        anchor: anchor,
        textRenderer: TextPaint(
          style: TextStyle(
            fontSize: _isActivePlayer ? 20 : 14,
            color: Colors.white,
          ),
        ),
      );

      _labels[key] = label;
      add(label);

      if (key == 'name' && coordinator.hasAProtectionCard()) {
        add(
          SvgComponent(svg: IconManager.shield())
            ..position =
                Vector2(
                  label.position.x + label.size.x / 2 + 10,
                  label.position.y - (_isActivePlayer ? 0 : 3),
                ) // Adjust Y position as needed
            ..size = Vector2.all(20),
        );
      }

      lastLabel = label;
    }
  }
}
