import 'package:card_battler/game/models/common/reactive_model.dart';

class HealthModel with ReactiveModel<HealthModel> {
  final int maxHealth;
  int _currentHealth;

  HealthModel({required this.maxHealth}) 
      : _currentHealth = maxHealth;

  int get currentHealth => _currentHealth;

  /// Updates current health by [delta], clamps to [0, maxHealth]
  void changeHealth(int delta) {
    _currentHealth += delta;
    if (_currentHealth > maxHealth) _currentHealth = maxHealth;
    if (_currentHealth < 0) _currentHealth = 0;
    notifyChange();
  }

  /// Returns a formatted string representation of current health status
  String get healthDisplay => '$_currentHealth/$maxHealth';
}