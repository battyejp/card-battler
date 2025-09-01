import 'dart:ui';

import 'package:card_battler/game/components/shared/card/card_interaction_controller.dart';
import 'package:card_battler/game/models/player/card_hand_model.dart';
import 'package:card_battler/game/models/shared/card_model.dart';
import 'package:card_battler/game/models/shared/card_pile_model.dart';
import 'package:card_battler/game/models/player/info_model.dart';

class PlayerModel {
  final InfoModel _infoModel;
  final CardHandModel _handModel;
  final CardPileModel _deckModel;
  final CardPileModel _discardModel;
  static const cardsToDrawOnTap = 5;
  VoidCallback? onCardsDrawn;

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
    if (CardInteractionController.isAnyCardSelected || handModel.cards.isNotEmpty) {
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

    onCardsDrawn?.call();
  }

  void _onCardPlayed(CardModel card) {
    // Remove card from hand and move to discard pile
    card.isFaceUp = false;
    card.onCardPlayed = null;
    _handModel.removeCard(card);
    _discardModel.addCard(card);
    CardInteractionController.deselectAny();
    applyCardEffects(card);

    // Process card effects here in the future
    // For now, just handle the basic card play mechanics
  }

  void applyCardEffects(CardModel card) {
    for (final effect in card.effects) {
      switch (effect.type) {     
        case EffectType.attack:
          // Handle attack effect
          break;
        case EffectType.heal:
          // Handle heal effect
          break;
        case EffectType.credits:
          infoModel.credits.changeValue(effect.value);
          break;
        case EffectType.damageLimit:
          // Handle damage limit effect
          break;
        case EffectType.drawCard:
          // Handle draw effect
          break;
      }
    }
  }
}
