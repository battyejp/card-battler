import 'package:card_battler/game/coordinators/components/cards/card_coordinator.dart';
import 'package:card_battler/game/coordinators/components/cards/card_list_coordinator.dart';
import 'package:card_battler/game/coordinators/components/team/players_coordinator.dart';

class EnemyTurnSceneCoordinator {
  final CardListCoordinator<CardCoordinator> _playedCardsCoordinator;
  final CardListCoordinator<CardCoordinator> _deckCardsCoordinator;
  final PlayersCoordinator _playersCoordinator;

  EnemyTurnSceneCoordinator({
    required CardListCoordinator<CardCoordinator> playedCardsCoordinator,
    required CardListCoordinator<CardCoordinator> deckCardsCoordinator,
    required PlayersCoordinator playersCoordinator,
  }) : _playedCardsCoordinator = playedCardsCoordinator,
       _deckCardsCoordinator = deckCardsCoordinator,
       _playersCoordinator = playersCoordinator;

  CardListCoordinator<CardCoordinator> get playedCardsCoordinator =>
      _playedCardsCoordinator;
  CardListCoordinator<CardCoordinator> get deckCardsCoordinator =>
      _deckCardsCoordinator;
  PlayersCoordinator get playersCoordinator => _playersCoordinator;

  void drawCardsFromDeck() {
    //TODO determine number
    final drawnCards = deckCardsCoordinator.drawCards(1);

    // if (drawnCard != null) {
    //   _effectProcessor.processCardEffects(drawnCard, _state);
    // }

    if (drawnCards.isNotEmpty) {
      playedCardsCoordinator.addCards(drawnCards);
    }

    // if (_turnManager.isTurnFinished) {
    //   _turnManager.completeTurn(_state);
    // }
  }
}
