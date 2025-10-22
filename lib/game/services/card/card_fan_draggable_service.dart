import 'package:card_battler/game/services/game/game_phase_manager.dart';
import 'package:card_battler/game/ui/components/card/card_drop_area_table.dart';
import 'package:card_battler/game/ui/components/card/interactive_card_sprite.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';

class CardFanDraggableService {
  CardFanDraggableService(
    GamePhaseManager gamePhaseManager,
    CardDropAreaTable dropArea,
    Function(InteractiveCardSprite) onCardPlayed,
  ) : _gamePhaseManager = gamePhaseManager,
      _dropArea = dropArea,
      _onCardPlayed = onCardPlayed;

  final GamePhaseManager _gamePhaseManager;
  final Function(InteractiveCardSprite) _onCardPlayed;
  final CardDropAreaTable _dropArea;

  Vector2 _originalPositionBeforeDrag = Vector2.zero();

  void onDragStart(InteractiveCardSprite card) {
    if (_gamePhaseManager.currentPhase != GamePhase.playerTakeActionsTurn) {
      return;
    }

    _setupForDraggings(card);
  }

  void onDragUpdate(DragUpdateEvent event, InteractiveCardSprite card) {
    if (_gamePhaseManager.currentPhase != GamePhase.playerTakeActionsTurn) {
      return;
    }

    card.position += event.canvasDelta;
    _checkTableZoneIntersection(card, _dropArea);
  }

  void onDragEnd(InteractiveCardSprite card) {
    if (_gamePhaseManager.currentPhase != GamePhase.playerTakeActionsTurn) {
      return;
    }

    if (_dropArea.isLeftZoneHighlighted || _dropArea.isRightZoneHighlighted) {
      final selectedZone = _dropArea.highlightedZone;
      card.coordinator.selectedEffectIndex = selectedZone;
      _dropArea.isLeftZoneHighlighted = false;
      _dropArea.isRightZoneHighlighted = false;
      _onCardPlayed.call(card);
    } else {
      _returnDragedCardToOriginalPosition(card);
    }

    _dropArea.isVisible = false;
  }

  void _setupForDraggings(InteractiveCardSprite card) {
    _originalPositionBeforeDrag = card.position.clone();
    card.isPerspectiveMode = true;
    _dropArea.isVisible = true;
  }

  void _returnDragedCardToOriginalPosition(InteractiveCardSprite card) {
    card.position = _originalPositionBeforeDrag;
    card.isPerspectiveMode = false;
    card.isSelected = false;
  }

  /// Checks if a point is within the perspective-adjusted drop area
  /// The front (bottom) has a smaller hit area than the back (top)
  bool _isPointInPerspectiveDropArea(
    double pointX,
    double pointY,
    CardDropArea dropArea,
  ) {
    final tableLeft = dropArea.absolutePosition.x;
    final tableTop = dropArea.absolutePosition.y;
    final tableWidth = dropArea.width;
    final tableHeight = dropArea.height;

    // Table is a trapezoid: back is 70% of front width
    final frontWidth = tableWidth;
    final backWidth = tableWidth * 0.7;

    // Calculate how far down the table the point is (0.0 = back/top, 1.0 = front/bottom)
    final normalizedY = (pointY - tableTop) / tableHeight;

    // Point must be within vertical bounds
    if (normalizedY < 0.0 || normalizedY > 1.0) {
      return false;
    }

    // Interpolate width at this Y position (back is narrower, front is wider)
    final widthAtY = backWidth + (frontWidth - backWidth) * normalizedY;
    final offsetAtY = (frontWidth - widthAtY) / 2;

    // Calculate left and right bounds at this Y position
    final leftBoundAtY = tableLeft + offsetAtY;
    final rightBoundAtY = tableLeft + offsetAtY + widthAtY;

    // Expand the hit area based on depth (perspective compensation)
    // Front (normalizedY near 1.0) needs less expansion, back needs more
    final expansionFactor =
        50.0 * (1.0 - normalizedY * 0.5); // More expansion at back
    final expandedLeft = leftBoundAtY - expansionFactor;
    final expandedRight = rightBoundAtY + expansionFactor;

    return pointX >= expandedLeft && pointX <= expandedRight;
  }

  void _checkTableZoneIntersection(
    InteractiveCardSprite card,
    CardDropAreaTable tableArea,
  ) {
    // Use card center position (where the mouse/finger is)
    final cardCenterX = card.absolutePosition.x;
    final cardCenterY = card.absolutePosition.y;

    // Check if the point is within the perspective-aware drop area
    final isInTable = _isPointInPerspectiveDropArea(
      cardCenterX,
      cardCenterY,
      tableArea,
    );

    if (!isInTable) {
      // Not over the table at all
      tableArea.isLeftZoneHighlighted = false;
      tableArea.isRightZoneHighlighted = false;
      return;
    }

    if (tableArea.numberOfZones == 1) {
      // Single zone - highlight the entire table
      tableArea.isLeftZoneHighlighted = true;
      tableArea.isRightZoneHighlighted = false;
    } else {
      // Two zones - determine which zone based on card center X position
      // Need to account for perspective: the divider line goes from back-center to front-center
      final tableCenterX = tableArea.absolutePosition.x + tableArea.width / 2;

      if (cardCenterX < tableCenterX) {
        // Card center is on left side
        tableArea.isLeftZoneHighlighted = true;
        tableArea.isRightZoneHighlighted = false;
      } else {
        // Card center is on right side
        tableArea.isLeftZoneHighlighted = false;
        tableArea.isRightZoneHighlighted = true;
      }
    }
  }
}
