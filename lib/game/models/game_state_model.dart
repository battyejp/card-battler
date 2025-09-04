import 'package:card_battler/game/models/enemy/enemy_turn_area_model.dart';
import 'package:card_battler/game/models/player/info_model.dart';
import 'package:card_battler/game/models/player/card_hand_model.dart';
import 'package:card_battler/game/models/player/player_turn_model.dart';
import 'package:card_battler/game/models/shared/card_pile_model.dart';
import 'package:card_battler/game/models/enemy/enemies_model.dart';
import 'package:card_battler/game/models/player/player_model.dart';
import 'package:card_battler/game/models/shared/card_model.dart';
import 'package:card_battler/game/models/shared/health_model.dart';
import 'package:card_battler/game/models/team/base_model.dart';
import 'package:card_battler/game/models/team/player_stats_model.dart';
import 'package:card_battler/game/models/team/team_model.dart';
import 'package:card_battler/game/models/shop/shop_model.dart';
import 'package:card_battler/game/models/team/bases_model.dart';
import 'package:card_battler/game/models/shared/value_image_label_model.dart';
import 'package:card_battler/game/models/shop/shop_card_model.dart';

/// Represents the different phases of the game
enum GamePhase { setup, enemyTurn, playerTurn }

/// Centralized model that contains all game state
/// This serves as the single source of truth for the entire game
class GameStateModel {
  static GameStateModel? _instance;
  
  final EnemyTurnAreaModel enemyTurnArea;
  final PlayerTurnModel playerTurn;
  PlayerModel? selectedPlayer;
  GamePhase currentPhase = GamePhase.setup;

  GameStateModel._({
    required this.enemyTurnArea,
    required this.playerTurn,
  });

  /// Gets the singleton instance of GameStateModel
  static GameStateModel get instance {
    if (_instance == null) {
      var shopCards = List.generate(
          10,
          (index) => ShopCardModel(name: 'Test Card ${index + 1}', cost: 1),
        );

      var playerDeckCards = List.generate(
          10,
          (index) => CardModel(
            name: 'Card ${index + 1}',
            type: 'Player',
            isFaceUp: false,
          ),
        );

        var enemyCards = List.generate(
          10,
          (index) => CardModel(
            name: 'Enemy Card ${index + 1}',
            type: 'Enemy',
            isFaceUp: false,
          ),
        );

      _instance = GameStateModel._newGame(shopCards, playerDeckCards, enemyCards);
    }
    return _instance!;
  }

  /// Initializes the singleton instance with a new game
  static GameStateModel initialize(List<ShopCardModel> shopCards, List<CardModel> playerDeckCards, List<CardModel> enemyCards) {
    _instance = GameStateModel._newGame(shopCards, playerDeckCards, enemyCards);
    return _instance!;
  }

  /// Resets the singleton instance (useful for testing or starting a new game)
  static void reset() {
    _instance = null;
  }

