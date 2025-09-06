import 'package:card_battler/game/models/shared/card_model.dart';
import 'package:card_battler/game/models/player/card_hand_model.dart';
import 'package:card_battler/game/models/shared/card_pile_model.dart';
import 'package:card_battler/game/services/game_state_service.dart';
import 'package:card_battler/game/services/card_selection_service.dart';

class PlayerActionService {
  final GameStateService _gameStateService;
  final CardSelectionService _cardSelectionService;

  PlayerActionService({
    required GameStateService gameStateService,
    required CardSelectionService cardSelectionService,
  }) : _gameStateService = gameStateService,
       _cardSelectionService = cardSelectionService;

  void drawCardsFromDeck({
    required CardPileModel deckModel,
    required CardHandModel handModel,
    required int cardsToDraw,
    required Function(CardModel) onCardPlayed,
  }) {
    if (_cardSelectionService.hasSelection || handModel.cards.isNotEmpty) {
      return;
    }

    final drawnCards = deckModel.drawCards(cardsToDraw);

    if (drawnCards.isNotEmpty) {
      for (final card in drawnCards) {
        card.isFaceUp = true;
        card.onCardPlayed = () => onCardPlayed(card);
      }
      handModel.addCards(drawnCards);
    }

    _gameStateService.nextPhase();
  }

  void handleCardPlayed(CardModel card, Function(CardModel)? cardPlayedCallback) {
    card.onCardPlayed = null;
    cardPlayedCallback?.call(card);
  }
}