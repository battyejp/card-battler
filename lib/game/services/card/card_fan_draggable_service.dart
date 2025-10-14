import 'package:card_battler/game/game_variables.dart';
import 'package:card_battler/game/services/card/card_fan_selection_service.dart';
import 'package:card_battler/game/services/game/game_phase_manager.dart';
import 'package:card_battler/game/ui/components/card/card_drop_area.dart';
import 'package:card_battler/game/ui/components/card/interactive_card_sprite.dart';
import 'package:card_battler/game/ui/components/common/darkening_overlay.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

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

  late CardDragDropArea dropArea;
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
      final canBeDropped = _isCardIntersectingDropArea(
        _cardSelectionService.selectedCard!,
        dropArea,
      );

      dropArea.isHighlighted = canBeDropped;
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
      if (dropArea.isHighlighted) {
        dropArea.isHighlighted = false;
        _onCardPlayed.call(_cardSelectionService.selectedCard!);
      } else {
        // Card was not dropped in the drop area, return to original position
        _returnDragedCardToOriginalPosition();
      }
      _returnDragedCardToOriginalPosition();
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
    _isBeingDragged = true;
    _cardSelectionService.selectedCard?.position += event.canvasDelta;
    dropArea.isVisible = true;
    darkeningOverlay?.isVisible = true;
  }

  void _returnDragedCardToOriginalPosition() {
    _isBeingDragged = false;
    _cardSelectionService.selectedCard?.position = _originalPositionBeforeDrag;
    _cardSelectionService.selectedCard?.angle = _originalAngleBeforeDrag;
    _cardSelectionService.selectedCard?.isSelected = false;
    _cardSelectionService.selectedCard = null;
    dropArea.isVisible = false;
    darkeningOverlay?.isVisible = false;
  }

  bool _isCardIntersectingDropArea(
    InteractiveCardSprite card,
    CardDragDropArea dropArea,
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
}
