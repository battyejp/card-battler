import 'package:card_battler/game/game_constants.dart';

class PlayerStatsModel {
  final String name;
  final int maxHealth;
  int _currentHealth;

  PlayerStatsModel({required this.name, this.maxHealth = GameConstants.defaultMaxHealth}) 
      : _currentHealth = maxHealth;

  int get currentHealth => _currentHealth;

  /// Updates current health by [delta], clamps to [0, maxHealth]
  void changeHealth(int delta) {
    _currentHealth += delta;
    if (_currentHealth > maxHealth) _currentHealth = maxHealth;
    if (_currentHealth < GameConstants.minHealth) _currentHealth = GameConstants.minHealth;
  }

  /// Returns a formatted string representation of current health status
  String get healthDisplay => '$name: $_currentHealth/$maxHealth';
}