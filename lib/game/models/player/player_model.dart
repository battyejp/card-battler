import 'package:card_battler/game/models/player/card_hand_model.dart';
import 'package:card_battler/game/models/shared/card_model.dart';
import 'package:card_battler/game/models/shared/card_pile_model.dart';
import 'package:card_battler/game/models/player/info_model.dart';
import 'package:card_battler/game/services/game_state_service.dart';
import 'package:card_battler/game/services/card_selection_service.dart';

class PlayerModel {
  final InfoModel _infoModel;
  final CardHandModel _handModel;
  final CardPileModel _deckModel;
  final CardPileModel _discardModel;
  final GameStateService? _gameStateService;
  final CardSelectionService? _cardSelectionService;

  static const cardsToDrawOnTap = 5;
  Function(CardModel)? cardPlayed;

  PlayerModel({
    required InfoModel infoModel,
    required CardHandModel handModel,
    required CardPileModel deckModel,
    required CardPileModel discardModel,
    GameStateService? gameStateService,
    CardSelectionService? cardSelectionService,
  }) : _infoModel = infoModel,
       _handModel = handModel,
       _deckModel = deckModel,
       _discardModel = discardModel,
       _gameStateService = gameStateService,
       _cardSelectionService = cardSelectionService;

  // Expose models for use in the game components
  InfoModel get infoModel => _infoModel;
  CardHandModel get handModel => _handModel;
  CardPileModel get deckModel => _deckModel;
  CardPileModel get discardModel => _discardModel;

  void drawCardsFromDeck() {
    if ((_cardSelectionService?.hasSelection ?? false) || handModel.cards.isNotEmpty) {
      return;
    }

    final drawnCards = _deckModel.drawCards(cardsToDrawOnTap);

    if (drawnCards.isNotEmpty) {
      for (final card in drawnCards) {
        card.isFaceUp = true;
        card.onCardPlayed = () => _onCardPlayed(card);
      }
      _handModel.addCards(drawnCards);
    }

    _gameStateService?.nextPhase();
  }

  void _onCardPlayed(CardModel card) {
    card.onCardPlayed = null;
    cardPlayed?.call(card);
  }
}
