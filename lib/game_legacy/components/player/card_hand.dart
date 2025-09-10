import 'package:card_battler/game_legacy/components/shared/card/tapable_actionable_card.dart';
import 'package:card_battler/game_legacy/models/shared/cards_model.dart';
import 'package:card_battler/game_legacy/models/shared/card_model.dart';
import 'package:card_battler/game_legacy/components/shared/reactive_position_component.dart';
import 'package:card_battler/game_legacy/services/card/card_interaction_service.dart';
import 'package:card_battler/game_legacy/services/card/card_selection_service.dart';
import 'package:flame/components.dart';

class CardHand extends ReactivePositionComponent<CardsModel<CardModel>> {
  final CardInteractionService? _cardInteractionService;
  final CardSelectionService? _cardSelectionService;

  CardHand(
    super.model, 
    {
      CardInteractionService? cardInteractionService,
      CardSelectionService? cardSelectionService,
    }
  ) : _cardInteractionService = cardInteractionService,
      _cardSelectionService = cardSelectionService;

  @override
  void updateDisplay() {
    super.updateDisplay();
    
    if (model.cards.isEmpty) return;
    
    final cardWidth = size.x * 0.15;
    final cardHeight = size.y * 0.8;

    final spacing = 20; // Spacing between cards
    final totalWidth = (cardWidth * model.cards.length) + (spacing * (model.cards.length - 1));
    final startX = (size.x - totalWidth) / 2;

    for (var i = 0; i < model.cards.length; i++) {
      final cardPosition = Vector2(startX + (i * (cardWidth + spacing)), (size.y - cardHeight) / 2);
      var cardModel = model.cards[i];

      final card = TapableActionableCard(
        cardModel, 
        onButtonPressed: () {
          _cardSelectionService?.deselectCard();
          cardModel.playCard();
        }, 
        cardInteractionService: _cardInteractionService,
        cardSelectionService: _cardSelectionService,
      )
        ..size = Vector2(cardWidth, cardHeight)
        ..position = cardPosition;

      add(card);
    }
  }
}