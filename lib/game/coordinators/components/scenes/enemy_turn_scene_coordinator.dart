import 'package:card_battler/game/coordinators/components/cards/card_coordinator.dart';
import 'package:card_battler/game/coordinators/components/cards/card_list_coordinator.dart';
import 'package:card_battler/game/coordinators/components/team/players_coordinator.dart';
import 'package:card_battler/game/services/card/effect_processor.dart';

class EnemyTurnSceneCoordinator {
  final CardListCoordinator<CardCoordinator> _playedCardsCoordinator;
  final CardListCoordinator<CardCoordinator> _deckCardsCoordinator;
  final PlayersCoordinator _playersCoordinator;
  final EffectProcessor _effectProcessor;
  
  EnemyTurnSceneCoordinator({
    required CardListCoordinator<CardCoordinator> playedCardsCoordinator,
    required CardListCoordinator<CardCoordinator> deckCardsCoordinator,
    required PlayersCoordinator playersCoordinator,
    required EffectProcessor effectProcessor,
  }) : _playedCardsCoordinator = playedCardsCoordinator,
       _deckCardsCoordinator = deckCardsCoordinator,
       _playersCoordinator = playersCoordinator,
       _effectProcessor = effectProcessor;

  CardListCoordinator<CardCoordinator> get playedCardsCoordinator =>
      _playedCardsCoordinator;
  CardListCoordinator<CardCoordinator> get deckCardsCoordinator =>
      _deckCardsCoordinator;
  PlayersCoordinator get playersCoordinator => _playersCoordinator;

  void drawCardsFromDeck() {
    //TODO determine number
    final drawnCards = deckCardsCoordinator.drawCards(1);

    if (drawnCards.isNotEmpty) {
      playedCardsCoordinator.addCards(drawnCards);
      _effectProcessor.applyCardEffectsToPlayers(drawnCards);
    }

    // if (_turnManager.isTurnFinished) {
    //   _turnManager.completeTurn(_state);
    // }
  }
}
