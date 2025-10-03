import 'package:card_battler/game/config/game_configuration.dart';
import 'package:card_battler/game/factories/game_state/base_factory.dart';
import 'package:card_battler/game/factories/game_state/enemy_factory.dart';
import 'package:card_battler/game/factories/game_state/player_factory.dart';
import 'package:card_battler/game/models/base/base_model.dart';
import 'package:card_battler/game/models/card/card_list_model.dart';
import 'package:card_battler/game/models/card/card_model.dart';
import 'package:card_battler/game/models/enemy/enemies_model.dart';
import 'package:card_battler/game/models/player/player_model.dart';
import 'package:card_battler/game/models/shop/shop_card_model.dart';
import 'package:card_battler/game/models/shop/shop_model.dart';

class GameStateModel {
  GameStateModel({
    required this.shop,
    required this.players,
    required this.bases,
    required this.enemiesModel,
  });

  factory GameStateModel.initialize(
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

  final ShopModel shop;
  final List<PlayerModel> players;
  final EnemiesModel enemiesModel;
  final List<BaseModel> bases;

  PlayerModel get activePlayer =>
      players.firstWhere((player) => player.isActive);
}
