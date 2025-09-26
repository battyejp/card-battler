import 'dart:math' as math;
import 'dart:ui';
import 'package:card_battler/game/card_battler_game.dart';
import 'package:card_battler/game/coordinators/components/cards/card_list_coordinator.dart';
import 'package:card_battler/game/game_variables.dart';
import 'package:card_battler/game/services/game/game_phase_manager.dart';
import 'package:card_battler/game/ui/components/card/card_sprite.dart';
import 'package:card_battler/game/ui/components/card/interactive_card_sprite.dart';
import 'package:card_battler/game/ui/components/common/reactive_position_component.dart';
import 'package:card_battler/game/ui/components/scenes/game_scene.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';

//TODO so indication of no cards
class CardFan extends ReactivePositionComponent<CardListCoordinator> {
  CardFan(
    super.coordinator, {
    GamePhaseManager? gamePhaseManager,
    double fanAngle = math.pi / 2, // pi is 180 degrees so pi/2 is 90 degrees
    double fanRadius = 200.0,
    bool mini = false,
    double cardScale = 0.4,
  }) {
    _fanAngle = fanAngle;
    _fanRadius = fanRadius;
    _mini = mini;
    _cardScale = cardScale;
    _gamePhaseManager = gamePhaseManager;
  }

  late final GamePhaseManager? _gamePhaseManager;
  late double _fanAngle;
  late double _fanRadius;
  late bool _mini;
  late double _cardScale;
  final List<CardSprite> _cards = [];

  // @override
  // void render(Canvas canvas) {
  //   final paint = Paint()..color = const Color.fromARGB(255, 52, 4, 195);
  //   canvas.drawRect(size.toRect(), paint);
  // }

  @override
  void updateDisplay() {
    super.updateDisplay();
    _createCardFan();

    if (!_mini) {
      final draggableArea = CardFanDraggableArea(_gamePhaseManager)
        ..size = Vector2(size.x, size.y)
        ..priority = 1000
        ..position = Vector2(
          0,
          -320,
        ); //TODO needs to be dynamic based on fanRadius and size could be smaller, can it mirror the size of the fan?
      add(draggableArea);

      draggableArea.onCardDropped = (card) {
        card.coordinator.handleCardPlayed();
      };
    }
  }

  void _createCardFan() {
    final cardCount = coordinator.cardCoordinators.length;
    final startAngle = -_fanAngle / 2; // Start from left side of fan
    final angleStep = cardCount > 1
        ? _fanAngle / (cardCount - 1)
        : 0; // Angle between cards

    for (var i = 0; i < cardCount; i++) {
      final cardCoordinator = coordinator.cardCoordinators[i];
      final angle = cardCount == 1 ? 0 : startAngle + (i * angleStep);

      final cardX = _fanRadius * math.sin(angle) + size.x / 2;
      final cardY = -_fanRadius * math.cos(angle);

      final card = _mini
          ? CardSprite(cardCoordinator, _mini)
          : InteractiveCardSprite(cardCoordinator, false);

      card
        ..position = Vector2(cardX, cardY)
        ..scale = Vector2.all(_cardScale)
        ..anchor = Anchor.center
        ..priority = i;

      card.angle = angle * 0.5; // Reduced rotation for subtle effect

      add(card);
      _cards.add(card);
    }
  }
}

