import 'package:card_battler/game/models/shared/play_effects_model.dart';
import 'package:card_battler/game/services/card/card_draggable_service.dart';
import 'package:card_battler/game/services/card/card_selection_service.dart';
import 'package:card_battler/game/ui/components/card/card_drop_area_table.dart';
import 'package:card_battler/game/ui/components/card/card_sprite.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

class InteractiveCardSprite extends CardSprite
    with DragCallbacks, TapCallbacks {
  InteractiveCardSprite(
    super.cardCoordinator,
    this._cardSelectionService,
    this._cardFanDraggableService,
    this._cardDropAreaTable,
  );

  final CardSelectionService _cardSelectionService;
  final CardDraggableService _cardFanDraggableService;
  final CardDropAreaTable _cardDropAreaTable;

  bool isSelected = false;
  bool isDraggable = false;
  bool isPerspectiveMode = false;

  @override
  void render(Canvas canvas) {
    if (isPerspectiveMode) {
      // Apply perspective transform to match the drop zone trapezoid
      // The drop zone has back width = 70% of front width
      canvas.save();

      // Move to center for proper rotation
      canvas.translate(size.x / 2, size.y / 2);

      // Create perspective matrix
      final matrix = Matrix4.identity();

      // Set perspective projection (affects how depth is rendered)
      matrix.setEntry(3, 2, -0.0008); // Reduced perspective strength

      // Rotate around X-axis to tilt the card forward
      // Negative = toward viewer (top narrower, bottom wider)
      matrix.rotateX(0.68); // Moderate tilt

      // Scale down slightly to compensate for perspective growth
      matrix.scale(0.85, 0.85, 1.0);

      // Apply the transform
      canvas.transform(matrix.storage);

      // Move back and render
      canvas.translate(-size.x / 2, -size.y / 2);

      super.render(canvas);
      canvas.restore();
    } else {
      super.render(canvas);
    }

    // Only show selection border when not in perspective mode (not being dragged)
    if (isSelected && !isPerspectiveMode) {
      // Draw a glowing border around the selected card
      final paint = Paint()
        ..color = const Color(0xFF00FF00)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0;

      // Draw border around the card, accounting for the center anchor
      final rect = Rect.fromLTWH(0, 0, size.x, size.y);
      canvas.drawRect(rect, paint);
    }
  }

  @override
  void onTapUp(TapUpEvent event) {
    super.onTapUp(event);
    _cardSelectionService.selectCard(this);
  }

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);

    // TODO put into draggable service
    if (_cardSelectionService.selectedCard != null) {
      final operator =
          _cardSelectionService.selectedCard!.coordinator.playEffects.operator;

      // Set number of zones based on operator
      if (operator == EffectsOperator.or) {
        _cardDropAreaTable.setNumberOfZones(2);
      } else {
        _cardDropAreaTable.setNumberOfZones(1);
      }
    }

    _cardFanDraggableService.onDragStart(this);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);
    _cardFanDraggableService.onDragUpdate(event, this);
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    _cardFanDraggableService.onDragEnd(this);
  }
}
