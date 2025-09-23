import 'dart:math' as math;
import 'dart:ui';
import 'package:card_battler/game/card_battler_game.dart';
import 'package:card_battler/game/ui/components/card/card_sprite.dart';
import 'package:card_battler/game/ui/components/card/interactive_card_sprite.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';

class CardFan extends PositionComponent {
  CardFan({
    int initialCardCount = 0,
    double fanAngle = math.pi / 2, // pi is 180 degrees so pi/2 is 90 degrees
    double fanRadius = 200.0,
    bool mini = false,
    double cardScale = 0.4,
  }) {
    _cardCount = initialCardCount;
    _fanAngle = fanAngle;
    _fanRadius = fanRadius;
    _mini = mini;
    _cardScale = cardScale;
  }

  late int _cardCount;
  late double _fanAngle;
  late double _fanRadius;
  late bool _mini;
  late double _cardScale;
  final List<CardSprite> _cards = [];

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await _createCardFan();

    if (!_mini) {
      final draggableArea = CardFanDraggableArea()
        ..size = Vector2(size.x, size.y)
        ..position = Vector2(
          0,
          -320,
        ); //TODO needs to be dynamic based on fanRadius and size could be smaller

      add(draggableArea);
    }
  }

  Future<void> _createCardFan() async {
    final startAngle = -_fanAngle / 2; // Start from left side of fan
    final angleStep = _cardCount > 1
        ? _fanAngle / (_cardCount - 1)
        : 0; // Angle between cards

    final arrayOfImages = [
      'card_alien_size.png',
      'card_alien2_size.png',
      'card_human_f_size.png',
      'card_human_m_size.png',
      'card_robot_size.png',
      'card_robot2_size.png',
      'card_human_f2_size.png',
    ];

    for (var i = 0; i < _cardCount; i++) {
      final angle = _cardCount == 1 ? 0 : startAngle + (i * angleStep);

      final cardX = _fanRadius * math.sin(angle) + size.x / 2;
      final cardY = -_fanRadius * math.cos(angle);

      final cardImagePath = arrayOfImages[i % _cardCount].replaceAll(
        'size',
        _mini ? '60' : '560',
      );

      final card = _mini
          ? CardSprite(cardImagePath)
          : InteractiveCardSprite(cardImagePath);

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

  // @override
  // void render(Canvas canvas) {
  //   super.render(canvas);
  //   final paint = Paint()
  //     ..color = const Color.fromARGB(199, 237, 245, 2);
  //   canvas.drawRect(size.toRect(), paint);
  // }
}

class CardFanDraggableArea extends PositionComponent
    with DragCallbacks, TapCallbacks {
  CardFanDraggableArea();

  late CardBattlerGame _game;
  InteractiveCardSprite? _selectedCard;

  /// Finds the nearest CardSprite to the given position
  InteractiveCardSprite? findNearestCardSprite(Vector2 position) {
    _game = findGame() as CardBattlerGame;
    final components = _game.componentsAtPoint(position);

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
    final components = _game.componentsAtPoint(
      position,
    ); //TODO just look for components in this area/card fan

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
    } else if (deltaX.abs() > 15) {
      _dragStartPosition = event.canvasStartPosition;
      findHighestPriorityCardSpriteAndSelect(event.canvasStartPosition);
    } else if (deltaY > 30 && !_isBeingDragged && _selectedCard != null) {
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
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    _dragStartPosition = Vector2.zero();

    if (_isBeingDragged) {
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
    _duplicateCard = SpriteComponent(sprite: Sprite(image));

    _duplicateCard!.position = Vector2(
      size.x / 2 - _duplicateCard!.size.x / 2,
      -_duplicateCard!.size.y,
    );
    add(_duplicateCard!);
  }

  void _removeDuplicateCardAtCenter(InteractiveCardSprite card) {
    remove(_duplicateCard!);
    card.isSelected = false;
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint()
      ..color = const Color.fromARGB(77, 195, 4, 4); // Red with 0.3 opacity
    canvas.drawRect(size.toRect(), paint);
  }
}
