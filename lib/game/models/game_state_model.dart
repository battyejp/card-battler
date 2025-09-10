import 'package:card_battler/game/models/card/cards_model.dart';
import 'package:card_battler/game/models/enemy/enemy_model.dart';
import 'package:card_battler/game/models/player/info_model.dart';
import 'package:card_battler/game/models/player/player_model.dart';
import 'package:card_battler/game/models/shared/card_model.dart';
import 'package:card_battler/game/models/shop/shop_card_model.dart';
import 'package:card_battler/game/models/shop/shop_model.dart';
import 'package:flutter/painting.dart';

class GameStateModel {
  final ShopModel shop;
  final List<PlayerModel> players;
  final List<EnemyModel> enemies;
  final CardsModel<CardModel> enemyPlayerCards;

  GameStateModel({required this.shop, required this.players, required this.enemies, required this.enemyPlayerCards});

  factory GameStateModel.initialize(
    List<ShopCardModel> shopCards,
    List<CardModel> playerDeckCards,
    List<CardModel> enemyCards,
  ) {
  
    final playerDeckCopy = List<CardModel>.from(playerDeckCards.map((card) => card.copy()));

    final player = PlayerModel(
      attack: 5,
      credits: 100,
      health: 100,
      handCards: CardsModel<CardModel>.empty(),
      deckCards: playerDeckCopy,
      discardCards: CardsModel<CardModel>.empty(),
      isActive: false,
    );

    return GameStateModel(
      shop: ShopModel(cards: shopCards, rows: 2, columns: 3, backgroundColor: const Color(0xFFE0E0E0)),
      players: players,
      enemies: enemies,
      enemyPlayerCards: enemyPlayerCards,
    );
  }

  PlayerModel get activePlayer => players.firstWhere((player) => player.isActive);
}