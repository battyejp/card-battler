class HealthModel {
  int currentHealth;
  final int maxHealth;

  HealthModel(this.currentHealth, this.maxHealth);

  String get display => 'HP: $currentHealth/$maxHealth';
}
