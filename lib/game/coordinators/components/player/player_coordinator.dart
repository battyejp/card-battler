import 'package:card_battler/game/coordinators/components/cards/card_coordinator.dart';
import 'package:card_battler/game/coordinators/components/cards/card_list_coordinator.dart';
import 'package:card_battler/game/coordinators/components/player/player_info_coordinator.dart';
import 'package:card_battler/game/services/card/effect_processor.dart';
import 'package:card_battler/game/services/game_state/game_phase_manager.dart';
import 'package:flame/effects.dart';

class PlayerCoordinator {
  //TODO should there be a class for these 3 list like there is in the shop
  final CardListCoordinator<CardCoordinator> _handCardsCoordinator;
  final CardListCoordinator<CardCoordinator> _deckCardsCoordinator;
  final CardListCoordinator<CardCoordinator> _discardCardsCoordinator;
  final PlayerInfoCoordinator _playerInfoCoordinator;
  final GamePhaseManager _gamePhaseManager;
  final EffectProcessor _effectProcessor;

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
       _effectProcessor = effectProcessor;

  CardListCoordinator<CardCoordinator> get handCardsCoordinator =>
      _handCardsCoordinator;
  CardListCoordinator<CardCoordinator> get deckCardsCoordinator =>
      _deckCardsCoordinator;
  CardListCoordinator<CardCoordinator> get discardCardsCoordinator =>
      _discardCardsCoordinator;
  PlayerInfoCoordinator get playerInfoCoordinator => _playerInfoCoordinator;

  void drawCardsFromDeck(int numberOfCards) {
    if (_isDrawingCardsPrevented()) {
      return;
    }

    final drawnCards = deckCardsCoordinator.drawCards(numberOfCards);
    for (var card in drawnCards) {
      card.onCardPlayed = onCardPlayed;
    }

    // if (drawnCards.length < numberOfCards) {
    //   moveDiscardCardsToDeck();
    //   final additionalCards = deckService.drawCards(
    //     numberOfCards - drawnCards.length,
    //   );
    //   drawnCards.addAll(additionalCards);
    // }

    if (drawnCards.isNotEmpty) {
      handCardsCoordinator.addCards(drawnCards);
    }

    _gamePhaseManager.nextPhase();
  }

  /// Moves all discard cards back to deck and shuffles
  // void moveDiscardCardsToDeck() {
  //   if (discardService.hasNoCards) {
  //     return;
  //   }

  //   final discardCards = discardService.removeAllCards();
  //   deckService.addCardsAndShuffle(discardCards);
  // }

  void onCardPlayed(CardCoordinator cardCoordinator) {
    cardCoordinator.onCardPlayed = null;
    cardCoordinator.isFaceUp = false;
    handCardsCoordinator.removeCard(cardCoordinator);
    discardCardsCoordinator.addCard(cardCoordinator);
    _effectProcessor.applyCardEffects([cardCoordinator]);
  }

  bool _isDrawingCardsPrevented() {
    //TODO is first part needed?
    return /*state.cardSelectionService.hasSelection ||*/ handCardsCoordinator
        .hasCards;
  }
}
