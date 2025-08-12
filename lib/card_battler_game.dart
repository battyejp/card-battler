import 'package:flame/game.dart';
import 'game/game_world.dart';

class CardBattlerGame extends FlameGame {
  CardBattlerGame() {
    world = GameWorld();
  }
}
