import 'package:card_battler/game/services/card/card_fan_selection_service.dart';
import 'package:card_battler/game/services/game/game_phase_manager.dart';
import 'package:card_battler/game/ui/components/card/card_drop_area_table.dart';
import 'package:card_battler/game/ui/components/card/interactive_card_sprite.dart';
import 'package:card_battler/game/ui/components/common/darkening_overlay.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';

class CardFanDraggableService {
  CardFanDraggableService(
    CardFanSelectionService cardSelectionService,
    GamePhaseManager gamePhaseManager,
    Function(InteractiveCardSprite) onCardPlayed,
    Function(SpriteComponent) onRemoveCardAtCenter,
  ) : _cardSelectionService = cardSelectionService,
      _gamePhaseManager = gamePhaseManager,
      _onCardPlayed = onCardPlayed,
      _onRemoveCardAtCenter = onRemoveCardAtCenter;

  final CardFanSelectionService _cardSelectionService;
  final GamePhaseManager _gamePhaseManager;
  final Function(InteractiveCardSprite) _onCardPlayed;
  final Function(SpriteComponent) _onRemoveCardAtCenter;

  late CardDropAreaTable dropArea;
  DarkeningOverlay? darkeningOverlay;

  Vector2 _dragStartPosition = Vector2.zero();
  bool _isBeingDragged = false;
  Vector2 _originalPositionBeforeDrag = Vector2.zero();
  double _originalAngleBeforeDrag = 0.0;

  void onDragStart(Vector2 position) {
    _dragStartPosition = position;
  }

  void onDragUpdate(DragUpdateEvent event) {
    final deltaY = _dragStartPosition.y - event.canvasStartPosition.y;
    final deltaX = _dragStartPosition.x - event.canvasStartPosition.x;

    if (_isBeingDragged) {
      _cardSelectionService.selectedCard?.position += event.canvasDelta;
      _checkTableZoneIntersection(
        _cardSelectionService.selectedCard!,
        dropArea,
      );
    } else if (deltaX.abs() > 15) {
      _dragStartPosition = event.canvasStartPosition;
      _cardSelectionService.findHighestPriorityCardSpriteAndSelect(
        event.canvasStartPosition,
      );
    } else if (deltaY.abs() > 30 &&
        !_isBeingDragged &&
        _cardSelectionService.selectedCard != null &&
        _gamePhaseManager.currentPhase == GamePhase.playerTakeActionsTurn) {
      _setupForDraggings(event);
    }
  }

  void onDragEnd() {
    _dragStartPosition = Vector2.zero();

    if (_isBeingDragged) {
      if (dropArea.isLeftZoneHighlighted || dropArea.isRightZoneHighlighted) {
        // Store which zone was selected for effect processing
        final selectedZone = dropArea.highlightedZone;
        _cardSelectionService.selectedCard?.coordinator.selectedEffectIndex =
            selectedZone;
        dropArea.isLeftZoneHighlighted = false;
        dropArea.isRightZoneHighlighted = false;
        _onCardPlayed.call(_cardSelectionService.selectedCard!);
      } else {
        _returnDragedCardToOriginalPosition();
      }

      dropArea.isVisible = false;
      darkeningOverlay?.isVisible = false;
    } else {
      _cardSelectionService.deselectCard();
    }
  }

  void _setupForDraggings(DragUpdateEvent event) {
    _onRemoveCardAtCenter.call(_cardSelectionService.duplicateCard!);
    _originalPositionBeforeDrag = _cardSelectionService.selectedCard!.position
        .clone();
    _originalAngleBeforeDrag = _cardSelectionService.selectedCard!.angle;
    _cardSelectionService.selectedCard?.angle = 0;
    _cardSelectionService.selectedCard?.isPerspectiveMode = true;
    _isBeingDragged = true;
    _cardSelectionService.selectedCard?.position += event.canvasDelta;
    dropArea.isVisible = true;
    darkeningOverlay?.isVisible = true;
  }

  void _returnDragedCardToOriginalPosition() {
    _isBeingDragged = false;
    _cardSelectionService.selectedCard?.position = _originalPositionBeforeDrag;
    _cardSelectionService.selectedCard?.angle = _originalAngleBeforeDrag;
    _cardSelectionService.selectedCard?.isPerspectiveMode = false;
    _cardSelectionService.selectedCard?.isSelected = false;
    _cardSelectionService.selectedCard = null;
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
