import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'components/player.dart';

class CardBattlerGame extends FlameGame {
  @override
  Future<void> onLoad() async {
    //Set camera viewfinder properties
    camera.viewfinder.visibleGameSize = size;
    camera.viewfinder.position = Vector2.zero();
    camera.viewfinder.anchor = Anchor.topCenter;
    
    // Create player that takes up bottom third of screen
    final playerHeight = size.y / 3;
    final player = Player()
      ..size = Vector2(size.x, playerHeight)
      ..position = Vector2(0 - size.x / 2, size.y - playerHeight);
    
    world.add(player);
  }
}
