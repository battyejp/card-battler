import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Layout extends Component {
  Layout({required Vector2 size}) : _size = size;

  final Vector2 _size;

  // Card dimensions
  static const double mainCardWidth = 60.0;
  static const double mainCardHeight = 84.0;
  static const double smallCardWidth = 40.0;
  static const double smallCardHeight = 56.0;

  // Layout margins
  static const double margin = 20.0;
  static const double cardSpacing = 10.0;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    await _createLayout();
  }

  Future<void> _createLayout() async {
    // Create main player area (bottom)
    await _createMainPlayerArea();

    // Create other player areas
    _createPlayer2Area(); // Top
    _createPlayer3Area(); // Left
    _createPlayer4Area(); // Right
    _createPlayer5Area(); // Top-right corner
  }

  Future<void> _createMainPlayerArea() async {
    final bottomY = _size.y - mainCardHeight - margin;

    // Main player deck (bottom left)
    await _createCardPile(
      position: Vector2(margin, bottomY),
      cardWidth: mainCardWidth,
      cardHeight: mainCardHeight,
      cardCount: 1, // Just show the deck
      label: "Deck",
      isMainPlayer: true,
    );

    // Main player hand (bottom center) - 5 cards spread out
    final handStartX = (_size.x - (5 * mainCardWidth + 4 * cardSpacing)) / 2;
    for (int i = 0; i < 5; i++) {
      await _createCard(
        position: Vector2(
          handStartX + i * (mainCardWidth + cardSpacing),
          bottomY,
        ),
        cardWidth: mainCardWidth,
        cardHeight: mainCardHeight,
        isFaceUp: true,
      );
    }

    // Main player discard pile (bottom right)
    await _createCardPile(
      position: Vector2(_size.x - mainCardWidth - margin, bottomY),
      cardWidth: mainCardWidth,
      cardHeight: mainCardHeight,
      cardCount: 1,
      label: "Discard",
      isMainPlayer: true,
    );
  }

  void _createPlayer2Area() {
    // Player 2 at top of screen
    final topY = margin;
    final centerX = (_size.x - (3 * smallCardWidth + 2 * cardSpacing)) / 2;

    // Player 2 deck
    _createCardPile(
      position: Vector2(centerX - smallCardWidth - cardSpacing, topY),
      cardWidth: smallCardWidth,
      cardHeight: smallCardHeight,
      cardCount: 1,
      label: "P2 Deck",
      isMainPlayer: false,
    );

    // Player 2 hand (3 cards)
    for (int i = 0; i < 3; i++) {
      _createCard(
        position: Vector2(centerX + i * (smallCardWidth + cardSpacing), topY),
        cardWidth: smallCardWidth,
        cardHeight: smallCardHeight,
        isFaceUp: false,
      );
    }
  }

  void _createPlayer3Area() {
    // Player 3 on left side
    final leftX = margin;
    final centerY = (_size.y - (3 * smallCardHeight + 2 * cardSpacing)) / 2;

    // Player 3 deck
    _createCardPile(
      position: Vector2(leftX, centerY - smallCardHeight - cardSpacing),
      cardWidth: smallCardWidth,
      cardHeight: smallCardHeight,
      cardCount: 1,
      label: "P3 Deck",
      isMainPlayer: false,
    );

    // Player 3 hand (3 cards vertical)
    for (int i = 0; i < 3; i++) {
      _createCard(
        position: Vector2(leftX, centerY + i * (smallCardHeight + cardSpacing)),
        cardWidth: smallCardWidth,
        cardHeight: smallCardHeight,
        isFaceUp: false,
      );
    }
  }

  void _createPlayer4Area() {
    // Player 4 on right side
    final rightX = _size.x - smallCardWidth - margin;
    final centerY = (_size.y - (3 * smallCardHeight + 2 * cardSpacing)) / 2;

    // Player 4 deck
    _createCardPile(
      position: Vector2(rightX, centerY - smallCardHeight - cardSpacing),
      cardWidth: smallCardWidth,
      cardHeight: smallCardHeight,
      cardCount: 1,
      label: "P4 Deck",
      isMainPlayer: false,
    );

    // Player 4 hand (3 cards vertical)
    for (int i = 0; i < 3; i++) {
      _createCard(
        position: Vector2(
          rightX,
          centerY + i * (smallCardHeight + cardSpacing),
        ),
        cardWidth: smallCardWidth,
        cardHeight: smallCardHeight,
        isFaceUp: false,
      );
    }
  }

  void _createPlayer5Area() {
    // Player 5 in top-right corner
    final topRightX = _size.x - (3 * smallCardWidth + 2 * cardSpacing) - margin;
    final topY = margin;

    // Player 5 deck
    _createCardPile(
      position: Vector2(topRightX - smallCardWidth - cardSpacing, topY),
      cardWidth: smallCardWidth,
      cardHeight: smallCardHeight,
      cardCount: 1,
      label: "P5 Deck",
      isMainPlayer: false,
    );

    // Player 5 hand (3 cards)
    for (int i = 0; i < 3; i++) {
      _createCard(
        position: Vector2(topRightX + i * (smallCardWidth + cardSpacing), topY),
        cardWidth: smallCardWidth,
        cardHeight: smallCardHeight,
        isFaceUp: false,
      );
    }
  }

  Future<void> _createCard({
    required Vector2 position,
    required double cardWidth,
    required double cardHeight,
    required bool isFaceUp,
  }) async {
    final cardSprite = SpriteComponent(
      sprite: await Sprite.load(
        isFaceUp ? 'card_face_up.png' : 'card_face_down.png',
      ),
      size: Vector2(cardWidth, cardHeight),
      position: position,
    );
    add(cardSprite);
  }

  Future<void> _createCardPile({
    required Vector2 position,
    required double cardWidth,
    required double cardHeight,
    required int cardCount,
    required String label,
    required bool isMainPlayer,
  }) async {
    // Create the card pile (just one card for now)
    await _createCard(
      position: position,
      cardWidth: cardWidth,
      cardHeight: cardHeight,
      isFaceUp: false,
    );

    // Add label
    final labelText = TextComponent(
      text: label,
      position: Vector2(
        position.x + cardWidth / 2,
        position.y + cardHeight + 5,
      ),
      anchor: Anchor.topCenter,
      textRenderer: TextPaint(
        style: TextStyle(
          color: Colors.white,
          fontSize: isMainPlayer ? 12 : 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    add(labelText);
  }
}
