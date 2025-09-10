import 'package:card_battler/game_legacy/services/enemy/enemy_turn_coordinator.dart';
import 'package:card_battler/game_legacy/models/player/info_model.dart';
import 'package:card_battler/game_legacy/models/shared/cards_model.dart';
import 'package:card_battler/game_legacy/models/enemy/enemies_model.dart';
import 'package:card_battler/game_legacy/services/player/player_coordinator.dart';
import 'package:card_battler/game_legacy/models/player/player_model.dart';
import 'package:card_battler/game_legacy/models/shared/card_model.dart';
import 'package:card_battler/game_legacy/models/shared/health_model.dart';
import 'package:card_battler/game_legacy/models/team/base_model.dart';
import 'package:card_battler/game_legacy/models/team/player_stats_model.dart';
import 'package:card_battler/game_legacy/models/team/players_model.dart';
import 'package:card_battler/game_legacy/models/team/team_model.dart';
import 'package:card_battler/game_legacy/services/shop/shop_coordinator.dart';
import 'package:card_battler/game_legacy/models/team/bases_model.dart';
import 'package:card_battler/game_legacy/models/shared/value_image_label_model.dart';
import 'package:card_battler/game_legacy/models/shop/shop_card_model.dart';
import 'package:card_battler/game_legacy/models/player/player_turn_model.dart';
import 'package:card_battler/game_legacy/services/game_state/game_state_manager.dart';
import 'package:card_battler/game_legacy/services/game_state/game_state_service.dart';
import 'package:card_battler/game_legacy/services/card/card_selection_service.dart';
import 'package:card_battler/game_legacy/services/player_turn/player_turn_coordinator.dart';

/// Factory service responsible for creating and initializing game components
/// Follows the Factory pattern and Single Responsibility Principle by focusing solely on game creation logic
class GameStateFactory {
  static const int _numberOfPlayers = 2;
  static const int _playerMaxHealth = 10;
  static const int _numberOfBases = 3;
  static const int _baseMaxHealth = 5;
  static const int _totalEnemies = 4;
  static const int _maxEnemiesInPlay = 3;
  static const int _maxEnemyHealth = 5;
  static const int _shopRows = 2;
  static const int _shopColumns = 3;

  /// Creates a complete game state with all necessary components
  /// This method encapsulates all the complex initialization logic previously in GameStateModel
  GameStateComponents createGameState(
    List<ShopCardModel> shopCards,
    List<CardModel> playerDeckCards,
    List<CardModel> enemyCards,
  ) {
    // Create shared services
    final gameStateService = DefaultGameStateService(GameStateManager());
    final cardSelectionService = DefaultCardSelectionService();

    // Create players with shared services
    final players = _createPlayers(
      playerDeckCards,
      gameStateService,
      cardSelectionService,
    );

    // Create player statistics for UI components
    final playersModel = PlayersModel(players: _createPlayerStats(players));

    // Create player turn state with all necessary models
    final playerTurnState = createPlayerTurnState(
      players.first,
      playersModel,
      enemyCards,
      shopCards,
    );

    // Create player turn coordinator to manage turn logic  
    final playerTurn = PlayerTurnCoordinator(
      state: playerTurnState,
      gameStateService: gameStateService,
    );

    // Create enemy turn area
    final enemyTurnArea = EnemyTurnCoordinator(
      enemyCards: CardsModel<CardModel>(cards: enemyCards),
      playersModel: playersModel,
      gameStateService: gameStateService,
    );

    return GameStateComponents(
      playerTurn: playerTurn,
      enemyTurnArea: enemyTurnArea,
      selectedPlayer: players.first,
      allPlayers: players,
    );
  }

  /// Creates default test data when no specific cards are provided
  /// This separates test data creation from the main initialization logic
  GameStateComponents createDefaultGameState() {
    final shopCards = _createDefaultShopCards();
    final playerDeckCards = _createDefaultPlayerCards();
    final enemyCards = _createDefaultEnemyCards();

    return createGameState(shopCards, playerDeckCards, enemyCards);
  }

