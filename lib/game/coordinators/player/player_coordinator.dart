import 'package:card_battler/game/coordinators/components/cards/cards_coordinator.dart';
import 'package:card_battler/game/coordinators/player/player_info_coordinator.dart';
import 'package:card_battler/game/models/player/player_model.dart';

class PlayerCoordinator {
  final PlayerModel _playerModel;
  final CardsCoordinator _handCardsCoordinator;
  final CardsCoordinator _deckCardsCoordinator;
  final CardsCoordinator _discardCardsCoordinator;
  final PlayerInfoCoordinator _playerInfoCoordinator;

  PlayerCoordinator({
    required PlayerModel playerModel,
    required CardsCoordinator handCardsCoordinator,
    required CardsCoordinator deckCardsCoordinator,
    required CardsCoordinator discardCardsCoordinator,
    required PlayerInfoCoordinator playerInfoCoordinator,
  })  : _playerModel = playerModel,
       _handCardsCoordinator = handCardsCoordinator,
       _deckCardsCoordinator = deckCardsCoordinator,
       _playerInfoCoordinator = playerInfoCoordinator,
       _discardCardsCoordinator = discardCardsCoordinator;

  CardsCoordinator get handCardsCoordinator => _handCardsCoordinator;
  CardsCoordinator get deckCardsCoordinator => _deckCardsCoordinator;
  CardsCoordinator get discardCardsCoordinator => _discardCardsCoordinator;
  PlayerInfoCoordinator get playerInfoCoordinator => _playerInfoCoordinator;

  int get attack => _playerModel.attack;
  int get credits => _playerModel.credits;
  int get health => _playerModel.health;
  bool get isActive => _playerModel.isActive;
}
