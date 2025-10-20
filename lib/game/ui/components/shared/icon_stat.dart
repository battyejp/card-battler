import 'package:flame/components.dart';
import 'package:flame_svg/svg.dart';
import 'package:flame_svg/svg_component.dart';
import 'package:flutter/material.dart';

class IconStat extends PositionComponent {
  IconStat(Svg icon, double size) : _icon = icon, _size = size;

  final Svg _icon;
  final double _size;

  @override
  void onMount() {
    super.onMount();

    final healthIcon = SvgComponent(svg: _icon)..size = Vector2.all(_size);

    final healthText = TextComponent(
      text: '${10}',
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
