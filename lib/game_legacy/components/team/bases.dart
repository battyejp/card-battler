import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:card_battler/game_legacy/components/team/base.dart';
import 'package:card_battler/game_legacy/models/team/bases_model.dart';

class Bases extends PositionComponent {
  final BasesModel _model;
  late TextComponent _textComponent;
  late List<Base> _baseComponents;

  Bases({required BasesModel model}) : _model = model;

  @override
  void onLoad() {
    // Create text component with correct styling and positioning
    _textComponent = TextComponent(
      text: _model.displayText,
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 20,
          color: Colors.white,
        ),
      ),
      anchor: Anchor.center,
    );
    _textComponent.position = Vector2(size.x / 2, 20);
    add(_textComponent);

    // Calculate space below text for base components
    final textHeight = 40.0; // Reserve space for text
    final baseHeight = (size.y - textHeight);
    final baseSize = Vector2(size.x, baseHeight);
    final baseY = textHeight;

    // Create UI components for each base model
    _baseComponents = [];
    final allBases = _model.allBases;
    for (int i = 0; i < allBases.length; i++) {
      final baseComponent = Base(model: allBases[i])
        ..size = baseSize
        ..position = Vector2(0, baseY);
      
      // Only the current (top) base should be visible
      baseComponent.isVisible = (i == _model.currentBaseIndex);
      _baseComponents.add(baseComponent);
      add(baseComponent);
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final paint = Paint()..color = const Color(0x4DFF0000); // Red with 0.3 opacity
    canvas.drawRect(size.toRect(), paint);
  }
}

