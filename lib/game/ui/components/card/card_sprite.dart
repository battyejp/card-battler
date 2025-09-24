import 'package:card_battler/game/card_battler_game.dart';
import 'package:card_battler/game/coordinators/components/cards/card_coordinator.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';

class CardSprite extends SpriteComponent {
  CardSprite(CardCoordinator cardCoordinator, bool isMini)
    : _cardCoordinator = cardCoordinator,
      _isMini = isMini,
      super(anchor: Anchor.center);

  final CardCoordinator _cardCoordinator;
  final bool _isMini;

  String get getFileName {
    if (!_cardCoordinator.isFaceUp) {
      return _cardCoordinator.type == 'Enemy'
          ? 'enemy_card_back_560.png'
          : 'card_face_down_0.08.png';
    }

    return _cardCoordinator.filename.replaceAll('size', _isMini ? '60' : '560');
  }

  CardCoordinator get coordinator => _cardCoordinator;

  @override
  void onLoad() {
    super.onLoad();

    //TODO should we pass this in the constructor?
    final game = findGame() as CardBattlerGame;
    final image = game.images.fromCache(getFileName);
    sprite = Sprite(image);

    if (!_isMini && _cardCoordinator.isFaceUp) {
      final name = _cardCoordinator.name;
      final spaceCount = name.split(' ').length - 1;

      if (spaceCount > 1) {
        final words = name.split(' ');
        final midpoint = (words.length / 2).ceil();
        final firstLine = words.take(midpoint).join(' ');
        final secondLine = words.skip(midpoint).join(' ');

        final firstTextComponent = TextComponent(
          text: firstLine,
          position: Vector2(
            image.size.x / 2,
            image.size.y - image.size.y * 0.25,
          ),
          anchor: Anchor.center,
          textRenderer: TextPaint(
            style: const TextStyle(fontSize: 32, color: Color(0xFFFFFFFF)),
          ),
        );

        final secondTextComponent = TextComponent(
          text: secondLine,
          position: Vector2(
            image.size.x / 2,
            image.size.y - image.size.y * 0.15,
          ),
          anchor: Anchor.center,
          textRenderer: TextPaint(
            style: const TextStyle(fontSize: 32, color: Color(0xFFFFFFFF)),
          ),
        );

        add(firstTextComponent);
        add(secondTextComponent);
      } else {
        final textComponent = TextComponent(
          text: name,
          position: Vector2(
            image.size.x / 2,
            image.size.y - image.size.y * 0.2,
          ),
          anchor: Anchor.center,
          textRenderer: TextPaint(
            style: const TextStyle(fontSize: 40, color: Color(0xFFFFFFFF)),
          ),
        );

        add(textComponent);
      }
    }
  }
}
