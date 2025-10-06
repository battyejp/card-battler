import 'package:card_battler/game/coordinators/components/cards/card_coordinator.dart';
import 'package:card_battler/game/coordinators/components/cards/card_list_coordinator.dart';
import 'package:card_battler/game/coordinators/components/player/player_info_coordinator.dart';
import 'package:card_battler/game/services/card/effects/effect_processor.dart';
import 'package:card_battler/game/services/game/game_phase_manager.dart';

class PlayerCardManager {
  PlayerCardManager({
    required CardListCoordinator<CardCoordinator> handCardsCoordinator,
    required CardListCoordinator<CardCoordinator> deckCardsCoordinator,
    required CardListCoordinator<CardCoordinator> discardCardsCoordinator,
    required GamePhaseManager gamePhaseManager,
    required EffectProcessor effectProcessor,
    required PlayerInfoCoordinator playerInfoCoordinator,
  }) : _handCardsCoordinator = handCardsCoordinator,
       _deckCardsCoordinator = deckCardsCoordinator,
       _discardCardsCoordinator = discardCardsCoordinator,
       _gamePhaseManager = gamePhaseManager,
       _effectProcessor = effectProcessor,
       _playerInfoCoordinator = playerInfoCoordinator;

  final CardListCoordinator<CardCoordinator> _handCardsCoordinator;
  final CardListCoordinator<CardCoordinator> _deckCardsCoordinator;
  final CardListCoordinator<CardCoordinator> _discardCardsCoordinator;
  final GamePhaseManager _gamePhaseManager;
  final EffectProcessor _effectProcessor;
  final PlayerInfoCoordinator _playerInfoCoordinator;

  void drawCardsFromDeck(int numberOfCards) {
    if (_isDrawingCardsPrevented()) {
      return;
    }

    final drawnCards = _deckCardsCoordinator.drawCards(numberOfCards);

    if (drawnCards.length < numberOfCards) {
      _moveCardsFromDiscardToDeck(numberOfCards, drawnCards);
    }

    for (final card in drawnCards) {
      card.onCardPlayed = _onCardPlayed;
    }

    _handCardsCoordinator.addCards(drawnCards);
    _playerInfoCoordinator.abilitiesCheck();
    _gamePhaseManager.nextPhase();
  }

  void _moveCardsFromDiscardToDeck(
    int numberOfCardsNeededForHand,
    List<CardCoordinator> drawnCardsAlreadyDrawn,
  ) {
    _discardCardsCoordinator.shuffle();

    final discardCards = _discardCardsCoordinator.drawCards(
      numberOfCardsNeededForHand - drawnCardsAlreadyDrawn.length,
      refreshUi: false,
    );

    drawnCardsAlreadyDrawn.addAll(discardCards);

    final restOfDiscardCards = _discardCardsCoordinator.removeAllCards();
    _deckCardsCoordinator.addCards(restOfDiscardCards);
  }

  void _onCardPlayed(CardCoordinator cardCoordinator) {
    cardCoordinator.onCardPlayed = null;
    cardCoordinator.isFaceUp = false;
    _handCardsCoordinator.removeCard(cardCoordinator);
    _discardCardsCoordinator.addCard(cardCoordinator);
    _effectProcessor.applyCardEffects(cardCoordinator);
    _playerInfoCoordinator.abilitiesCheck();
  }

  bool _isDrawingCardsPrevented() => _handCardsCoordinator.hasCards;
}
