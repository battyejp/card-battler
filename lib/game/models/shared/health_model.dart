class HealthModel {
  HealthModel(this.currentHealth, this.maxHealth);

  int currentHealth;
  final int maxHealth;

  String get display => 'HP: $currentHealth/$maxHealth';
}
