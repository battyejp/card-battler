import 'package:card_battler/game_legacy/models/shared/health_model.dart';
import 'package:card_battler/game_legacy/models/shared/reactive_model.dart';

class PlayerStatsModel with ReactiveModel<PlayerStatsModel> {
  final HealthModel _health;
  final String _name;
  late bool _isActive;

  PlayerStatsModel({required String name, required HealthModel health, required bool isActive})
      : _name = name,
        _health = health,
        _isActive = isActive;

  String get name => _name;
  HealthModel get health => _health;
  bool get isActive => _isActive;

  set isActive(bool isActive) {
    _isActive = isActive;
    notifyChange();
  }
}