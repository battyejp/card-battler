import 'package:card_battler/game_legacy/models/player/player_info.dart';

class PlayerInfoCoordinator {
  final PlayerInfoModel model;

  PlayerInfoCoordinator({required this.model});

  String get name => model.name;
  int get health => model.currentHealth;
  int get maxHealth => model.maxHealth;
  int get attack => model.attack;
  int get credits => model.credits;
}