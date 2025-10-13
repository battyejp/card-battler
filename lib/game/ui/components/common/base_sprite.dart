import 'package:flame/components.dart';
import 'package:flame/flame.dart';

class BaseSprite extends SpriteComponent {
  BaseSprite(String filename)
    : assert(filename.isNotEmpty, 'Filename must not be empty'),
      _filename = filename;

  final String _filename;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    final image = Flame.images.containsKey(_filename)
        ? Flame.images.fromCache(_filename)
        : await Flame.images.load(_filename);

    sprite = Sprite(image);
  }
}
