import 'package:card_battler/game/components/shared/card/tapable_actionable_card.dart';
import 'package:card_battler/game/models/shop/shop_card_model.dart';
import 'package:card_battler/game/services/card/card_interaction_service.dart';
import 'package:card_battler/game/services/card/card_selection_service.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:flame/components.dart';

class ShopCard extends TapableActionableCard {
  final ShopCardModel shopCardModel;
  late TextComponent _costTextComponent;

  ShopCard(
    this.shopCardModel, 
    {
      bool Function()? determineIfButtonEnabled,
      CardInteractionService? cardInteractionService,
      CardSelectionService? cardSelectionService,
    }
  ) : super(
        shopCardModel, 
        onButtonPressed: () {
          cardSelectionService?.deselectCard();
          shopCardModel.playCard();
        },
        determineIfButtonEnabled: determineIfButtonEnabled ?? 
          (() => cardInteractionService?.canPurchaseShopCard(shopCardModel) ?? true),
        cardInteractionService: cardInteractionService,
        cardSelectionService: cardSelectionService,
      );

  @override
  String get buttonLabel => "Buy";

  @override
  void addTextComponent() {
    if (cardModel.isFaceUp) {
      // Create name text component positioned higher to make room for cost
      createNameTextComponent(Vector2(size.x / 2, size.y / 2 - 15));
      add(nameTextComponent);
      
      // Add the cost text component
      _costTextComponent = TextComponent(
        text: "Cost: ${shopCardModel.cost}",
        anchor: Anchor.center,
        position: Vector2(size.x / 2, size.y / 2 + 15),
        textRenderer: TextPaint(
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      );
      add(_costTextComponent);
    } else {
      // Call parent implementation for face-down cards
      super.addTextComponent();
    }
  }
}
