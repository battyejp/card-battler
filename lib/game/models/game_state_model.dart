import 'package:card_battler/game/models/base/base_model.dart';
import 'package:card_battler/game/models/enemy/enemies_model.dart';
import 'package:card_battler/game/models/player/player_model.dart';
import 'package:card_battler/game/models/shop/shop_model.dart';

class GameStateModel {
  GameStateModel({
    required this.shop,
    required this.players,
    required this.bases,
    required this.enemiesModel,
  });

  final ShopModel shop;
  final List<PlayerModel> players;
  final EnemiesModel enemiesModel;
  final List<BaseModel> bases;

  PlayerModel get activePlayer =>
      players.firstWhere((player) => player.isActive);
}
