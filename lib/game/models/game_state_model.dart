import 'package:card_battler/game/models/base/base_model.dart';
import 'package:card_battler/game/models/card/card_list_model.dart';
import 'package:card_battler/game/models/card/card_model.dart';
import 'package:card_battler/game/models/enemy/enemies_model.dart';
import 'package:card_battler/game/models/enemy/enemy_model.dart';
import 'package:card_battler/game/models/player/player_model.dart';
import 'package:card_battler/game/models/shared/health_model.dart';
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
    List<BaseModel> bases,
  ) {
    final players = List<PlayerModel>.generate(5, (index) {
      final isActive = index == 0; // Only the first player is active
      final playerDeckCopy = List<CardModel>.from(
        playerDeckCards.map((card) => card.copy()),
      );
      return PlayerModel(
        name: 'Player ${index + 1}',
        healthModel: HealthModel(10, 10),
        handCards: CardListModel<CardModel>.empty(),
        deckCards: CardListModel<CardModel>(cards: playerDeckCopy),
        discardCards: CardListModel<CardModel>.empty(),
        isActive: isActive,
        credits: 0,
        attack: 0,
      );
    });

    final enemies = List<EnemyModel>.generate(
      4,
      (index) => EnemyModel(
        name: 'Player ${index + 1}',
        healthModel: HealthModel(10, 10),
      ),
    );

    final enemiesModel = EnemiesModel(
      enemies: enemies,
      deckCards: CardListModel<CardModel>(cards: enemyCards),
      playedCards: CardListModel<CardModel>.empty(),
    );

    final basesModel = List.generate(
      3,
      (index) => BaseModel(
        name: 'Base ${index + 1}',
        healthModel: HealthModel(10, 10),
      ),
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
