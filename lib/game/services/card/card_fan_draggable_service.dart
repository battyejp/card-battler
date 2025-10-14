import 'package:card_battler/game/game_variables.dart';
import 'package:card_battler/game/services/card/card_fan_selection_service.dart';
import 'package:card_battler/game/services/game/game_phase_manager.dart';
import 'package:card_battler/game/ui/components/card/card_drop_area_table.dart';
import 'package:card_battler/game/ui/components/card/interactive_card_sprite.dart';
import 'package:card_battler/game/ui/components/common/darkening_overlay.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

// Base interface for drop areas
abstract class CardDropArea {
  bool get isHighlighted;
  set isHighlighted(bool value);
  bool get isVisible;
  set isVisible(bool value);
  Vector2 get absolutePosition;
  double get width;
  double get height;
}

// Stores information about where a card was dropped
class CardDropInfo {
  CardDropInfo({required this.zoneIndex});

  final int zoneIndex; // 0 = single zone or left zone, 1 = right zone
}

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

  late CardDropArea dropArea;
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

      // Check if it's a table drop area
      if (dropArea is CardDropAreaTable) {
        final tableArea = dropArea as CardDropAreaTable;
        _checkTableZoneIntersection(
          _cardSelectionService.selectedCard!,
          tableArea,
        );
      } else {
        final canBeDropped = _isCardIntersectingDropArea(
          _cardSelectionService.selectedCard!,
          dropArea,
        );
        dropArea.isHighlighted = canBeDropped;
      }
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
      var wasDropped = false;

      // Check if it's a table drop area
      if (dropArea is CardDropAreaTable) {
        final tableArea = dropArea as CardDropAreaTable;
        if (tableArea.isLeftZoneHighlighted ||
            tableArea.isRightZoneHighlighted) {
          wasDropped = true;
          // Store which zone was selected for effect processing
          final selectedZone = tableArea.highlightedZone;
          _cardSelectionService.selectedCard?.coordinator.selectedEffectIndex =
              selectedZone;
          tableArea.isLeftZoneHighlighted = false;
          tableArea.isRightZoneHighlighted = false;
          _onCardPlayed.call(_cardSelectionService.selectedCard!);
        }
      } else {
        if (dropArea.isHighlighted) {
          wasDropped = true;
          dropArea.isHighlighted = false;
          // For single zone, always use index 0 (apply all effects)
          _cardSelectionService.selectedCard?.coordinator.selectedEffectIndex =
              0;
          _onCardPlayed.call(_cardSelectionService.selectedCard!);
        }
      }

      if (!wasDropped) {
        // Card was not dropped in any drop area, return to original position
        _returnDragedCardToOriginalPosition();
      } else {
        _returnDragedCardToOriginalPosition();
      }
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
    dropArea.isVisible = false;
    darkeningOverlay?.isVisible = false;
  }

  bool _isCardIntersectingDropArea(
    InteractiveCardSprite card,
    CardDropArea dropArea,
  ) {
    // Calculate card's absolute position and bounds
    final cardRect = Rect.fromLTWH(
      card.absolutePosition.x -
          (GameVariables.defaultCardSizeWidth * card.scale.x).toDouble() / 2,
      card.absolutePosition.y -
          (GameVariables.defaultCardSizeHeight * card.scale.y).toDouble() / 2,
      (GameVariables.defaultCardSizeWidth * card.scale.x).toDouble(),
      (GameVariables.defaultCardSizeHeight * card.scale.y).toDouble(),
    );

    // Calculate drop area's absolute position and bounds
    final dropRect = Rect.fromLTWH(
      dropArea.absolutePosition.x,
      dropArea.absolutePosition.y,
      dropArea.width,
      dropArea.height,
    );

    // print(
    //   'Card Rect: ${cardRect.left}, ${cardRect.top}, ${cardRect.width}, ${cardRect.height}',
    // );
    // print(
    //   'Drop Rect: ${dropRect.left}, ${dropRect.top}, ${dropRect.width}, ${dropRect.height}',
    // );

    return cardRect.overlaps(dropRect);
  }

  void _checkTableZoneIntersection(
    InteractiveCardSprite card,
    CardDropAreaTable tableArea,
  ) {
    // Calculate card's absolute position and bounds
    final cardRect = Rect.fromLTWH(
      card.absolutePosition.x -
          (GameVariables.defaultCardSizeWidth * card.scale.x).toDouble() / 2,
      card.absolutePosition.y -
          (GameVariables.defaultCardSizeHeight * card.scale.y).toDouble() / 2,
      (GameVariables.defaultCardSizeWidth * card.scale.x).toDouble(),
      (GameVariables.defaultCardSizeHeight * card.scale.y).toDouble(),
    );

    if (tableArea.numberOfZones == 1) {
      // Single zone - check entire table
      final tableRect = Rect.fromLTWH(
        tableArea.absolutePosition.x,
        tableArea.absolutePosition.y,
        tableArea.width,
        tableArea.height,
      );
      tableArea.isLeftZoneHighlighted = cardRect.overlaps(tableRect);
      tableArea.isRightZoneHighlighted = false;
    } else {
      // Two zones - check left and right halves
      final leftRect = Rect.fromLTWH(
        tableArea.absolutePosition.x,
        tableArea.absolutePosition.y,
        tableArea.width / 2,
        tableArea.height,
      );

      final rightRect = Rect.fromLTWH(
        tableArea.absolutePosition.x + tableArea.width / 2,
        tableArea.absolutePosition.y,
        tableArea.width / 2,
        tableArea.height,
      );

      // Check intersections
      tableArea.isLeftZoneHighlighted = cardRect.overlaps(leftRect);
      tableArea.isRightZoneHighlighted = cardRect.overlaps(rightRect);
    }
  }
}
