import 'package:card_battler/game/coordinators/components/cards/card_coordinator.dart';
import 'package:card_battler/game/coordinators/components/cards/card_list_coordinator.dart';
import 'package:card_battler/game/coordinators/components/player/player_info_coordinator.dart';

class TeamMateCoordinator {
  TeamMateCoordinator(
    PlayerInfoCoordinator playerInfoCoordinator,
    CardListCoordinator<CardCoordinator> handCardsCoordinator,
  ) : _playerInfoCoordinator = playerInfoCoordinator,
      _handCardsCoordinator = handCardsCoordinator;

  final PlayerInfoCoordinator _playerInfoCoordinator;
  final CardListCoordinator<CardCoordinator> _handCardsCoordinator;

  PlayerInfoCoordinator get playerInfoCoordinator => _playerInfoCoordinator;
  CardListCoordinator<CardCoordinator> get handCardsCoordinator =>
      _handCardsCoordinator;
}
