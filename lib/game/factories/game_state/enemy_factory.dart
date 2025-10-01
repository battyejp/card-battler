import 'package:card_battler/game/config/game_configuration.dart';
import 'package:card_battler/game/models/card/card_list_model.dart';
import 'package:card_battler/game/models/card/card_model.dart';
import 'package:card_battler/game/models/enemy/enemies_model.dart';
import 'package:card_battler/game/models/enemy/enemy_model.dart';
import 'package:card_battler/game/models/shared/health_model.dart';

/// Factory class responsible for creating enemy-related instances
/// Separates enemy creation logic from GameStateModel
class EnemyFactory {
  /// Creates an EnemiesModel containing all enemies and their shared deck
  /// 
  /// [count] - Number of individual enemies to create
  /// [enemyCards] - Card list for the enemies' shared deck
  /// [config] - Game configuration containing health and other settings
  static EnemiesModel createEnemiesModel({
    required int count,
    required List<CardModel> enemyCards,
    required GameConfiguration config,
  }) {
    final enemies = createEnemies(count: count, config: config);
    
    return EnemiesModel(
      enemies: enemies,
      deckCards: CardListModel<CardModel>(cards: enemyCards),
      playedCards: CardListModel<CardModel>.empty(),
    );
  }

  /// Creates a list of enemy instances
  /// 
  /// [count] - Number of enemies to create
  /// [config] - Game configuration containing health and other settings
  static List<EnemyModel> createEnemies({
    required int count,
    required GameConfiguration config,
  }) =>
      List<EnemyModel>.generate(
        count,
        (index) => createEnemy(index: index, config: config),
      );

  /// Creates a single enemy instance
  /// 
  /// [index] - Enemy index (0-based), used for naming
  /// [config] - Game configuration containing health and other settings
  static EnemyModel createEnemy({
    required int index,
    required GameConfiguration config,
  }) =>
      EnemyModel(
        name: 'Enemy ${index + 1}',
        healthModel: HealthModel(config.defaultHealth, config.defaultHealth),
      );
}
