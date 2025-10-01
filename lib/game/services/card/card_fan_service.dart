import 'package:card_battler/game/card_battler_game.dart';
import 'package:card_battler/game/game_variables.dart';
import 'package:card_battler/game/services/card/card_fan_selection_service.dart';
import 'package:card_battler/game/services/game/game_phase_manager.dart';
import 'package:card_battler/game/ui/components/card/card_drop_area.dart';
import 'package:card_battler/game/ui/components/card/interactive_card_sprite.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

class CardFanService {
  CardFanService(
    Vector2 size,
    GamePhaseManager gamePhaseManager,
    Function(InteractiveCardSprite) onCardPlayed,
    Function(SpriteComponent) onShowCardAtCenter,
    Function(SpriteComponent) onRemoveCardAtCenter,
  ) : _size = size,
      _gamePhaseManager = gamePhaseManager,
      _onCardPlayed = onCardPlayed,
      _onShowCardAtCenter = onShowCardAtCenter,
      _onRemoveCardAtCenter = onRemoveCardAtCenter {
    cardSelectionService = CardFanSelectionService(
      _size,
      _onShowCardAtCenter,
      _onRemoveCardAtCenter,
    );
  }

  final Vector2 _size;
  final GamePhaseManager _gamePhaseManager;
  final Function(InteractiveCardSprite) _onCardPlayed;
  final Function(SpriteComponent) _onShowCardAtCenter;
  final Function(SpriteComponent) _onRemoveCardAtCenter;

  late CardFanSelectionService cardSelectionService;

  late CardBattlerGame game;
  late CardDragDropArea dropArea;

  Vector2 _dragStartPosition = Vector2.zero();
  bool _isBeingDragged = false;
  Vector2 _originalPositionBeforeDrag = Vector2.zero();
  double _originalAngleBeforeDrag = 0.0;

  void onTapDown(Vector2 position) {
    cardSelectionService.findHighestPriorityCardSpriteAndSelect(position);
  }

  void onDragStart(Vector2 position) {
    _dragStartPosition = position;
  }

  void onDragUpdate(DragUpdateEvent event) {
    final deltaY = _dragStartPosition.y - event.canvasStartPosition.y;
    final deltaX = _dragStartPosition.x - event.canvasStartPosition.x;

    if (_isBeingDragged) {
      cardSelectionService.selectedCard?.position += event.canvasDelta;
      final canBeDropped = _isCardIntersectingDropArea(
        cardSelectionService.selectedCard!,
        dropArea,
      );

      dropArea.isHighlighted = canBeDropped;
    } else if (deltaX.abs() > 15) {
      _dragStartPosition = event.canvasStartPosition;
      cardSelectionService.findHighestPriorityCardSpriteAndSelect(
        event.canvasStartPosition,
      );
    } else if (deltaY.abs() > 30 &&
        !_isBeingDragged &&
        cardSelectionService.selectedCard != null &&
        _gamePhaseManager.currentPhase == GamePhase.playerTakeActionsTurn) {
      _setupForDraggings(event);
    }
  }

  void onDragEnd() {
    _dragStartPosition = Vector2.zero();

    if (_isBeingDragged) {
      if (dropArea.isHighlighted) {
        dropArea.isHighlighted = false;
        _onCardPlayed.call(cardSelectionService.selectedCard!);
      } else {
        // Card was not dropped in the drop area, return to original position
        _returnDragedCardToOriginalPosition();
      }
      _returnDragedCardToOriginalPosition();
    } else {
      cardSelectionService.deselectCard();
    }
  }

  void onTapUp() {
    cardSelectionService.deselectCard();
  }

  bool _isCardIntersectingDropArea(
    InteractiveCardSprite card,
    CardDragDropArea dropArea,
  ) {
    // Calculate card's absolute position and bounds
    final cardRect = Rect.fromLTWH(
      card.absolutePosition.x -
          (GameVariables.defaultCardSizeWidth * card.scale.x) / 2,
      card.absolutePosition.y -
          (GameVariables.defaultCardSizeHeight * card.scale.y) / 2,
      GameVariables.defaultCardSizeWidth * card.scale.x,
      GameVariables.defaultCardSizeHeight * card.scale.y,
    );

    // Calculate drop area's absolute position and bounds
    final dropRect = Rect.fromLTWH(
      dropArea.absolutePosition.x,
      dropArea.absolutePosition.y,
      dropArea.size.x,
      dropArea.size.y,
    );

    // print(
    //   'Card Rect: ${cardRect.left}, ${cardRect.top}, ${cardRect.width}, ${cardRect.height}',
    // );
    // print(
    //   'Drop Rect: ${dropRect.left}, ${dropRect.top}, ${dropRect.width}, ${dropRect.height}',
    // );

    return cardRect.overlaps(dropRect);
  }

  void _setupForDraggings(DragUpdateEvent event) {
    _onRemoveCardAtCenter.call(cardSelectionService.duplicateCard!);
    _originalPositionBeforeDrag = cardSelectionService.selectedCard!.position
        .clone();
    _originalAngleBeforeDrag = cardSelectionService.selectedCard!.angle;
    cardSelectionService.selectedCard?.angle = 0;
    _isBeingDragged = true;
    cardSelectionService.selectedCard?.position += event.canvasDelta;
    dropArea.isVisible = true;
  }

  void _returnDragedCardToOriginalPosition() {
    _isBeingDragged = false;
    cardSelectionService.selectedCard?.position = _originalPositionBeforeDrag;
    cardSelectionService.selectedCard?.angle = _originalAngleBeforeDrag;
    cardSelectionService.selectedCard?.isSelected = false;
    cardSelectionService.selectedCard = null;
    dropArea.isVisible = false;
  }
}
