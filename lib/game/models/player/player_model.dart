import 'package:card_battler/game/components/shared/card/card_interaction_controller.dart';
import 'package:card_battler/game/models/player/card_hand_model.dart';
import 'package:card_battler/game/models/shared/card_pile_model.dart';
import 'package:card_battler/game/models/player/info_model.dart';

class PlayerModel {
  final InfoModel _infoModel;
  final CardHandModel _handModel;
  final CardPileModel _deckModel;
  final CardPileModel _discardModel;
  static const cardsToDrawOnTap = 5;

  PlayerModel({
    required InfoModel infoModel,
    required CardHandModel handModel,
    required CardPileModel deckModel,
    required CardPileModel discardModel,
  }) : _infoModel = infoModel,
       _handModel = handModel,
       _deckModel = deckModel,
       _discardModel = discardModel;

  // Expose models for use in the game components
  InfoModel get infoModel => _infoModel;
  CardHandModel get handModel => _handModel;
  CardPileModel get deckModel => _deckModel;
  CardPileModel get discardModel => _discardModel;

  void drawCardsFromDeck() {
    if (CardInteractionController.isAnyCardSelected) {
      return;
    }

    final drawnCards = _deckModel.drawCards(cardsToDrawOnTap);

    if (drawnCards.isNotEmpty) {
      for (final card in drawnCards) {
        card.isFaceUp = true;
      }
      _handModel.addCards(drawnCards);
    }
  }
}
