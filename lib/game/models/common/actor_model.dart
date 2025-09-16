import 'package:card_battler/game/models/shared/health_model.dart';

class ActorModel {
  final String _name;
  final HealthModel _healthModel;

  ActorModel({required String name, required HealthModel healthModel})
    : _name = name,
      _healthModel = healthModel;

  String get name => _name;
  HealthModel get healthModel => _healthModel;
}
