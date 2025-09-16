import 'package:card_battler/game/coordinators/components/team/base_coordinator.dart';

class BasesCoordinator {
  BasesCoordinator({required List<BaseCoordinator> baseCoordinators})
    : _baseCoordinators = baseCoordinators;
  final List<BaseCoordinator> _baseCoordinators;

  List<BaseCoordinator> get allBaseCoordinators => _baseCoordinators;

  BaseCoordinator get currentBaseCoordinator =>
      _baseCoordinators.firstWhere((base) => base.health > 0);

  int get numberOfBases => _baseCoordinators.length;

  int get currentBaseIndex =>
      _baseCoordinators.indexOf(currentBaseCoordinator) + 1;
}
