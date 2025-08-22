import 'package:card_battler/game/models/shared/health_model.dart';

class PlayerStatsModel {
  final HealthModel _health;
  final String _name;

  PlayerStatsModel({required String name, required HealthModel health})
      : _name = name,
        _health = health;

  String get display => '$_name: ${_health.healthDisplay}';
  HealthModel get health => _health;
}