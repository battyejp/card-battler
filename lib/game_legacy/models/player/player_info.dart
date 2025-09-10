class PlayerInfoModel {
  final int attack;
  final int credits;
  final int currentHealth;
  final int maxHealth;
  final String name;

  PlayerInfoModel({
    required this.attack,
    required this.credits,
    required this.name,
    required this.currentHealth,
    required this.maxHealth,
  });
}