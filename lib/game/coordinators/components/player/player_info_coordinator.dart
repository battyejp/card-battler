import 'package:card_battler/game/coordinators/common/reactive_coordinator.dart';
import 'package:card_battler/game/models/player/player_model.dart';

//TODO extend the ActorCoordinator instead of duplicating code
class PlayerInfoCoordinator with ReactiveCoordinator<PlayerInfoCoordinator> {
  final PlayerModel _model;

  PlayerInfoCoordinator({required PlayerModel model}) : _model = model;

  String get name => _model.name;
  String get healthDisplay => _model.healthModel.display;
  int get attack => _model.attack;
  int get credits => _model.credits;

  bool get isActive => _model.isActive;
  set isActive(bool value) => _model.isActive = value;

  void adjustHealth(int amount) {
    if (_model.healthModel.currentHealth > _model.healthModel.maxHealth ||
        _model.healthModel.currentHealth < 0) {
      return;
    }

    _model.healthModel.currentHealth += amount;
    notifyChange();
  }

  void adjustCredits(int amount) {
    if (_model.credits + amount < 0) return;

    _model.credits += amount;
    notifyChange();
  }

  void resetCreditsAndAttack() {
    _model.credits = 0;
    _model.attack = 0;
    notifyChange();
  }
}
