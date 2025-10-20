import 'package:card_battler/game/coordinators/components/player/stat_coordinator.dart';
import 'package:card_battler/game/ui/components/common/reactive_position_component.dart';
import 'package:flame/components.dart';
import 'package:flame_svg/svg.dart';
import 'package:flame_svg/svg_component.dart';
import 'package:flutter/material.dart';

class IconStat extends ReactivePositionComponent<StatCoordinator> {
  IconStat(super.coordinator, Svg icon, double size)
    : _icon = icon,
      _size = size;

  final Svg _icon;
  final double _size;

  @override
  void updateDisplay() {
    super.updateDisplay();

    // final border = RectangleComponent(
    //   size: Vector2(_size, _size),
    //   position: Vector2.zero(),
    //   paint: Paint()
    //     ..color = const Color.fromARGB(255, 255, 255, 255)
    //     ..style = PaintingStyle.stroke
    //     ..strokeWidth = 2.0,
    // );
    // add(border);

    final healthIcon = SvgComponent(svg: _icon)..size = Vector2.all(_size);

    final healthText = TextComponent(
      text: '${coordinator.value}',
      position: Vector2(healthIcon.size.x, healthIcon.size.y),
      anchor: Anchor.bottomRight,
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 24,
          color: Color(0xFFFFFFFF),
          fontWeight: FontWeight.bold,
          shadows: [Shadow(offset: Offset(2, 2), blurRadius: 4)],
        ),
      ),
    );
    healthIcon.add(healthText);
    add(healthIcon);
  }
}
