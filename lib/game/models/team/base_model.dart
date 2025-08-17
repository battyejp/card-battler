import 'package:card_battler/game/models/shared/health_model.dart';

/// Pure game logic for a single base
/// Contains no UI dependencies - only manages state and rules
class BaseModel {
  final HealthModel _health;
  final String name;

  BaseModel({
    required this.name, 
    required int maxHealth
  }) : _health = HealthModel(maxHealth: maxHealth);

  /// Gets the health display string (e.g., "75/100")
  String get healthDisplay => _health.healthDisplay;
}