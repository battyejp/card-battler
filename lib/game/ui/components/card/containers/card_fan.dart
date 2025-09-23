import 'dart:math' as math;
import 'dart:ui';

import 'package:card_battler/game/ui/components/card/card_sprite.dart';
import 'package:flame/components.dart';

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
      final card = CardSprite(Vector2(cardX, cardY), cardImagePath)
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
