import 'package:card_battler/game/models/enemy/enemy_model.dart';

/// Pure game logic for managing a stack of enemies
/// Contains no UI dependencies - only manages state and rules
class EnemiesModel {
  final List<EnemyModel> _enemies;

  EnemiesModel({
    required int totalEnemies,
    int enemyMaxHealth = 5, //TODO pass this in
  }) : _enemies = List.generate(
          totalEnemies,
          (index) => EnemyModel(
            name: 'Enemy ${index + 1}',
            maxHealth: enemyMaxHealth
          )
        );

  /// Gets the display text for the current state
  String get displayText {
    final enemiesLeft = _enemies.length - 3 < 0 ? 0 : _enemies.length - 3; //pass 3 in
    return '$enemiesLeft enemies left';
  }

  /// Gets all enemies (including defeated ones)
  List<EnemyModel> get allEnemies => List.unmodifiable(_enemies);
}