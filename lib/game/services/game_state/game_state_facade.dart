import 'package:card_battler/game/services/enemy/enemy_turn_coordinator.dart';
import 'package:card_battler/game/models/player/player_model.dart';
import 'package:card_battler/game/models/shared/card_model.dart';
import 'package:card_battler/game/models/shop/shop_card_model.dart';
import 'package:card_battler/game/services/game_state/game_state_factory.dart';
import 'package:card_battler/game/services/game_state/game_state_manager.dart';
import 'package:card_battler/game/services/game_state/game_state_service.dart';
import 'package:card_battler/game/services/player/player_turn_coordinator.dart';

/// Facade that provides a clean, simplified API for accessing game state
/// Follows the Facade pattern and Single Responsibility Principle by managing access to game components
/// This class hides the complexity of the underlying game state structure
class GameStateFacade {
  static GameStateFacade? _instance;
  
  final GameStateFactory _factory = GameStateFactory();
  GameStateComponents? _components;

  GameStateFacade._();

  /// Gets the singleton instance of GameStateFacade
  static GameStateFacade get instance {
    _instance ??= GameStateFacade._();
    return _instance!;
  }

  /// Initializes the game state with provided cards
  /// This method delegates the complex creation logic to the factory
  void initialize(
    List<ShopCardModel> shopCards,
    List<CardModel> playerDeckCards,
    List<CardModel> enemyCards,
  ) {
    _components = _factory.createGameState(shopCards, playerDeckCards, enemyCards);
  }

  /// Resets the game state (useful for testing or starting a new game)
  void reset() {
    _components = null;
  }

  /// Gets the current game components, creating default ones if none exist
  GameStateComponents get _ensuredComponents {
    _components ??= _factory.createDefaultGameState();
    return _components!;
  }

  // Public API methods that delegate to the appropriate components

  /// Gets the enemy turn area for enemy turn logic
  EnemyTurnCoordinator get enemyTurnArea => _ensuredComponents.enemyTurnArea;

  /// Gets the player turn coordinator for player turn logic
  PlayerTurnCoordinator get playerTurn => _ensuredComponents.playerTurn;

  /// Gets the currently selected player
  PlayerModel? get selectedPlayer => _ensuredComponents.selectedPlayer;

  /// Gets all players in the game
  List<PlayerModel> get allPlayers => _ensuredComponents.allPlayers;

  /// Switches to the next player in the rotation
  /// Returns the new active player, or null if no switch occurred
  PlayerModel? switchToNextPlayer() {
    if (_components == null) return null;
    
    final currentPlayer = _components!.selectedPlayer;
    final players = _components!.allPlayers;
    
    if (currentPlayer == null || players.isEmpty) return null;
    
    // Find current player index
    final currentIndex = players.indexOf(currentPlayer);
    if (currentIndex == -1) return null;
    
    // Get next player (cycling back to 0 if at end)
    final nextIndex = (currentIndex + 1) % players.length;
    final nextPlayer = players[nextIndex];
    final nextPlayerStats = _components!.playerTurn.state.teamModel.playersModel.players[nextIndex];

    // Update PlayerStatsModel isActive flags
    final playersModel = _components!.playerTurn.state.teamModel.playersModel;
    playersModel.activePlayer = nextPlayerStats;

    // Create new PlayerTurnState and Coordinator with the next player
    final newPlayerTurnState = _factory.createPlayerTurnState(
      nextPlayer,
      playersModel,
      [],
      _components!.playerTurn.state.shopModel.selectableCards,
    );
    
    final newPlayerTurn = PlayerTurnCoordinator(
      state: newPlayerTurnState,
      gameStateService: DefaultGameStateService(GameStateManager()),
    );
    
    // Create new components with the next player as selected
    _components = GameStateComponents(
      playerTurn: newPlayerTurn,
      enemyTurnArea: _components!.enemyTurnArea,
      selectedPlayer: nextPlayer,
      allPlayers: _components!.allPlayers,
    );
    
    return nextPlayer;
  }

  /// Checks if the game state has been initialized
  bool get isInitialized => _components != null;

  /// Gets debug information about the current facade state
  String get debugInfo {
    if (_components == null) {
      return 'GameStateFacade: Not initialized';
    }
    return 'GameStateFacade: Initialized with ${_components!.allPlayers.length} players';
  }
}