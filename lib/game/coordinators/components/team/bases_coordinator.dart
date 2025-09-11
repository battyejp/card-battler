import 'package:card_battler/game/coordinators/components/team/base_coordinator.dart';

class BasesCoordinator {
  final List<BaseCoordinator> _coordinators;

  BasesCoordinator({required List<BaseCoordinator> coordinators})
    : _coordinators = coordinators;

  List<BaseCoordinator> get allCoordinators => _coordinators;
}
