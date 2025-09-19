import 'package:flame/components.dart';

class CardSprite extends SpriteComponent {
  CardSprite(Vector2 position, String fileName)
    : super(
        position: position,
        anchor: Anchor.center,
      ) {
    _fileName = fileName;
  }

  late String _fileName;

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load(_fileName);
  }
}
