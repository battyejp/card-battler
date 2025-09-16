import 'package:card_battler/game/coordinators/components/cards/card_coordinator.dart';
import 'package:card_battler/game/coordinators/components/cards/card_list_coordinator.dart';
import 'package:card_battler/game/coordinators/components/player/player_info_coordinator.dart';
import 'package:card_battler/game/services/card/effect_processor.dart';
import 'package:card_battler/game/services/game/game_phase_manager.dart';

class PlayerCoordinator {
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
       _effectProcessor = effectProcessor {
    _deckCardsCoordinator.shuffle();
  }

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

    if (drawnCards.length < numberOfCards) {
      moveCardsFromDiscardToDeck(numberOfCards, drawnCards);
    }

    for (var card in drawnCards) {
      card.onCardPlayed = onCardPlayed;
    }

    handCardsCoordinator.addCards(drawnCards);
    _gamePhaseManager.nextPhase();
  }

  void moveCardsFromDiscardToDeck(
    int numberOfCardsNeededForHand,
    List<CardCoordinator> drawnCardsAlreadyDrawn,
  ) {
    discardCardsCoordinator.shuffle();

    var discardCards = discardCardsCoordinator.drawCards(
      numberOfCardsNeededForHand - drawnCardsAlreadyDrawn.length,
      refreshUi: false,
    );

    drawnCardsAlreadyDrawn.addAll(discardCards);

    var restOfDiscardCards = discardCardsCoordinator.removeAllCards();
    deckCardsCoordinator.addCards(restOfDiscardCards);
  }

  void onCardPlayed(CardCoordinator cardCoordinator) {
    cardCoordinator.onCardPlayed = null;
    cardCoordinator.isFaceUp = false;
    handCardsCoordinator.removeCard(cardCoordinator);
    discardCardsCoordinator.addCard(cardCoordinator);
    _effectProcessor.applyCardEffects([cardCoordinator]);
  }

  bool _isDrawingCardsPrevented() {
    return handCardsCoordinator.hasCards;
  }
}
