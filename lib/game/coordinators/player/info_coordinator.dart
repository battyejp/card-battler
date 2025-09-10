import 'package:card_battler/game/models/player/info_model.dart';

//TODO legacy InfoCoordinator class for player information
class InfoCoordinator {
  final InfoModel infoModel;

  InfoCoordinator({required this.infoModel});

  String get name => infoModel.name;
  // int get health => infoModel.health;
  // int get attack => infoModel.attack;
  // int get credits => infoModel.credits;
}