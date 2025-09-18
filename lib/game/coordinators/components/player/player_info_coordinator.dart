import 'package:card_battler/game/coordinators/components/common/actor_coordinator.dart';
import 'package:card_battler/game/models/player/player_model.dart';

class PlayerInfoCoordinator extends ActorCoordinator<PlayerInfoCoordinator> {
  PlayerInfoCoordinator({required PlayerModel model}) : super(model: model);
  PlayerModel get _playerModel => model as PlayerModel;

  int get attack => _playerModel.attack;
  int get credits => _playerModel.credits;

  bool get isActive => _playerModel.isActive;
  set isActive(bool value) => _playerModel.isActive = value;

  void adjustCredits(int amount) {
    if (_playerModel.credits + amount < 0) {
      return;
    }

    _playerModel.credits += amount;
    notifyChange();
  }

  void adjustAttack(int amount) {
    if (_playerModel.attack + amount < 0) {
      return;
    }

    _playerModel.attack += amount;
    notifyChange();
  }

  void resetCreditsAndAttack() {
    _playerModel.credits = 0;
    _playerModel.attack = 0;
    notifyChange();
  }
}
