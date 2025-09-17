import 'package:card_battler/game/coordinators/components/common/actor_coordinator.dart';
import 'package:card_battler/game/models/enemy/enemy_model.dart';

class EnemyCoordinator extends ActorCoordinator<EnemyCoordinator> {
  EnemyCoordinator({required EnemyModel model}) : super(model: model);
}
