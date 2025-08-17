import 'package:card_battler/game/game_constants.dart';

class HealthModel {
  final int maxHealth;
  int _currentHealth;

  HealthModel({this.maxHealth = GameConstants.defaultPlayerMaxHealth}) 
      : _currentHealth = maxHealth;

  int get currentHealth => _currentHealth;

  /// Updates current health by [delta], clamps to [0, maxHealth]
  void changeHealth(int delta) {
    _currentHealth += delta;
    if (_currentHealth > maxHealth) _currentHealth = maxHealth;
    if (_currentHealth < GameConstants.minHealth) _currentHealth = GameConstants.minHealth;
  }

  /// Returns a formatted string representation of current health status
  String get healthDisplay => '$_currentHealth/$maxHealth';
}