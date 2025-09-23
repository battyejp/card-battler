import 'package:flame/components.dart';
import 'package:flutter/cupertino.dart';

class CardSprite extends SpriteComponent {
  CardSprite(Vector2 position, String fileName)
    : super(position: position, anchor: Anchor.center) {
    this.fileName = fileName;
  }

  @protected
  late String fileName;

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load(fileName);
  }
}
