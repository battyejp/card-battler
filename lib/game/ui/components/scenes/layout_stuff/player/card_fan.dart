import 'dart:math' as math;

import 'package:card_battler/game/ui/components/scenes/layout_stuff/player/card_sprite.dart';
import 'package:flame/components.dart';

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

    // Add transparent background for the fan area
    // add(
    //   RectangleComponent(
    //     size: Vector2(
    //       fanRadius * 2.5,
    //       fanRadius * 1.2,
    //     ), // Size to cover fan area
    //     paint: Paint()
    //       ..color = const Color.fromARGB(255, 125, 5, 5).withValues(alpha: 0.3),
    //     anchor: Anchor.center,
    //   ),
    // );

    await _createCardFan();
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
      final card = CardSprite(Vector2(cardX, cardY), cardImagePath)
        ..scale = Vector2.all(cardScale)
        ..anchor = Anchor.center;

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
