import 'package:card_battler/game/components/shared/card/card_interaction_controller.dart';
import 'package:card_battler/game/models/enemy/enemies_model.dart';
import 'package:card_battler/game/models/player/player_model.dart';
import 'package:card_battler/game/models/shared/card_model.dart';
import 'package:card_battler/game/models/shop/shop_card_model.dart';
import 'package:card_battler/game/models/shop/shop_model.dart';
import 'package:card_battler/game/models/team/team_model.dart';

class PlayerTurnModel {
  final PlayerModel playerModel;
  final TeamModel teamModel;
  final EnemiesModel enemiesModel;
  final ShopModel shopModel;

  static PlayerModel? selectedPlayer;

  PlayerTurnModel({
    required this.playerModel,
    required this.teamModel,
    required this.enemiesModel,
    required this.shopModel,
  }) {
    playerModel.cardPlayed = onCardPlayed;
    shopModel.cardPlayed = onCardPlayed;
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
}