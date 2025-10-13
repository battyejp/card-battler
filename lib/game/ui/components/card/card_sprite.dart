import 'package:card_battler/game/coordinators/components/cards/card_coordinator.dart';
import 'package:card_battler/game/models/card/card_model.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
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
      return _cardCoordinator.type == CardType.enemy
          ? 'cards/dark/enemy_card_back_560.png'
          : 'cards/light/card_face_down_0.08.png';
    }

    final filename = _cardCoordinator.filename.replaceAll(
      'size',
      _isMini ? '60' : '560',
    );

    return filename;
  }

  CardCoordinator get coordinator => _cardCoordinator;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    final image = Flame.images.containsKey(getFileName)
        ? Flame.images.fromCache(getFileName)
        : await Flame.images.load(getFileName);

    sprite = Sprite(image);
  }

  @override
  void onMount() {
    super.onMount();
    final imageSize = sprite!.image.size;

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
          position: Vector2(imageSize.x / 2, imageSize.y - imageSize.y * 0.25),
          anchor: Anchor.center,
          textRenderer: TextPaint(
            style: const TextStyle(fontSize: 32, color: Color(0xFFFFFFFF)),
          ),
        );

        final secondTextComponent = TextComponent(
          text: secondLine,
          position: Vector2(imageSize.x / 2, imageSize.y - imageSize.y * 0.15),
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
          position: Vector2(imageSize.x / 2, imageSize.y - imageSize.y * 0.2),
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
