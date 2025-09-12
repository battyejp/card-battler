import 'package:card_battler/game/models/enemy/enemy_model.dart';

class EnemyCoordinator {
  final EnemyModel _model;

  EnemyCoordinator({required EnemyModel model}) : _model = model;

  String get name => _model.name;
  int get health => _model.health;
  String get healthDisplay => 'HP: ${_model.health}/${_model.maxHealth}';
}
