import 'package:card_battler/game/models/base/base_model.dart';

// TODO very similar to EnemyCoordinator - consider refactoring to a common superclass or mixin
class BaseCoordinator {
  final BaseModel _model;

  BaseCoordinator({required BaseModel model}) : _model = model;

  String get healthDisplay => _model.display;
  int get health => _model.health;
}
