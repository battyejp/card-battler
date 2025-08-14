import 'package:card_battler/game/models/health_model.dart';

class EnemyModel {
  final HealthModel _health;
  final String name;

  EnemyModel({
    required this.name,
    required int maxHealth
  }) : _health = HealthModel(maxHealth: maxHealth);

  /// Gets the health display string (e.g., "75/100")
  String get healthDisplay => _health.healthDisplay;
}