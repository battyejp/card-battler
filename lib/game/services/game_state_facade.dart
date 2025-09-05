import 'package:card_battler/game/models/enemy/enemy_turn_area_model.dart';
import 'package:card_battler/game/models/player/player_model.dart';
import 'package:card_battler/game/models/shared/card_model.dart';
import 'package:card_battler/game/models/shop/shop_card_model.dart';
import 'package:card_battler/game/services/game_state_factory.dart';
import 'package:card_battler/game/services/player_turn_coordinator.dart';

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
  EnemyTurnAreaModel get enemyTurnArea => _ensuredComponents.enemyTurnArea;

  /// Gets the player turn coordinator for player turn logic
  PlayerTurnCoordinator get playerTurn => _ensuredComponents.playerTurn;

  /// Gets the currently selected player
  PlayerModel? get selectedPlayer => _ensuredComponents.selectedPlayer;

  /// Gets all players in the game
  List<PlayerModel> get allPlayers => _ensuredComponents.allPlayers;

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