import 'dart:async' as dart_async;
import 'package:card_battler/game/components/enemy/enemies.dart';
import 'package:card_battler/game/components/ui/shop.dart';
import 'package:card_battler/game/components/ui/game_announcement.dart';
import 'package:card_battler/game/components/team/team.dart';
import 'package:card_battler/game/models/enemy/enemies_model.dart';
import 'package:card_battler/game/models/ui/shop_model.dart';
import 'package:card_battler/game/models/player/info_model.dart';
import 'package:card_battler/game/models/shared/value_image_label_model.dart';
import 'package:flame/game.dart';
import 'components/player/player.dart';

class CardBattlerGame extends FlameGame {
  CardBattlerGame();
  Vector2? _testSize;

  // Test-only constructor to set size before onLoad
  CardBattlerGame.withSize(Vector2 testSize) : _testSize = testSize;

  static const double margin = 20.0;
  static const double topLayoutHeightFactor = 0.6;
  
  // Shared game state models
  late EnemiesModel _enemiesModel;
  late InfoModel _playerInfoModel;

  @override
  onLoad() {
    if (_testSize != null) {
      onGameResize(_testSize!);
    }
    
    // Load all game components first
    _loadGameComponents();
    
    // Show "Enemies Go" announcement at game start
    _showEnemiesGoAnnouncement();
  }
  
  void _loadGameComponents() {
    final availableHeight = size.y - (margin * 2);
    final availableWidth = size.x - (margin * 2);
    final topLayoutHeight = availableHeight * topLayoutHeightFactor;
    final bottomLayoutHeight = availableHeight - topLayoutHeight;
    final topPositionY = -1 * (size.y / 2) + margin;

    // Initialize shared models
    _enemiesModel = EnemiesModel(totalEnemies: 4, enemyMaxHealth: 5);
    _playerInfoModel = InfoModel(
      health: ValueImageLabelModel(value: 100, label: 'Health'),
      attack: ValueImageLabelModel(value: 10, label: 'Attack'),
      credits: ValueImageLabelModel(value: 50, label: 'Credits'),
    );

    final player = Player()
      ..size = Vector2(availableWidth, bottomLayoutHeight)
      ..position = Vector2((0 - size.x / 2) + margin, (size.y / 2) - margin - bottomLayoutHeight);

    world.add(player);

    final enemiesWidth = availableWidth * 0.5;
    final enemies = Enemies(model: _enemiesModel)
      ..size = Vector2(enemiesWidth, topLayoutHeight)
      ..position = Vector2((0 - enemiesWidth / 2), topPositionY);

    world.add(enemies);

    final shopWidth = availableWidth * 0.5 / 2;
    final shop = Shop(ShopModel())
      ..size = Vector2(shopWidth, topLayoutHeight)
      ..position = Vector2(enemies.position.x + enemiesWidth, topPositionY);

    world.add(shop);

    final team = Team(names: ['Player 2', 'Player 3', 'Player 4'])
      ..size = Vector2(shopWidth, topLayoutHeight)
      ..position = Vector2(0 - enemiesWidth / 2 - shopWidth, topPositionY);

    world.add(team);
  }
  
  void _showEnemiesGoAnnouncement() {
    // Show announcement with current enemy state
    final announcement = EnemyStatusAnnouncement(
      enemiesModel: _enemiesModel,
      displayDuration: const Duration(seconds: 5),
      onComplete: () {
        print('Enemy status announcement completed - game can now start');
        // Show player info after 1 second
        dart_async.Timer(const Duration(seconds: 1), () {
          _showPlayerInfoAnnouncement();
        });
      },
    );
    
    // Add to the camera's viewport (not world) so it appears as an overlay
    camera.viewport.add(announcement);
  }
  
  void _showPlayerInfoAnnouncement() {
    final announcement = PlayerInfoAnnouncement(
      playerInfo: _playerInfoModel,
      title: 'Player Status',
      displayDuration: const Duration(seconds: 3),
      onComplete: () {
        print('Player info shown - ready for action!');
        // Game can now start properly
      },
    );
    
    camera.viewport.add(announcement);
  }
  
  // Method to show dynamic health updates
  void showHealthUpdateAnnouncement() {
    final announcement = ReactiveGameAnnouncement(
      labelModel: _playerInfoModel.health,
      title: 'Health Update',
      displayDuration: const Duration(seconds: 2),
    );
    
    camera.viewport.add(announcement);
  }
  
  // Method to show attack boost
  void showAttackBoostAnnouncement() {
    final announcement = ReactiveGameAnnouncement(
      labelModel: _playerInfoModel.attack,
      title: 'Attack Boost!',
      displayDuration: const Duration(seconds: 2),
    );
    
    camera.viewport.add(announcement);
  }
  
  // Method to show credits earned
  void showCreditsEarnedAnnouncement() {
    final announcement = ReactiveGameAnnouncement(
      labelModel: _playerInfoModel.credits,
      title: 'Credits Earned',
      displayDuration: const Duration(seconds: 2),
    );
    
    camera.viewport.add(announcement);
  }
  
  // Public methods to update shared state (these could be called from other components)
  void updatePlayerHealth(int delta) {
    _playerInfoModel.health.changeValue(delta);
    _playerInfoModel.health.notifyChange();
  }
  
  void updatePlayerAttack(int delta) {
    _playerInfoModel.attack.changeValue(delta);
    _playerInfoModel.attack.notifyChange();
  }
  
  void updatePlayerCredits(int delta) {
    _playerInfoModel.credits.changeValue(delta);
    _playerInfoModel.credits.notifyChange();
  }
  
  // Get current game state for other components
  EnemiesModel get enemiesModel => _enemiesModel;
  InfoModel get playerInfoModel => _playerInfoModel;
}
