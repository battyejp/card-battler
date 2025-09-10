import 'package:card_battler/game/models/enemy/enemy_model.dart';
import 'package:card_battler/game/models/shared/card_model.dart';

class EnemiesModel {
  final List<EnemyModel> _enemies;
  final int _maxNumberOfEnemiesInPlay;

  EnemiesModel({
    required int totalEnemies,
    required int maxNumberOfEnemiesInPlay,
    required int maxEnemyHealth,
    required List<CardModel> enemyCards,
  }) : _maxNumberOfEnemiesInPlay = maxNumberOfEnemiesInPlay,
      _enemies = List.generate(
         totalEnemies,
         (index) =>
             EnemyModel(name: 'Enemy ${index + 1}', maxHealth: maxEnemyHealth),
       );

  /// Gets the display text for the current state
  String get displayText {
    final enemiesLeft = _enemies.length - 3 < 0
        ? 0
        : _enemies.length - 3; //pass 3 in
    return '$enemiesLeft enemies left';
  }

  /// Gets all enemies (including defeated ones)
  List<EnemyModel> get allEnemies => List.unmodifiable(_enemies);
  int get maxNumberOfEnemiesInPlay => _maxNumberOfEnemiesInPlay;
}
