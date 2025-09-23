import 'package:card_battler/game/coordinators/common/reactive_coordinator.dart';
import 'package:card_battler/game/models/common/actor_model.dart';

class ActorCoordinator<T extends ActorCoordinator<T>>
    with ReactiveCoordinator<T> {
  ActorCoordinator(ActorModel model) : _model = model;

  final ActorModel _model;
  ActorModel get model => _model;
  String get name => _model.name;
  int get health => _model.healthModel.currentHealth;
  String get healthDisplay => _model.healthModel.display;

  void adjustHealth(int amount) {
    final newHealth = _model.healthModel.currentHealth + amount;
    _model.healthModel.currentHealth = newHealth.clamp(
      0,
      _model.healthModel.maxHealth,
    );
    notifyChange();
  }
}
