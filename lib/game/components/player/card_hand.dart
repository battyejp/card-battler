import 'package:card_battler/game/models/player/card_hand_model.dart';
import 'package:card_battler/game/components/shared/card.dart';
import 'package:card_battler/game/components/reactive_position_component.dart';
import 'package:flame/components.dart';

class CardHand extends ReactivePositionComponent<CardHandModel> {
  CardHand(super.model);

  @override
  bool get debugMode => true;

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

      final card = Card(model.cards[i])
        ..size = Vector2(cardWidth, cardHeight)
        ..position = cardPosition;

      add(card);
    }
  }
}