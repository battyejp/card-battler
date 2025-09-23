import 'package:card_battler/game/coordinators/components/common/actor_coordinator.dart';
import 'package:card_battler/game/models/base/base_model.dart';

class BaseCoordinator extends ActorCoordinator<BaseCoordinator> {
  BaseCoordinator({required BaseModel model}) : super(model);
}
