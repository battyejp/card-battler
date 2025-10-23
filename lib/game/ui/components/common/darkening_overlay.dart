import 'package:card_battler/game/services/card/card_selection_service.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/painting.dart';

class DarkeningOverlay extends PositionComponent
    with HasVisibility, TapCallbacks {
  DarkeningOverlay({
    required CardSelectionService cardSelectionService,
    double opacity = 0.8,
  }) : _opacity = opacity,
       _cardSelectionService = cardSelectionService;

  final double _opacity;
  final CardSelectionService _cardSelectionService;

  @override
  void render(Canvas canvas) {
    final paint = Paint()
      ..color = Color.fromARGB((_opacity * 255).toInt(), 0, 0, 0);
    canvas.drawRect(size.toRect(), paint);
  }

  // This is needed to allow taps to pass through to child components
  @override
  bool containsLocalPoint(Vector2 point) {
    final result = isVisible ? super.containsLocalPoint(point) : false;
    return result;
  }

  @override
  bool onTapUp(TapUpEvent event) {
    _cardSelectionService.deselectCard();
    return true; // Consume the event
  }
}
