import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'components/player.dart';

class CardBattlerGame extends FlameGame {
  static const double margin = 20.0;

  @override
  onLoad() {
    //Set camera viewfinder properties
    camera.viewfinder.visibleGameSize = size;
    camera.viewfinder.position = Vector2.zero();
    camera.viewfinder.anchor = Anchor.topCenter;
    
    // Create player that takes up bottom third of screen with margins
    final availableHeight = size.y - (margin * 2);
    final availableWidth = size.x - (margin * 2);
    final playerHeight = availableHeight / 3;
    final player = Player()
      ..size = Vector2(availableWidth, playerHeight)
      ..position = Vector2((0 - size.x / 2) + margin, size.y - playerHeight - margin);

    world.add(player);
  }
}
