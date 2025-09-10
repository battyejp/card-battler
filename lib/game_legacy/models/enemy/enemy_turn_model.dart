import 'package:card_battler/game_legacy/models/shared/card_model.dart';
import 'package:card_battler/game_legacy/models/shared/cards_model.dart';
import 'package:card_battler/game_legacy/models/team/players_model.dart';
import 'package:card_battler/game_legacy/services/game_state/game_state_service.dart';

/// Simple data holder for enemy turn state
/// Contains only the models needed for enemy turn operations without any behavior
/// This class follows the Single Responsibility Principle by focusing solely on data storage
/// and providing consistency with PlayerTurnState architecture
class EnemyTurnModel {
  final CardsModel<CardModel> enemyCards;
  final CardsModel<CardModel> playedCards;
  final PlayersModel playersModel;
  final GameStateService gameStateService;

  const EnemyTurnModel({
    required this.enemyCards,
    required this.playedCards,
    required this.playersModel,
    required this.gameStateService,
  });
}