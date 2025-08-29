import 'package:card_battler/game/models/shared/health_model.dart';

class PlayerStatsModel {
  final HealthModel _health;
  final String _name;
  final bool isActive;

  PlayerStatsModel({required String name, required HealthModel health, this.isActive = false})
      : _name = name,
        _health = health;

  String get name => _name;
  HealthModel get health => _health;
}