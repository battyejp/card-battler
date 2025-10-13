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
  });

  final Map<String, TextComponent> _labels = {};
  late TextComponent lastLabel;

  @override
  void updateDisplay() {
    super.updateDisplay();

    // if (hasChildren) {
    //   _labels['health']?.text = coordinator.healthDisplay;
    //   _labels['attack']?.text = 'Attack: ${coordinator.attack}';
    //   _labels['credits']?.text = 'Credits: ${coordinator.credits}';
    //   _labels['name']?.text = coordinator.name;
    //   return;
    // }

    const padding = 10.0;
    const lineHeight = 25.0;
    const gapBetweenLabels = 6.0;
    const gapBetweenIconAndLabel = 0.0;
    const fontSize = 12.0;

    // Name at top, left-aligned
    final nameLabel = TextComponent(
      text: coordinator.name,
      position: Vector2(padding, padding),
      anchor: Anchor.topLeft,
      textRenderer: TextPaint(
        style: const TextStyle(fontSize: fontSize, color: Colors.white),
      ),
    );
    _labels['name'] = nameLabel;
    add(nameLabel);
    addCardHandAbilities(nameLabel, 'name');

    // All stats on the same line, spaced horizontally
    const statsY = lineHeight;
    var x = padding;

    // Health
    final healthIcon = SvgComponent(svg: IconManager.heart())
      ..size = Vector2.all(fontSize)
      ..position = Vector2(x, statsY)
      ..anchor = Anchor.topLeft;
    add(healthIcon);
    x += 16 + gapBetweenIconAndLabel;
    final healthLabel = TextComponent(
      text: coordinator.healthDisplay,
      position: Vector2(x, statsY),
      anchor: Anchor.topLeft,
      textRenderer: TextPaint(
        style: const TextStyle(fontSize: fontSize, color: Colors.white),
      ),
    );
    _labels['health'] = healthLabel;
    add(healthLabel);
    x += healthLabel.size.x + gapBetweenLabels;

    // Attack
    final attackIcon = SvgComponent(svg: IconManager.target())
      ..size = Vector2.all(fontSize)
      ..position = Vector2(x, statsY)
      ..anchor = Anchor.topLeft;
    add(attackIcon);
    x += 16 + gapBetweenIconAndLabel;
    final attackLabel = TextComponent(
      text: coordinator.attack.toString(),
      position: Vector2(x, statsY),
      anchor: Anchor.topLeft,
      textRenderer: TextPaint(
        style: const TextStyle(fontSize: fontSize, color: Colors.white),
      ),
    );
    _labels['attack'] = attackLabel;
    add(attackLabel);
    x += attackLabel.size.x + gapBetweenLabels;

    // Credits
    final creditsIcon = SvgComponent(svg: IconManager.rupee())
      ..size = Vector2.all(fontSize)
      ..position = Vector2(x, statsY)
      ..anchor = Anchor.topLeft;
    add(creditsIcon);
    x += 16 + gapBetweenIconAndLabel;
    final creditsLabel = TextComponent(
      text: coordinator.credits.toString(),
      position: Vector2(x, statsY),
      anchor: Anchor.topLeft,
      textRenderer: TextPaint(
        style: const TextStyle(fontSize: fontSize, color: Colors.white),
      ),
    );
    _labels['credits'] = creditsLabel;
    add(creditsLabel);

    lastLabel = creditsLabel;
  }

  void addCardHandAbilities(TextComponent label, String key) {
    if (key == 'name' && coordinator.hasAMaxDamageCard()) {
      add(
        SvgComponent(svg: IconManager.shield())
          ..position = Vector2(
            label.position.x + label.size.x + 10,
            label.position.y,
          )
          ..size = Vector2.all(16),
      );
    }
  }
}
