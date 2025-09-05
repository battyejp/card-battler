import 'package:card_battler/game/models/enemy/enemies_model.dart';
import 'package:card_battler/game/models/player/player_model.dart';
import 'package:card_battler/game/models/shop/shop_model.dart';
import 'package:card_battler/game/models/team/team_model.dart';

/// Simple data holder for player turn state
/// Contains only the models needed for player turn without any behavior
/// This class follows the Single Responsibility Principle by focusing solely on data storage
class PlayerTurnState {
  final PlayerModel playerModel;
  final TeamModel teamModel;
  final EnemiesModel enemiesModel;
  final ShopModel shopModel;

  const PlayerTurnState({
    required this.playerModel,
    required this.teamModel,
    required this.enemiesModel,
    required this.shopModel,
  });
}