import 'package:card_battler/game/coordinators/components/cards/card_coordinator.dart';
import 'package:card_battler/game/coordinators/components/cards/card_list_coordinator.dart';
import 'package:card_battler/game/coordinators/components/common/actor_coordinator.dart';
import 'package:card_battler/game/models/player/player_model.dart';
import 'package:card_battler/game/models/shared/effect_model.dart';

class PlayerInfoCoordinator extends ActorCoordinator<PlayerInfoCoordinator> {
  PlayerInfoCoordinator(
    super.model,
    CardListCoordinator<CardCoordinator> handCardsCoordinator,
  ) : _handCardsCoordinator = handCardsCoordinator;

  final CardListCoordinator<CardCoordinator> _handCardsCoordinator;
  CardListCoordinator<CardCoordinator> get handCardsCoordinator =>
      _handCardsCoordinator;

  PlayerModel get _playerModel => model as PlayerModel;

  int get attack => _playerModel.attack;
  int get credits => _playerModel.credits;

  bool get isActive => _playerModel.isActive;
  set isActive(bool value) => _playerModel.isActive = value;

  bool hasAMaxDamageCard() =>
      _handCardsCoordinator.getCardsOfType(EffectType.maxDamage).isNotEmpty;

  int? getMinCardValue(EffectType type) =>
      handCardsCoordinator.getEffectMinValueOfType(type);

  void adjustCredits(int amount) {
    if (_playerModel.credits + amount < 0) {
      return;
    }

    _playerModel.credits += amount;
    notifyChange();
  }

  void adjustAttack(int amount) {
    if (_playerModel.attack + amount < 0) {
      return;
    }

    _playerModel.attack += amount;
    notifyChange();
  }

  void resetCreditsAndAttack() {
    _playerModel.credits = 0;
    _playerModel.attack = 0;
    notifyChange();
  }

  void abilitiesCheck() {
    notifyChange();
  }
}
