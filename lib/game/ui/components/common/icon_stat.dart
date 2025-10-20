import 'package:flame/components.dart';
import 'package:flame_svg/svg.dart';
import 'package:flame_svg/svg_component.dart';
import 'package:flutter/material.dart';

class IconStat extends PositionComponent {
  IconStat(Svg icon, double size, int value)
    : _icon = icon,
      _size = size,
      _value = value;

  final Svg _icon;
  final double _size;
  final int _value;

  @override
  void onMount() {
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
      text: _value.toString(),
      position: Vector2(healthIcon.size.x, healthIcon.size.y),
      anchor: Anchor.bottomRight,
      textRenderer: TextPaint(
        style: TextStyle(
          fontSize: _size * 0.5,
          color: const Color(0xFFFFFFFF),
          fontWeight: FontWeight.bold,
          shadows: const [Shadow(offset: Offset(2, 2), blurRadius: 4)],
        ),
      ),
    );
    healthIcon.add(healthText);
    add(healthIcon);
  }
}
