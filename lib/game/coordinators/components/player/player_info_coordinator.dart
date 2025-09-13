import 'package:card_battler/game/coordinators/common/reactive_coordinator.dart';
import 'package:card_battler/game/models/player/player_model.dart';

class PlayerInfoCoordinator with ReactiveCoordinator<PlayerInfoCoordinator> {
  final PlayerModel model;

  PlayerInfoCoordinator({required this.model});

  String get name => model.name;
  int get health => model.health;
  int get maxHealth => model.maxHealth;
  int get attack => model.attack;
  int get credits => model.credits;
  bool get isActive => model.isActive;

  void adjustHealth(int amount) {
    if (model.health > model.maxHealth || model.health < 0) return;

    model.health += amount;
    notifyChange();
  }
}
