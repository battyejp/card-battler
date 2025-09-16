import 'package:card_battler/game/coordinators/common/reactive_coordinator.dart';
import 'package:card_battler/game/models/common/actor_model.dart';

class ActorCoordinator<T extends ActorCoordinator<T>>
    with ReactiveCoordinator<T> {
  ActorCoordinator({required ActorModel model}) : _model = model;

  final ActorModel _model;
  ActorModel get model => _model;
  String get name => _model.name;
  int get health => _model.healthModel.currentHealth;
  String get healthDisplay => _model.healthModel.display;

  void adjustHealth(int amount) {
    if (_model.healthModel.currentHealth > _model.healthModel.maxHealth ||
        _model.healthModel.currentHealth < 0) {
      return;
    }

    _model.healthModel.currentHealth += amount;
    notifyChange();
  }
}
