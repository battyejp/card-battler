import 'package:card_battler/game/models/player/player_model.dart';

class PlayerInfoCoordinator {
  final PlayerModel model;

  PlayerInfoCoordinator({required this.model});

  String get name => model.name;
  int get health => model.health;
  int get maxHealth => model.maxHealth;
  int get attack => model.attack;
  int get credits => model.credits;
  bool get isActive => model.isActive;
}
