import 'package:card_battler/game_legacy/models/enemy/enemies_model.dart';
import 'package:card_battler/game_legacy/services/player/player_coordinator.dart';
import 'package:card_battler/game_legacy/services/shop/shop_coordinator.dart';
import 'package:card_battler/game_legacy/models/team/team_model.dart';

/// Simple data holder for player turn state
/// Contains only the models needed for player turn without any behavior
/// This class follows the Single Responsibility Principle by focusing solely on data storage
class PlayerTurnModel {
  final PlayerCoordinator playerModel;
  final TeamModel teamModel;
  final EnemiesModel enemiesModel;
  final ShopCoordinator shopModel;

  const PlayerTurnModel({
    required this.playerModel,
    required this.teamModel,
    required this.enemiesModel,
    required this.shopModel,
  });
}