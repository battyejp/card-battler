import 'package:card_battler/game/components/shared/card/card_interaction_controller.dart';
import 'package:card_battler/game/models/enemy/enemies_model.dart';
import 'package:card_battler/game/models/game_state_model.dart';
import 'package:card_battler/game/models/player/player_model.dart';
import 'package:card_battler/game/models/shared/card_model.dart';
import 'package:card_battler/game/models/shop/shop_card_model.dart';
import 'package:card_battler/game/models/shop/shop_model.dart';
import 'package:card_battler/game/models/team/team_model.dart';
import 'package:flutter/foundation.dart';

enum TurnButtonAction { navigateToEnemyTurn, showConfirmDialog, endTurnDirectly }

class PlayerTurnModel {
  final PlayerModel playerModel;
  final TeamModel teamModel;
  final EnemiesModel enemiesModel;
  final ShopModel shopModel;

  // UI callbacks
  VoidCallback? onNavigateToEnemyTurn;
  VoidCallback? onShowConfirmDialog;
  VoidCallback? onSetTurnButtonEndTurnText;
  VoidCallback? onHideTurnButton;

  PlayerTurnModel({
    required this.playerModel,
    required this.teamModel,
    required this.enemiesModel,
    required this.shopModel,
  }) {
    playerModel.cardPlayed = onCardPlayed;
    shopModel.cardPlayed = onCardPlayed;
  }

  void discardHand() {
    playerModel.discardModel.addCards(playerModel.handModel.cards);
    playerModel.handModel.clearCards();
  }

  void onCardPlayed(CardModel card) {
    card.isFaceUp = false;

    if (card is ShopCardModel) {
      shopModel.removeSelectableCardFromShop(card);
      playerModel.infoModel.credits.changeValue(-card.cost);
    } else {
      playerModel.handModel.removeCard(card);
    }

    playerModel.discardModel.addCard(card);
    CardInteractionController.deselectAny();

    applyCardEffects(card);
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
        playerModel.infoModel.credits.changeValue(effect.value);
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

  void endTurn() {
    //TODO clear coins
    //TODO clear Attack
    //TODO might need to shuffle discard back into deck

    discardHand();
    shopModel.refillShop();
    GameStateModel.instance.currentPhase = GamePhase.setup;
  }

  void handleTurnButtonPress() {
    if (GameStateModel.instance.currentPhase == GamePhase.setup) {
      // Change button text and transition to enemy turn
      onSetTurnButtonEndTurnText?.call();
      GameStateModel.instance.currentPhase = GamePhase.enemyTurn;
      onNavigateToEnemyTurn?.call();
    }
    else if (GameStateModel.instance.currentPhase == GamePhase.playerTurn) {
      if (playerModel.handModel.cards.isNotEmpty) {
        // Show confirmation dialog
        onShowConfirmDialog?.call();
      }
      else {
        // End turn directly
        endTurn();
      }
    }
  }
}