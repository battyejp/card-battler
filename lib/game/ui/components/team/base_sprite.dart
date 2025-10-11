import 'package:flame/components.dart';
import 'package:flame/flame.dart';

class BaseSprite extends SpriteComponent {
  BaseSprite();

  @override
  Future<void> onLoad() async {
    super.onLoad();

    const filename = 'base_wall.png';
    final image = Flame.images.containsKey(filename)
        ? Flame.images.fromCache(filename)
        : await Flame.images.load(filename);

    sprite = Sprite(image);
  }
}
