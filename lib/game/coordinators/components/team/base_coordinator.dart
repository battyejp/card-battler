import 'package:card_battler/game/models/base/base_model.dart';

class BaseCoordinator {
  final BaseModel _model;

  BaseCoordinator({required BaseModel model}) : _model = model;

  String get healthDisplay => _model.display;
}
