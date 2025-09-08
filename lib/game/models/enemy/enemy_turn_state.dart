import 'package:card_battler/game/models/shared/cards_model.dart';
import 'package:card_battler/game/models/team/players_model.dart';
import 'package:card_battler/game/services/game_state/game_state_service.dart';

/// Simple data holder for enemy turn state
/// Contains only the models needed for enemy turn operations without any behavior
/// This class follows the Single Responsibility Principle by focusing solely on data storage
/// and providing consistency with PlayerTurnState architecture
class EnemyTurnState {
  final CardPileModel enemyCards;
  final CardPileModel playedCards;
  final PlayersModel playersModel;
  final GameStateService gameStateService;

  const EnemyTurnState({
    required this.enemyCards,
    required this.playedCards,
    required this.playersModel,
    required this.gameStateService,
  });
}