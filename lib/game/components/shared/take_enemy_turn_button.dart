import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';

/// A visually prominent, flashing button that prompts the player to take the enemy turn
class TakeEnemyTurnButton extends PositionComponent with TapCallbacks {
  final void Function()? onTap;
  late TextComponent _textComponent;
  late RectangleComponent _backgroundComponent;
  
  TakeEnemyTurnButton({this.onTap});

  @override
  Future<void> onLoad() async {
    super.onLoad();
    
    // Create background rectangle
    _backgroundComponent = RectangleComponent(
      size: size,
      paint: Paint()..color = const Color(0xFF4CAF50), // Green background
      anchor: Anchor.center,
      position: Vector2(size.x / 2, size.y / 2),
    );
    add(_backgroundComponent);
    
    // Create text component
    _textComponent = TextComponent(
      text: 'Take Enemy Turn',
      anchor: Anchor.center,
      position: Vector2(size.x / 2, size.y / 2),
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 24,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    add(_textComponent);
    
    // Start flashing animation
    _startFlashingEffect();
  }

  void _startFlashingEffect() {
    // Create a repeating opacity effect for flashing
    final opacityEffect = OpacityEffect.fadeIn(
      EffectController(
        duration: 0.8,
        reverseDuration: 0.8,
        infinite: true,
      ),
    );
    
    // Apply to the background component for a flashing effect
    _backgroundComponent.add(opacityEffect);
  }

  @override
  bool onTapUp(TapUpEvent event) {
    onTap?.call();
    return true;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    
    // Draw border for extra visibility
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;
    canvas.drawRect(size.toRect(), borderPaint);
  }
}