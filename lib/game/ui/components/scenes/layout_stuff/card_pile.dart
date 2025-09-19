import 'dart:math' as math;

import 'package:card_battler/game/ui/components/scenes/layout_stuff/card_sprite.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class CardPile extends PositionComponent {
  CardPile({
    required Vector2 position,
    int initialCardCount = 0,
    this.cardImagePath = 'card_face_down.png',
    this.cardScale = 1,
    this.maxVisibleCards = 4,
    this.offsetX = 4.0,
    this.offsetY = 0.0,
  }) : super(position: position) {
    cardCount = initialCardCount;
  }

  @override
  bool get debugMode => false; // Set to true to see bounding box

  int cardCount = 0;
  final String cardImagePath;
  final double cardScale;
  final int maxVisibleCards;
  final double offsetX;
  final double offsetY;

  // List to track the cards in the pile
  final List<CardSprite> _cards = [];

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Add transparent background for the pile area
    // add(
    //   RectangleComponent(
    //     size: Vector2(
    //       100 * cardScale + (maxVisibleCards * offsetX),
    //       140 * cardScale + (maxVisibleCards * offsetY),
    //     ), // Size to cover pile area
    //     paint: Paint()
    //       ..color = const Color.fromARGB(255, 5, 125, 5).withValues(alpha: 0.3),
    //     anchor: Anchor.center,
    //   ),
    // );

    await _createCardPile();
  }

  Future<void> _createCardPile() async {
    final visibleCardCount = math.min(cardCount, maxVisibleCards);

    for (var i = 0; i < visibleCardCount; i++) {
      // Calculate card position with slight offset for pile effect
      final cardX = i * offsetX;
      final cardY = -i * offsetY;

      // Create card sprite component
      final card = CardSprite(Vector2(cardX, cardY), cardImagePath)
        ..scale = Vector2.all(cardScale)
        ..anchor = Anchor.center;

      // Slight rotation for more natural pile appearance
      card.angle = (i * 0.05) - 0.1; // Small random-looking rotation

      add(card);
      _cards.add(card);
    }
  }

  /// Add a new card to the pile and redraw
  void addCard({String? imagePath}) {
    cardCount++;
    _redrawPile();
  }

  /// Remove a card from the pile and redraw
  void removeCard() {
    if (cardCount > 0) {
      cardCount--;
      _redrawPile();
    }
  }

  /// Remove all cards and redraw the pile with current cardCount
  void _redrawPile() {
    // Remove all existing cards
    for (final card in _cards) {
      remove(card);
    }
    _cards.clear();

    // Redraw the pile with new card count
    _createCardPile();
  }

  /// Get the current number of cards in the pile
  int get currentCardCount => cardCount;

  /// Check if the pile is empty
  bool get isEmpty => cardCount == 0;

  /// Check if the pile has reached maximum visible cards
  bool get isAtMaxVisibleCards => cardCount >= maxVisibleCards;
}
