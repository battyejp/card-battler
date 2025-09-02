import 'package:card_battler/game/models/enemy/enemies_model.dart';
import 'package:card_battler/game/models/player/player_model.dart';
import 'package:card_battler/game/models/shop/shop_model.dart';
import 'package:card_battler/game/models/team/team_model.dart';

class PlayerTurnModel {
  final PlayerModel playerModel;
  final TeamModel teamModel;
  final EnemiesModel enemiesModel;
  final ShopModel shopModel;

  static PlayerModel? _selectedPlayer;

  static PlayerModel? get selectedPlayer => _selectedPlayer;

  PlayerTurnModel({
    required this.playerModel,
    required this.teamModel,
    required this.enemiesModel,
    required this.shopModel,
  }) {
    _selectedPlayer ??= playerModel;
  }
}