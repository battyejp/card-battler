import 'package:card_battler/game/models/card/cards_model.dart';
import 'package:card_battler/game/models/enemy/enemies_model.dart';
import 'package:card_battler/game/models/player/player_model.dart';
import 'package:card_battler/game/models/shared/card_model.dart';
import 'package:card_battler/game/models/shop/shop_card_model.dart';
import 'package:card_battler/game/models/shop/shop_model.dart';

class GameStateModel {
  final ShopModel shop;
  final List<PlayerModel> players;
  final EnemiesModel enemiesModel;

  GameStateModel({
    required this.shop,
    required this.players,
    required this.enemiesModel,
  });

  //TODO shuffle these cards
  factory GameStateModel.initialize(
    List<ShopCardModel> shopCards,
    List<CardModel> playerDeckCards,
    List<CardModel> enemyCards,
  ) {
    final players = List<PlayerModel>.generate(2, (index) {
      final isActive = index == 0; // Only the first player is active
      final playerDeckCopy = List<CardModel>.from(
        playerDeckCards.map((card) => card.copy()),
      );
      return PlayerModel(
        attack: 0,
        credits: 0,
        health: 10,
        handCards: CardsModel<CardModel>.empty(),
        deckCards: CardsModel<CardModel>(cards: playerDeckCopy),
        discardCards: CardsModel<CardModel>.empty(),
        isActive: isActive,
      );
    });

    return GameStateModel(
      shop: ShopModel(
        displayCards: CardsModel<ShopCardModel>.empty(),
        inventoryCards: CardsModel<ShopCardModel>(cards: shopCards),
      ),
      players: players,
      enemiesModel: EnemiesModel(
        totalEnemies: 5,
        maxNumberOfEnemiesInPlay: 3,
        maxEnemyHealth: 50,
        enemyCards: CardsModel<CardModel>(cards: enemyCards),
        enemyPlayerCards: CardsModel<CardModel>.empty(),
      ),
    );
  }

  PlayerModel get activePlayer =>
      players.firstWhere((player) => player.isActive);
}


class GameStateFactory {
  GameStateModel createGameState(
    List<ShopCardModel> shopCards,
    List<CardModel> playerDeckCards,
    List<CardModel> enemyCards,
  ) {
    return GameStateModel.initialize(
      shopCards,
      playerDeckCards,
      enemyCards,
    );
  }

  GameStateModel createDefaultGameState() {
    final shopCards = _createDefaultShopCards();
    final playerDeckCards = _createDefaultPlayerCards();
    final enemyCards = _createDefaultEnemyCards();

    return createGameState(shopCards, playerDeckCards, enemyCards);
  }

  List<ShopCardModel> _createDefaultShopCards() {
    return List.generate(10, (index) {
      return ShopCardModel(
        name: 'Test Card ${index + 1}',
        cost: 1,
      );
    });
  }

  List<CardModel> _createDefaultPlayerCards() {
    return List.generate(10, (index) {
      return CardModel(
        name: 'Card ${index + 1}',
        type: 'Player',
        isFaceUp: false,
      );
    });
  }

  List<CardModel> _createDefaultEnemyCards() {
    return List.generate(10, (index) {
      return CardModel(
        name: 'Enemy Card ${index + 1}',
        type: 'Enemy',
        isFaceUp: false,
      );
    });
  }

}