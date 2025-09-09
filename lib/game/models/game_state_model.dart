import 'package:card_battler/game/services/enemy/enemy_turn_coordinator.dart';
import 'package:card_battler/game/services/player/player_coordinator.dart';
import 'package:card_battler/game/models/shared/card_model.dart';
import 'package:card_battler/game/models/shop/shop_card_model.dart';
import 'package:card_battler/game/services/game_state/game_state_facade.dart';
import 'package:card_battler/game/services/playerTurn/player_turn_coordinator.dart';

/// Represents the different phases of the game
enum GamePhase {
  /// Initial phase when waiting for player to draw cards
  waitingToDrawCards,
  
  /// Phase after player has drawn their cards but before enemy turn
  cardsDrawnWaitingForEnemyTurn,
  
  /// Enemy's turn to play cards and take actions
  enemyTurn,
  
  /// Player's turn to play cards and take actions
  playerTurn,

  /// Phase to switch to the next player after cards have been drawn
  cardsDrawnWaitingForPlayerSwitch,
}

/// Simplified game state model that delegates to the facade
/// This model now follows SRP by focusing solely on providing backward compatibility
/// All complex logic has been moved to appropriate services (Factory and Facade)
class GameStateModel {
  static final GameStateFacade _facade = GameStateFacade.instance;

  /// Gets the singleton instance of GameStateModel
  /// This maintains backward compatibility while using the new architecture
  static GameStateModel get instance => GameStateModel();

  /// Initializes the game state with provided cards
  /// Delegates to the facade which manages the complexity
  static GameStateModel initialize(List<ShopCardModel> shopCards, List<CardModel> playerDeckCards, List<CardModel> enemyCards) {
    _facade.initialize(shopCards, playerDeckCards, enemyCards);
    return instance;
  }

  /// Resets the game state (useful for testing or starting a new game)
  static void reset() {
    _facade.reset();
  }

  /// Gets the enemy turn area - delegates to facade
  EnemyTurnCoordinator get enemyTurnArea => _facade.enemyTurnArea;

  /// Gets the player turn coordinator - delegates to facade
  PlayerTurnCoordinator get playerTurn => _facade.playerTurn;

  /// Gets the selected player - delegates to facade
  PlayerCoordinator? get selectedPlayer => _facade.selectedPlayer;

  /// Gets debug information about the current game state
  String get debugInfo => _facade.debugInfo;
}