import 'package:card_battler/game/components/enemy/enemies.dart';
import 'package:card_battler/game/components/ui/shop.dart';
import 'package:card_battler/game/components/team/team.dart';
import 'package:card_battler/game/models/enemy/enemies_model.dart';
import 'package:flame/game.dart';
import 'components/player/player.dart';

class CardBattlerGame extends FlameGame {
  CardBattlerGame();
  Vector2? _testSize;

  // Test-only constructor to set size before onLoad
  CardBattlerGame.withSize(Vector2 testSize) : _testSize = testSize;

  static const double margin = 20.0;
  static const double topLayoutHeightFactor = 0.6;

  @override
  onLoad() {
    if (_testSize != null) {
      onGameResize(_testSize!);
    }
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
    final enemiesModel = EnemiesModel(totalEnemies: 4, enemyMaxHealth: 5);
    final enemies = Enemies(model: enemiesModel)
      ..size = Vector2(enemiesWidth, topLayoutHeight)
      ..position = Vector2((0 - enemiesWidth / 2), topPositionY);

    world.add(enemies);

    final shopWidth = availableWidth * 0.5 / 2;
    final shop = Shop()
      ..size = Vector2(shopWidth, topLayoutHeight)
      ..position = Vector2(enemies.position.x + enemiesWidth, topPositionY);

    world.add(shop);

    final team = Team(names: ['Player 2', 'Player 3', 'Player 4'])
      ..size = Vector2(shopWidth, topLayoutHeight)
      ..position = Vector2(0 - enemiesWidth / 2 - shopWidth, topPositionY);

    world.add(team);    
  }
}
