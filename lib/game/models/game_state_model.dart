import 'package:card_battler/game/models/player/info_model.dart';
import 'package:card_battler/game/models/player/card_hand_model.dart';
import 'package:card_battler/game/models/player/card_pile_model.dart';
import 'package:card_battler/game/models/enemy/enemies_model.dart';
import 'package:card_battler/game/models/player/player_model.dart';
import 'package:card_battler/game/models/ui/shop_model.dart';
import 'package:card_battler/game/models/team/bases_model.dart';
import 'package:card_battler/game/models/shared/value_image_label_model.dart';

/// Represents the different phases of the game
enum GamePhase { setup, playerTurn, enemyTurn, shopping, battleEnd, gameOver }

/// Centralized model that contains all game state
/// This serves as the single source of truth for the entire game
class GameStateModel {
  // Player-related state
  final PlayerModel player;

  // Enemy state
  final EnemiesModel enemies;

  // Shop state
  final ShopModel shop;

  // Team state
  final BasesModel bases;

  GameStateModel({
    required this.player,
    required this.enemies,
    required this.shop,
    required this.bases,
  });

  /// Creates a new game with default starting values
  factory GameStateModel.newGame() {
    return GameStateModel(
      player: PlayerModel(
        infoModel: InfoModel(
          health: ValueImageLabelModel(value: 100, label: 'Health'),
          attack: ValueImageLabelModel(value: 10, label: 'Attack'),
          credits: ValueImageLabelModel(value: 50, label: 'Credits'),
        ),
        handModel: CardHandModel(),
        deckModel: CardPileModel(numberOfCards: 20),
        discardModel: CardPileModel.empty(),
      ),
      enemies: EnemiesModel(totalEnemies: 4, enemyMaxHealth: 5),
      shop: ShopModel(),
      bases: BasesModel(totalBases: 4),
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
