import 'package:card_battler/game/coordinators/components/cards/cards_coordinator.dart';
import 'package:card_battler/game/models/player/player_model.dart';

class PlayerCoordinator {
  final PlayerModel _playerModel;
  final CardsCoordinator _handCardsCoordinator;
  final CardsCoordinator _deckCardsCoordinator;
  final CardsCoordinator _discardCardsCoordinator;

  PlayerCoordinator({required PlayerModel playerModel, required CardsCoordinator handCardsCoordinator, required CardsCoordinator deckCardsCoordinator, required CardsCoordinator discardCardsCoordinator})
      : _playerModel = playerModel,
        _handCardsCoordinator = handCardsCoordinator,
        _deckCardsCoordinator = deckCardsCoordinator,
        _discardCardsCoordinator = discardCardsCoordinator;

  CardsCoordinator get handCardsCoordinator => _handCardsCoordinator;
  CardsCoordinator get deckCardsCoordinator => _deckCardsCoordinator;
  CardsCoordinator get discardCardsCoordinator => _discardCardsCoordinator;
  int get attack => _playerModel.attack;
  int get credits => _playerModel.credits;
  int get health => _playerModel.health;
  bool get isActive => _playerModel.isActive;
}
  