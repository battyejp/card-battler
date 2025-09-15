import 'package:card_battler/game/models/base/base_model.dart';
import 'package:card_battler/game/models/card/card_model.dart';
import 'package:card_battler/game/models/card/card_list_model.dart';
import 'package:card_battler/game/models/enemy/enemies_model.dart';
import 'package:card_battler/game/models/enemy/enemy_model.dart';
import 'package:card_battler/game/models/player/player_model.dart';
import 'package:card_battler/game/models/shop/shop_card_model.dart';
import 'package:card_battler/game/models/shop/shop_model.dart';

//TODO add linter once leacy game gone
class GameStateModel {
  final ShopModel shop;
  final List<PlayerModel> players;
  final EnemiesModel enemiesModel;
  final List<BaseModel> bases;

  GameStateModel({
    required this.shop,
    required this.players,
    required this.bases,
    required this.enemiesModel,
  });

  //TODO shuffle these cards
  factory GameStateModel.initialize(
    List<ShopCardModel> shopCards,
    List<CardModel> playerDeckCards,
    List<CardModel> enemyCards,
    List<BaseModel> bases,
  ) {
    print('Initializing GameStateModel with:');
    print('- ${shopCards.length} shop cards');
    print('- ${playerDeckCards.length} player deck cards');
    print('- ${enemyCards.length} enemy cards');
    print('- ${bases.length} bases');

    final players = List<PlayerModel>.generate(2, (index) {
      final isActive = index == 0; // Only the first player is active
      final playerDeckCopy = List<CardModel>.from(
        playerDeckCards.map((card) => card.copy()),
      );
      return PlayerModel(
        name: 'Player ${index + 1}',
        maxHealth: 10,
        currentAttack: 0,
        currentCredits: 0,
        currentHealth: 10,
        handCards: CardListModel<CardModel>.empty(),
        deckCards: CardListModel<CardModel>(cards: playerDeckCopy),
        discardCards: CardListModel<CardModel>.empty(),
        isActive: isActive,
      );
    });

    final enemies = List<EnemyModel>.generate(4, (index) {
      return EnemyModel(
        name: 'Player ${index + 1}',
        maxHealth: 10,
        currentHealth: 10,
      );
    });

    final enemiesModel = EnemiesModel(
      enemies: enemies,
      deckCards: CardListModel<CardModel>(cards: enemyCards),
      playedCards: CardListModel<CardModel>.empty(),
    );

    return GameStateModel(
      shop: ShopModel(
        displayCards: CardListModel<ShopCardModel>.empty(),
        inventoryCards: CardListModel<ShopCardModel>(cards: shopCards),
      ),
      players: players,
      enemiesModel: enemiesModel,
      bases: bases,
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
    List<BaseModel> bases,
  ) {
    return GameStateModel.initialize(
      shopCards,
      playerDeckCards,
      enemyCards,
      _createDefaultBases(),
    );
  }

  // GameStateModel createDefaultGameState() {
  //   final shopCards = _createDefaultShopCards();
  //   final playerDeckCards = _createDefaultPlayerCards();
  //   final enemyCards = _createDefaultEnemyCards();
  //   final bases = _createDefaultBases();

  //   return createGameState(shopCards, playerDeckCards, enemyCards, bases);
  // }

  // List<ShopCardModel> _createDefaultShopCards() {
  //   return List.generate(10, (index) {
  //     return ShopCardModel(name: 'Test Card ${index + 1}', cost: 1);
  //   });
  // }

  // List<CardModel> _createDefaultPlayerCards() {
  //   return List.generate(10, (index) {
  //     return CardModel(
  //       name: 'Card ${index + 1}',
  //       type: 'Player',
  //       isFaceUp: false,
  //     );
  //   });
  // }

  // List<CardModel> _createDefaultEnemyCards() {
  //   return List.generate(10, (index) {
  //     return CardModel(
  //       name: 'Enemy Card ${index + 1}',
  //       type: 'Enemy',
  //       isFaceUp: false,
  //     );
  //   });
  // }

  List<BaseModel> _createDefaultBases() {
    return List.generate(3, (index) {
      return BaseModel(
        name: 'Base ${index + 1}',
        currentHealth: 10,
        maxHealth: 10,
      );
    });
  }
}
