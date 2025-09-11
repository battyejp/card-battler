import 'package:card_battler/game/models/player/player_model.dart';

class PlayerStatsCoordinator {
  final PlayerModel _player;

  PlayerStatsCoordinator({required PlayerModel player}) : _player = player;

  int get health => _player.health;
  int get maxHealth => _player.maxHealth;
  String get name => _player.name;
  bool get isActive => _player.isActive;
}