  /// Creates a new game with default starting values
  static GameStateModel _newGame(List<ShopCardModel> shopCards, List<CardModel> playerDeckCards, List<CardModel> enemyCards) {
    final players = <PlayerModel>[
      PlayerModel(
        infoModel: InfoModel(
          name: 'Player 1',
          attack: ValueImageLabelModel(value: 0, label: 'Attack'),
          credits: ValueImageLabelModel(value: 0, label: 'Credits'),
          healthModel: HealthModel(maxHealth: 10),
          isActive: true,
        ),
        handModel: CardHandModel(),
        deckModel: CardPileModel(cards: playerDeckCards),
        discardModel: CardPileModel.empty(),
      ),
      PlayerModel(
        infoModel: InfoModel(
          name: 'Player 2',
          attack: ValueImageLabelModel(value: 0, label: 'Attack'),
          credits: ValueImageLabelModel(value: 0, label: 'Credits'),
          healthModel: HealthModel(maxHealth: 10),
        ),
        handModel: CardHandModel(),
        deckModel: CardPileModel(cards: playerDeckCards),
        discardModel: CardPileModel.empty(),
      ),
      PlayerModel(
        infoModel: InfoModel(
          name: 'Player 3',
          attack: ValueImageLabelModel(value: 0, label: 'Attack'),
          credits: ValueImageLabelModel(value: 0, label: 'Credits'),
          healthModel: HealthModel(maxHealth: 10),
        ),
        handModel: CardHandModel(),
        deckModel: CardPileModel(cards: playerDeckCards),
        discardModel: CardPileModel.empty(),
      ),
      PlayerModel(
        infoModel: InfoModel(
          name: 'Player 4',
          attack: ValueImageLabelModel(value: 0, label: 'Attack'),
          credits: ValueImageLabelModel(value: 0, label: 'Credits'),
          healthModel: HealthModel(maxHealth: 10),
        ),
        handModel: CardHandModel(),
        deckModel: CardPileModel(cards: playerDeckCards),
        discardModel: CardPileModel.empty(),
      ),
    ];

    final playerStats = players.map((player) {
      return PlayerStatsModel(
        name: player.infoModel.name,
        health: player.infoModel.healthModel,
        isActive: player.infoModel.isActive,
      );
    }).toList();

    return GameStateModel._(
      playerTurn: PlayerTurnModel(
        playerModel: players.first,
        teamModel: TeamModel(
          bases: BasesModel(
            bases: [
              BaseModel(name: 'Base 1', maxHealth: 5),
              BaseModel(name: 'Base 2', maxHealth: 5),
              BaseModel(name: 'Base 3', maxHealth: 5),
            ],
          ),
          players: playerStats,
        ),
        enemiesModel: EnemiesModel(
          totalEnemies: 4,
          maxNumberOfEnemiesInPlay: 3,
          maxEnemyHealth: 5,
          enemyCards: enemyCards,
        ),
        shopModel: ShopModel(numberOfRows: 2, numberOfColumns: 3, cards: shopCards),
      ),
      enemyTurnArea: EnemyTurnAreaModel(
        enemyCards: CardPileModel(cards: enemyCards),
        playerStats: playerStats,
      )
    );
  }

  /// Serializes the entire game state to JSON for save/load functionality
  // Map<String, dynamic> toJson() {
  //   return {
  //     'playerInfo': playerInfo.toJson(),
  //     'playerHand': playerHand.toJson(),
  //     'playerDeck': playerDeck.toJson(),
  //     'playerDiscard': playerDiscard.toJson(),
  //     'enemies': enemies.toJson(),
  //     'shop': shop.toJson(),
  //     'bases': bases.toJson()
  //   };
  // }

  /// Creates a GameStateModel from JSON data for load functionality
  // factory GameStateModel.fromJson(Map<String, dynamic> json) {
  //   try {
  //     return GameStateModel(
  //       playerInfo: InfoModel.fromJson(json['playerInfo'] ?? {}),
  //       playerHand: CardHandModel.fromJson(json['playerHand'] ?? {}),
  //       playerDeck: CardPileModel.fromJson(json['playerDeck'] ?? {}),
  //       playerDiscard: CardPileModel.fromJson(json['playerDiscard'] ?? {}),
  //       enemies: EnemiesModel.fromJson(json['enemies'] ?? {}),
  //       shop: ShopModel.fromJson(json['shop'] ?? {}),
  //       bases: BasesModel.fromJson(json['bases'] ?? {}),
  //     );
  //   } catch (e) {
  //     // If JSON parsing fails, return a new game
  //     return GameStateModel.newGame();
  //   }
  // }

  /// Advances to the next game phase
  // void nextPhase() {
  //   switch (currentPhase) {
  //     case GamePhase.setup:
  //       currentPhase = GamePhase.playerTurn;
  //       break;
  //     case GamePhase.playerTurn:
  //       currentPhase = GamePhase.enemyTurn;
  //       isPlayerTurn = false;
  //       break;
  //     case GamePhase.enemyTurn:
  //       currentPhase = GamePhase.shopping;
  //       break;
  //     case GamePhase.shopping:
  //       currentPhase = GamePhase.battleEnd;
  //       break;
  //     case GamePhase.battleEnd:
  //       break;
  //     case GamePhase.gameOver:
  //       // Game is over, no next phase
  //       break;
  //   }
  // }

  /// Gets a summary of the current game state for debugging
  //   String get gameStateDebugInfo {
  //     return '''
  // Game State Debug Info:
  // - Player Health: ${playerInfo.health.value}
  // - Player Attack: ${playerInfo.attack.value}
  // - Player Credits: ${playerInfo.credits.value}
  // - Cards in Hand: ${playerHand.cards.length}
  // - Cards in Deck: ${playerDeck.allCards.length}
  // - Cards in Discard: ${playerDiscard.allCards.length}
  // - Enemies Remaining: ${enemies.aliveEnemies.length}/${enemies.allEnemies.length}
  // ''';
  //   }
}