//TODO this probably needs to be extracted to services
class CardFanDraggableArea extends PositionComponent
    with DragCallbacks, TapCallbacks {
  CardFanDraggableArea(GamePhaseManager? gamePhaseManager) {
    _gamePhaseManager = gamePhaseManager;
  }

  late GamePhaseManager? _gamePhaseManager;
  Function(InteractiveCardSprite)? onCardDropped;

  //TODO set these just once
  late CardBattlerGame _game;
  late CardDragDropArea _dropArea;

  InteractiveCardSprite? _selectedCard;

  /// Finds the nearest CardSprite to the given position
  InteractiveCardSprite? findNearestCardSprite(Vector2 position) {
    _game = findGame() as CardBattlerGame;
    final components = _game.componentsAtPoint(position);
    _dropArea = _findCardDragDropArea()!;

    // Filter to only CardSprite components
    final cardSprites = components.whereType<InteractiveCardSprite>().toList();

    if (cardSprites.isEmpty) {
      return null;
    }

    if (cardSprites.length == 1) {
      return cardSprites.first;
    }

    // Find the nearest card by calculating distance
    InteractiveCardSprite? nearestCard;
    var nearestDistance = double.infinity;

    for (final card in cardSprites) {
      final distance = (card.position - position).length;
      if (distance < nearestDistance) {
        nearestDistance = distance;
        nearestCard = card;
      }
    }

    return nearestCard;
  }

  void findHighestPriorityCardSpriteAndSelect(Vector2 position) {
    _game = findGame() as CardBattlerGame;
    final components = _game.componentsAtPoint(position);
    _dropArea = _findCardDragDropArea()!;

    // Filter to only InteractiveCardSprite components
    final cardSprites = components.whereType<InteractiveCardSprite>().toList();

    if (cardSprites.isEmpty) {
      return;
    }

    var highestPriority = -1;
    final comps = cardSprites.whereType<PositionComponent>();
    for (final comp in comps) {
      if (comp.priority > highestPriority) {
        highestPriority = comp.priority;
      }
    }

    // Return the topmost card (last in the list)
    final card = cardSprites.lastWhere(
      (card) => card.priority == highestPriority,
    );
    _selectCard(card);
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    _game = findGame() as CardBattlerGame;
    findHighestPriorityCardSpriteAndSelect(event.canvasPosition);
  }

  var _dragStartPosition = Vector2.zero();

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);

    _dragStartPosition = event.canvasPosition;
  }

  bool _isBeingDragged = false;
  Vector2 _originalPositionBeforeDrag = Vector2.zero();
  double _originalAngleBeforeDrag = 0.0;

  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);

    final deltaY = _dragStartPosition.y - event.canvasStartPosition.y;
    final deltaX = _dragStartPosition.x - event.canvasStartPosition.x;

    if (_isBeingDragged) {
      _selectedCard?.position += event.canvasDelta;
      final canBeDropped = _isCardIntersectingDropArea(
        _selectedCard!,
        _dropArea,
      );
      _dropArea.isHighlighted = canBeDropped;
    } else if (deltaX.abs() > 15) {
      _dragStartPosition = event.canvasStartPosition;
      findHighestPriorityCardSpriteAndSelect(event.canvasStartPosition);
    } else if (deltaY.abs() > 30 &&
        !_isBeingDragged &&
        _selectedCard != null &&
        _gamePhaseManager?.currentPhase == GamePhase.playerTakeActionsTurn) {
      _setupForDraggings(event);
    }
  }

  void _setupForDraggings(DragUpdateEvent event) {
    remove(_duplicateCard!);
    _originalPositionBeforeDrag = _selectedCard!.position.clone();
    _originalAngleBeforeDrag = _selectedCard!.angle;
    _selectedCard?.angle = 0;
    _isBeingDragged = true;
    _selectedCard?.position += event.canvasDelta;
    _dropArea.isVisible = true;
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    _dragStartPosition = Vector2.zero();

    if (_isBeingDragged) {
      if (_dropArea.isHighlighted) {
        _dropArea.isHighlighted = false;
        onCardDropped?.call(_selectedCard!);
      } else {
        // Card was not dropped in the drop area, return to original position
        _returnDragedCardToOriginalPosition();
      }
      _returnDragedCardToOriginalPosition();
    } else {
      _deselectCard();
    }
  }

  void _returnDragedCardToOriginalPosition() {
    _isBeingDragged = false;
    _selectedCard?.position = _originalPositionBeforeDrag;
    _selectedCard?.angle = _originalAngleBeforeDrag;
    _selectedCard?.isSelected = false;
    _selectedCard = null;
    _dropArea.isVisible = false;
  }

  @override
  void onTapUp(TapUpEvent event) {
    super.onTapUp(event);
    _deselectCard();
  }

  void _selectCard(InteractiveCardSprite? card) {
    if (card == null || card == _selectedCard) {
      return;
    }

    if (_selectedCard != null) {
      _removeDuplicateCardAtCenter(_selectedCard!);
      _selectedCard?.isSelected = false;
    }

    _showDuplicateCardAtCenter(card);
    _selectedCard = card;
    _selectedCard?.isSelected = true;
  }

  void _deselectCard() {
    if (_selectedCard == null) {
      return;
    }

    _removeDuplicateCardAtCenter(_selectedCard!);
    _selectedCard?.isSelected = false;
    _selectedCard = null;
  }

  SpriteComponent? _duplicateCard;
  void _showDuplicateCardAtCenter(InteractiveCardSprite card) {
    card.isSelected = true;

    final image = _game.images.fromCache(card.getFileName);
    const scale = 0.75;

    _duplicateCard = SpriteComponent(sprite: Sprite(image))
      ..scale = Vector2.all(scale);

    _duplicateCard!.position = Vector2(
      size.x / 2 - _duplicateCard!.size.x * scale / 2,
      -_duplicateCard!.size.y * scale,
    );
    add(_duplicateCard!);
  }

  void _removeDuplicateCardAtCenter(InteractiveCardSprite card) {
    remove(_duplicateCard!);
    card.isSelected = false;
  }

  //TODO probably delete as could just pass in the drop area from game scene
  CardDragDropArea? _findCardDragDropArea() {
    final cardFan = parent;
    if (cardFan != null) {
      final player = cardFan.parent;
      if (player != null) {
        final gameScene = player.parent;
        if (gameScene != null) {
          final dropArea = gameScene.children
              .whereType<CardDragDropArea>()
              .firstOrNull;
          return dropArea;
        }
      }
    }
    return null;
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
      dropArea.absolutePosition.y, // TODO why is it -151.5, y is messed up
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

  // @override
  // void render(Canvas canvas) {
  //   final paint = Paint()
  //     ..color = const Color.fromARGB(77, 195, 4, 4); // Red with 0.3 opacity
  //   canvas.drawRect(size.toRect(), paint);
  // }
}
