import 'package:flame/components.dart';
import 'package:card_battler/game/game_constants.dart';


class PlayerStats extends PositionComponent {
  final String name;
  final int maxHealth;
  int _currentHealth;

  PlayerStats({required this.name, this.maxHealth = GameConstants.defaultMaxHealth}) : _currentHealth = maxHealth;

  int get currentHealth => _currentHealth;

  /// Updates current health by [delta], clamps to [0, maxHealth]
  void changeHealth(int delta) {
    _currentHealth += delta;
    if (_currentHealth > maxHealth) _currentHealth = maxHealth;
    if (_currentHealth < GameConstants.minHealth) _currentHealth = GameConstants.minHealth;
  }

  @override
  bool get debugMode => true;

  @override
  void onLoad() {
    super.onLoad();
    add(TextComponent(
      text: '$name: $_currentHealth/$maxHealth',
      position: Vector2(10, 10),
    ));
  }
}