  List<PlayerCoordinator> _createPlayers(
    List<CardModel> playerDeckCards,
    DefaultGameStateService gameStateService,
    DefaultCardSelectionService cardSelectionService,
  ) {
    return List.generate(_numberOfPlayers, (index) {
      final playerNumber = index + 1;
      // Create a new copy of the card list for each player to avoid shared references
      final playerDeckCopy = List<CardModel>.from(playerDeckCards.map((card) => card.copy()));
      return PlayerCoordinator.create(
        state: PlayerModel.create(
          infoModel: InfoModel(
            name: 'Player $playerNumber',
            attack: ValueImageLabelModel(value: 0, label: 'Attack'),
            credits: ValueImageLabelModel(value: 0, label: 'Credits'),
            healthModel: HealthModel(maxHealth: _playerMaxHealth),
          ),
          handModel: CardsModel<CardModel>(),
          deckModel: CardsModel<CardModel>(cards: playerDeckCopy),
          discardModel: CardsModel<CardModel>.empty(),
          gameStateService: gameStateService,
          cardSelectionService: cardSelectionService,
        ),
      );
    });
  }

  List<PlayerStatsModel> _createPlayerStats(List<PlayerCoordinator> players) {
    return players.map((player) {
      return PlayerStatsModel(
        name: player.infoModel.name,
        health: player.infoModel.healthModel,
        isActive: player == players.first,
      );
    }).toList();
  }

  PlayerTurnModel createPlayerTurnState(
    PlayerCoordinator activePlayer,
    PlayersModel playersModel,
    List<CardModel> enemyCards,
    List<ShopCardModel> shopCards,
  ) {
    return PlayerTurnModel(
      playerModel: activePlayer,
      teamModel: TeamModel(
        bases: BasesModel(
          bases: _createBases(),
        ),
        playersModel: playersModel,
      ),
      enemiesModel: EnemiesModel(
        totalEnemies: _totalEnemies,
        maxNumberOfEnemiesInPlay: _maxEnemiesInPlay,
        maxEnemyHealth: _maxEnemyHealth,
        enemyCards: enemyCards,
      ),
      shopModel: ShopCoordinator.create(
        numberOfRows: _shopRows,
        numberOfColumns: _shopColumns,
        cards: shopCards,
      ),
    );
  }

  List<BaseModel> _createBases() {
    return List.generate(_numberOfBases, (index) {
      final baseNumber = index + 1;
      return BaseModel(
        name: 'Base $baseNumber',
        maxHealth: _baseMaxHealth,
      );
    });
  }

  List<ShopCardModel> _createDefaultShopCards() {
    return List.generate(10, (index) {
      return ShopCardModel(
        name: 'Test Card ${index + 1}',
        cost: 1,
      );
    });
  }

  List<CardModel> _createDefaultPlayerCards() {
    return List.generate(10, (index) {
      return CardModel(
        name: 'Card ${index + 1}',
        type: 'Player',
        isFaceUp: false,
      );
    });
  }

  List<CardModel> _createDefaultEnemyCards() {
    return List.generate(10, (index) {
      return CardModel(
        name: 'Enemy Card ${index + 1}',
        type: 'Enemy',
        isFaceUp: false,
      );
    });
  }
}

/// Data class that holds all the components created by the factory
/// This separates the concerns of component storage from creation logic
class GameStateComponents {
  final PlayerTurnCoordinator playerTurn;
  final EnemyTurnCoordinator enemyTurnArea;
  final PlayerCoordinator? selectedPlayer;
  final List<PlayerCoordinator> allPlayers;

  const GameStateComponents({
    required this.playerTurn,
    required this.enemyTurnArea,
    required this.selectedPlayer,
    required this.allPlayers,
  });
}