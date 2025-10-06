import 'package:card_battler/game/coordinators/components/cards/card_coordinator.dart';
import 'package:card_battler/game/coordinators/components/cards/card_list_coordinator.dart';
import 'package:card_battler/game/coordinators/components/player/player_info_coordinator.dart';
import 'package:card_battler/game/services/card/effects/effect_processor.dart';
import 'package:card_battler/game/services/card/player_card_manager.dart';
import 'package:card_battler/game/services/game/game_phase_manager.dart';

class PlayerCoordinator {
  PlayerCoordinator({
    required CardListCoordinator<CardCoordinator> handCardsCoordinator,
    required CardListCoordinator<CardCoordinator> deckCardsCoordinator,
    required CardListCoordinator<CardCoordinator> discardCardsCoordinator,
    required PlayerInfoCoordinator playerInfoCoordinator,
    required GamePhaseManager gamePhaseManager,
    required EffectProcessor effectProcessor,
  }) : _handCardsCoordinator = handCardsCoordinator,
       _deckCardsCoordinator = deckCardsCoordinator,
       _playerInfoCoordinator = playerInfoCoordinator,
       _discardCardsCoordinator = discardCardsCoordinator,
       _gamePhaseManager = gamePhaseManager,
       _cardManager = PlayerCardManager(
         handCardsCoordinator: handCardsCoordinator,
         deckCardsCoordinator: deckCardsCoordinator,
         discardCardsCoordinator: discardCardsCoordinator,
         gamePhaseManager: gamePhaseManager,
         effectProcessor: effectProcessor,
         playerInfoCoordinator: playerInfoCoordinator,
       ) {
    _deckCardsCoordinator.shuffle();
  }

  final CardListCoordinator<CardCoordinator> _handCardsCoordinator;
  final CardListCoordinator<CardCoordinator> _deckCardsCoordinator;
  final CardListCoordinator<CardCoordinator> _discardCardsCoordinator;
  final PlayerInfoCoordinator _playerInfoCoordinator;
  final GamePhaseManager _gamePhaseManager;
  final PlayerCardManager _cardManager;

  CardListCoordinator<CardCoordinator> get handCardsCoordinator =>
      _handCardsCoordinator;
  CardListCoordinator<CardCoordinator> get deckCardsCoordinator =>
      _deckCardsCoordinator;
  CardListCoordinator<CardCoordinator> get discardCardsCoordinator =>
      _discardCardsCoordinator;
  PlayerInfoCoordinator get playerInfoCoordinator => _playerInfoCoordinator;
  GamePhaseManager get gamePhaseManager => _gamePhaseManager;

  void drawCardsFromDeck(int numberOfCards) {
    _cardManager.drawCardsFromDeck(numberOfCards);
  }
}
