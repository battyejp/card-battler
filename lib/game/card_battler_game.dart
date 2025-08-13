import 'package:card_battler/game/components/enemies.dart';
import 'package:card_battler/game/components/shop.dart';
import 'package:card_battler/game/components/team.dart';
import 'package:flame/game.dart';
import 'components/player.dart';

class CardBattlerGame extends FlameGame {
  static const double margin = 20.0;
  static const double topLayoutHeightFactor = 0.6;

  @override
  onLoad() { 
    final availableHeight = size.y - (margin * 2);
    final availableWidth = size.x - (margin * 2);
    final topLayoutHeight = availableHeight * topLayoutHeightFactor;
    final bottomLayoutHeight = availableHeight - topLayoutHeight;
    final topPositionY = -1 * (size.y / 2) + margin;

    final player = Player()
      ..size = Vector2(availableWidth, bottomLayoutHeight)
      ..position = Vector2((0 - size.x / 2) + margin, (size.y / 2) - margin - bottomLayoutHeight);

    world.add(player);

    final enemiesWidth = availableWidth * 0.5;
    final enemies = Enemies()
      ..size = Vector2(enemiesWidth, topLayoutHeight)
      ..position = Vector2((0 - enemiesWidth / 2), topPositionY);

    world.add(enemies);

    final shopWidth = availableWidth * 0.5 / 2;
    final shop = Shop()
      ..size = Vector2(shopWidth, topLayoutHeight)
      ..position = Vector2(enemies.position.x + enemiesWidth, topPositionY);

    world.add(shop);

    final team = Team()
      ..size = Vector2(shopWidth, topLayoutHeight)
      ..position = Vector2(0 - enemiesWidth / 2 - shopWidth, topPositionY);

    world.add(team);    
  }
}
