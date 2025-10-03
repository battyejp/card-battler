import 'package:card_battler/game/config/game_configuration.dart';
import 'package:card_battler/game/factories/game_state/base_factory.dart';
import 'package:card_battler/game/factories/game_state/enemy_factory.dart';
import 'package:card_battler/game/factories/game_state/player_factory.dart';
import 'package:card_battler/game/models/base/base_model.dart';
import 'package:card_battler/game/models/card/card_list_model.dart';
import 'package:card_battler/game/models/card/card_model.dart';
import 'package:card_battler/game/models/game_state_model.dart';
import 'package:card_battler/game/models/shop/shop_card_model.dart';
import 'package:card_battler/game/models/shop/shop_model.dart';
import 'package:card_battler/game/services/card/card_loader_service.dart';

/// Factory responsible for creating and initializing game state
/// Handles loading card data from JSON files and creating the initial game state
class GameStateFactory {
  /// Initializes game state by loading all required card data from assets
  static Future<GameStateModel> create() async {
    final playerDeckCards =
        await CardLoaderService.loadCardsFromJson<CardModel>(
          'assets/data/hero_starting_cards.json',
          CardModel.fromJson,
        );

    final enemyCards = await CardLoaderService.loadCardsFromJson<CardModel>(
      'assets/data/enemy_cards.json',
      CardModel.fromJson,
    );

    final shopCards = await CardLoaderService.loadCardsFromJson<ShopCardModel>(
      'assets/data/shop_cards.json',
      ShopCardModel.fromJson,
    );

    return createWithData(shopCards, playerDeckCards, enemyCards, []);
  }

  /// Creates a GameStateModel from provided data (formerly GameStateModel.initialize)
  static GameStateModel createWithData(
    List<ShopCardModel> shopCards,
    List<CardModel> playerDeckCards,
    List<CardModel> enemyCards,
    List<BaseModel> bases, {
    GameConfiguration config = GameConfiguration.defaultConfig,
  }) {
    final players = PlayerFactory.createPlayers(
      count: config.numberOfPlayers,
      playerDeckCards: playerDeckCards,
      config: config,
    );

    final enemiesModel = EnemyFactory.createEnemiesModel(
      count: config.numberOfEnemies,
      enemyCards: enemyCards,
      config: config,
    );

    final basesModel = BaseFactory.createBases(
      count: config.numberOfBases,
      config: config,
    );

    return GameStateModel(
      shop: ShopModel(
        displayCards: CardListModel<ShopCardModel>.empty(),
        inventoryCards: CardListModel<ShopCardModel>(cards: shopCards),
      ),
      players: players,
      enemiesModel: enemiesModel,
      bases: basesModel,
    );
  }
}
