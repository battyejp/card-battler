import 'package:card_battler/game/models/enemy/enemies_model.dart';
import 'package:card_battler/game/models/game_state_model.dart';
import 'package:card_battler/game/models/player/player_model.dart';
import 'package:card_battler/game/models/shared/card_model.dart';
import 'package:card_battler/game/models/shop/shop_card_model.dart';
import 'package:card_battler/game/models/shop/shop_model.dart';
import 'package:card_battler/game/models/team/team_model.dart';
import 'package:card_battler/game/services/game_state_service.dart';

enum TurnButtonAction { navigateToEnemyTurn, showConfirmDialog, endTurnDirectly }

class PlayerTurnModel {
  final PlayerModel playerModel;
  final TeamModel teamModel;
  final EnemiesModel enemiesModel;
  final ShopModel shopModel;
  final GameStateService _gameStateService;

  PlayerTurnModel({
    required this.playerModel,
    required this.teamModel,
    required this.enemiesModel,
    required this.shopModel,
    required GameStateService gameStateService,
  }) : _gameStateService = gameStateService {
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
    _gameStateService.nextPhase(); // Should be waitingToDrawCards
  }

  void handleTurnButtonPress() {
    if (_gameStateService.currentPhase == GamePhase.playerTurn) {
      if (playerModel.handModel.cards.isNotEmpty) {
        _gameStateService.requestConfirmation();
        return;
      }

      endTurn();
    }
    else{
      _gameStateService.nextPhase();
    }
  }
}