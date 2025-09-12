//TODO appears to be very similar to BaseModel - consider refactoring to a common superclass or mixin
class EnemyModel {
  final int _health;
  final int _maxHealth;
  final String _name;

  EnemyModel({
    required String name,
    required int maxHealth,
    required int currentHealth,
  }) : _name = name,
       _health = currentHealth,
       _maxHealth = maxHealth;

  int get health => _health;
  String get name => _name;
  int get maxHealth => _maxHealth;
}