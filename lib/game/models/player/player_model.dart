import 'package:card_battler/game/models/shared/cards_model.dart';
import 'package:card_battler/game/models/shared/card_model.dart';
import 'package:card_battler/game/models/player/info_model.dart';
import 'package:card_battler/game/services/game_state/game_state_service.dart';
import 'package:card_battler/game/services/card/card_selection_service.dart';

//TODO break up class
class PlayerModel {
  final InfoModel _infoModel;
  final CardsModel<CardModel> _handCards;
  final CardsModel<CardModel> _deckCards;
  final CardsModel<CardModel> _discardCards;
  final GameStateService? _gameStateService;
  final CardSelectionService? _cardSelectionService;
  
  static const cardsToDrawOnTap = 5;
  Function(CardModel)? cardPlayed;
  bool turnOver = false;

  PlayerModel({
    required InfoModel infoModel,
    required CardsModel<CardModel> handModel,
    required CardsModel<CardModel> deckModel,
    required CardsModel<CardModel> discardModel,
    required GameStateService gameStateService,
    required CardSelectionService cardSelectionService,
  }) : _infoModel = infoModel,
       _handCards = handModel,
       _deckCards = deckModel,
       _discardCards = discardModel,
       _gameStateService = gameStateService,
       _cardSelectionService = cardSelectionService {
    _deckCards.shuffle();
  }

  // Expose models for use in the game components
  InfoModel get infoModel => _infoModel;
  CardsModel<CardModel> get handCards => _handCards;
  CardsModel<CardModel> get deckCards => _deckCards;
  CardsModel<CardModel> get discardCards => _discardCards;

  void drawCardsFromDeck() {
    if ((_cardSelectionService?.hasSelection ?? false) || handCards.cards.isNotEmpty) {
      return;
    }

    final drawnCards = _deckCards.drawCards(cardsToDrawOnTap);

    if (drawnCards.length < cardsToDrawOnTap) {
      moveDiscardCardsToDeck();
      final additionalCards = _deckCards.drawCards(cardsToDrawOnTap - drawnCards.length);
      drawnCards.addAll(additionalCards);
    }

    if (drawnCards.isNotEmpty) {
      for (final card in drawnCards) {
        card.onCardPlayed = () => _onCardPlayed(card);
      }
      _handCards.addCards(drawnCards);
    }

    _gameStateService?.nextPhase();
  }

  void discardHand() {
    for (var card in handCards.cards) {
      card.isFaceUp = false;
    }

    _discardCards.addCards(handCards.cards);
    handCards.clearCards();
  }

  void moveDiscardCardsToDeck() {
    if (_discardCards.hasNoCards) {
      return;
    }

    final discardCards = _discardCards.allCards;
    _deckCards.addCards(discardCards);
    _discardCards.clearCards();
    _deckCards.shuffle();
  }

  void _onCardPlayed(CardModel card) {
    card.onCardPlayed = null;
    cardPlayed?.call(card);
  }
}
