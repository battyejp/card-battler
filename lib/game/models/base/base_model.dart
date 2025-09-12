class BaseModel {
  final int _health;
  final int _maxHealth;
  final String _name;

  BaseModel({
    required String name,
    required int maxHealth,
    required int currentHealth,
  }) : _name = name,
       _health = currentHealth,
       _maxHealth = maxHealth;

  String get display => '$_health/$_maxHealth';
  int get health => _health;
  String get name => _name;
}
