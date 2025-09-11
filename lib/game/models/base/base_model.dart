class BaseModel {
  final int _health;
  final int _maxHealth;
  final String _name;

  BaseModel({
    required String name, 
    required int maxHealth,
    required int currentHealth,
  })  : _name = name,
        _health = currentHealth,
        _maxHealth = maxHealth;

  /// Gets the health display string (e.g., "75/100")
  String get display => '$_name: $_health/$_maxHealth';
}
