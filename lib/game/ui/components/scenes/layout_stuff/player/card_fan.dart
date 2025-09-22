import 'dart:math' as math;
import 'dart:ui';

import 'package:card_battler/game/card_battler_game.dart';
import 'package:card_battler/game/ui/components/scenes/layout_stuff/player/card_sprite.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

class CardFan extends PositionComponent {
  CardFan({
    required Vector2 position,
    int initialCardCount = 0,
    this.fanAngle = math.pi / 2, // pi is 180 degrees so pi/2 is 90 degrees
    this.fanRadius = 200.0,
    this.cardImagePath = 'card_face_up_0.2.png',
    this.cardScale = 0.4,
  }) : super(position: position) {
    cardCount = initialCardCount;
  }

  int cardCount = 0;
  final double fanAngle;
  final double fanRadius;
  final String cardImagePath;
  final double cardScale;

  // List to track the cards in the fan
  final List<CardSprite> _cards = [];

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await _createCardFan();

    final draggableArea = CardFanDraggableArea(
      position: Vector2(-fanRadius - 50, -fanRadius - 100),
      size: Vector2((fanRadius + 50) * 2, fanRadius + 120),
    );

    add(draggableArea);
  }

  Future<void> _createCardFan() async {
    final startAngle = -fanAngle / 2; // Start from left side of fan
    final angleStep = cardCount > 1
        ? fanAngle / (cardCount - 1)
        : 0; // Angle between cards

    for (var i = 0; i < cardCount; i++) {
      final angle = cardCount == 1 ? 0 : startAngle + (i * angleStep);

      // Calculate card position on the fan arc
      final cardX = fanRadius * math.sin(angle);
      final cardY = -fanRadius * math.cos(angle);

      // Create card sprite component
      final card = CardSprite(Vector2(cardX, cardY), cardImagePath, 'Card $i')
        ..scale = Vector2.all(cardScale)
        ..anchor = Anchor.center
        ..priority = i; // Ensure correct rendering order

      // Rotate card to follow fan angle for realistic hand appearance
      card.angle = angle * 0.5; // Reduced rotation for subtle effect

      add(card);
      _cards.add(card);
    }
  }

  /// Add a new card to the fan and redraw
  void addCard({String? imagePath}) {
    cardCount++;
    _redrawFan();
  }

  /// Remove all cards and redraw the fan with current cardCount
  void _redrawFan() {
    // Remove all existing cards
    for (final card in _cards) {
      remove(card);
    }
    _cards.clear();

    // Redraw the fan with new card count
    _createCardFan();
  }
}

class CardFanDraggableArea extends PositionComponent
    with DragCallbacks, TapCallbacks {
  CardFanDraggableArea({required Vector2 position, required Vector2 size})
    : super(position: position, size: size);

  late CardBattlerGame _game;
  CardSprite? _selectedCard;

  /// Finds the nearest CardSprite to the given position
  CardSprite? findNearestCardSprite(Vector2 position) {
    _game = findGame() as CardBattlerGame;
    final components = _game.componentsAtPoint(position);

    // Filter to only CardSprite components
    final cardSprites = components.whereType<CardSprite>().toList();

    if (cardSprites.isEmpty) {
      return null;
    }

    if (cardSprites.length == 1) {
      return cardSprites.first;
    }

    // Find the nearest card by calculating distance
    CardSprite? nearestCard;
    double nearestDistance = double.infinity;

    for (final card in cardSprites) {
      final distance = (card.position - position).length;
      if (distance < nearestDistance) {
        nearestDistance = distance;
        nearestCard = card;
      }
    }

    return nearestCard;
  }

  CardSprite? findHighestPriorityCardSprite(Vector2 position) {
    _game = findGame() as CardBattlerGame;
    final components = _game.componentsAtPoint(position);

    // Filter to only CardSprite components
    final cardSprites = components.whereType<CardSprite>().toList();

    if (cardSprites.isEmpty) {
      return null;
    }

    var highestPriority = -1;
    final comps = cardSprites.whereType<PositionComponent>();
    for (final comp in comps) {
      if (comp.priority > highestPriority) {
        highestPriority = comp.priority;
      }
    }

    // Return the topmost card (last in the list)
    return cardSprites.lastWhere((card) => card.priority == highestPriority);
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    _game = findGame() as CardBattlerGame;

    final card = findHighestPriorityCardSprite(event.canvasPosition);
    _selectCard(card);

    print('Tap down started: ${event.toString()}');
  }

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);

    print('Drag started: ${event.toString()}');
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);

    final card = findHighestPriorityCardSprite(event.canvasStartPosition);
    _selectCard(card);

    print('Dragging at: ${event.toString()}');
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    _deselectCard();

    print('Drag ended: ${event.toString()}');
  }

  @override
  void onTapUp(TapUpEvent event) {
    super.onTapUp(event);
    _deselectCard();

    print('Tap up ended: ${event.toString()}');
  }

  void _selectCard(CardSprite? card) {
    if (card == null || card == _selectedCard) {
      return;
    }

    if (_selectedCard != null) {
      _selectedCard?.setSelected(false);
    }

    _selectedCard = card;
    _selectedCard?.setSelected(true);
  }

  void _deselectCard() {
    if (_selectedCard == null) {
      return;
    }
    _selectedCard?.setSelected(false);
    _selectedCard = null;
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint()
      ..color = const Color.fromARGB(77, 195, 4, 4); // Red with 0.3 opacity
    canvas.drawRect(size.toRect(), paint);
  }
}
