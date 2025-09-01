import 'package:flutter_test/flutter_test.dart';
import 'package:card_battler/game/models/game_state_model.dart';
import 'package:card_battler/game/models/shop/shop_card_model.dart';
import 'package:card_battler/game/models/shared/card_model.dart';

List<CardModel> _generatePlayerDeckCards() {
  return List.generate(20, (index) => CardModel(
    name: 'Player Card ${index + 1}',
    type: 'Player',
    isFaceUp: false,
  ));
}

List<CardModel> _generateEnemyCards() {
  return List.generate(10, (index) => CardModel(
    name: 'Enemy Card ${index + 1}',
    type: 'Enemy',
    isFaceUp: false,
    effects: [
      EffectModel(
        type: EffectType.attack,
        target: EffectTarget.activePlayer,
        value: 1,
      ),
    ],
  ));
}

List<ShopCardModel> _generateShopCards() {
  return List.generate(6, (index) => ShopCardModel(
    name: 'Shop Card ${index + 1}',
    cost: index + 1,
    isFaceUp: true,
  ));
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('GameStateModel', () {
    group('constructor and initialization', () {
      test('creates new game with required parameters', () {
        final shopCards = _generateShopCards();
        final playerDeckCards = _generatePlayerDeckCards();
        final enemyCards = _generateEnemyCards();
        
        final gameState = GameStateModel.newGame(shopCards, playerDeckCards, enemyCards);
        
        expect(gameState, isNotNull);
        expect(gameState.enemyTurnArea, isNotNull);
        expect(gameState.playerTurn, isNotNull);
      });

      test('creates with empty shop cards', () {
        final shopCards = <ShopCardModel>[];
        final playerDeckCards = _generatePlayerDeckCards();
        final enemyCards = _generateEnemyCards();
        
        final gameState = GameStateModel.newGame(shopCards, playerDeckCards, enemyCards);
        
        expect(gameState, isNotNull);
        expect(gameState.enemyTurnArea, isNotNull);
        expect(gameState.playerTurn, isNotNull);
      });

      test('creates with empty player deck cards', () {
        final shopCards = _generateShopCards();
        final playerDeckCards = <CardModel>[];
        final enemyCards = _generateEnemyCards();
        
        final gameState = GameStateModel.newGame(shopCards, playerDeckCards, enemyCards);
        
        expect(gameState, isNotNull);
        expect(gameState.enemyTurnArea, isNotNull);
        expect(gameState.playerTurn, isNotNull);
      });

      test('creates with empty enemy cards', () {
        final shopCards = _generateShopCards();
        final playerDeckCards = _generatePlayerDeckCards();
        final enemyCards = <CardModel>[];
        
        final gameState = GameStateModel.newGame(shopCards, playerDeckCards, enemyCards);
        
        expect(gameState, isNotNull);
        expect(gameState.enemyTurnArea, isNotNull);
        expect(gameState.playerTurn, isNotNull);
      });
    });

    group('enemy turn area validation', () {
      test('enemy turn area has correct enemy cards', () {
        final shopCards = _generateShopCards();
        final playerDeckCards = _generatePlayerDeckCards();
        final enemyCards = _generateEnemyCards();
        
        final gameState = GameStateModel.newGame(shopCards, playerDeckCards, enemyCards);
        
        expect(gameState.enemyTurnArea.enemyCards, isNotNull);
        expect(gameState.enemyTurnArea.enemyCards.allCards.length, equals(enemyCards.length));
      });

      test('enemy turn area has player stats', () {
        final shopCards = _generateShopCards();
        final playerDeckCards = _generatePlayerDeckCards();
        final enemyCards = _generateEnemyCards();
        
        final gameState = GameStateModel.newGame(shopCards, playerDeckCards, enemyCards);
        
        expect(gameState.enemyTurnArea.playerStats, isNotNull);
        expect(gameState.enemyTurnArea.playerStats.length, equals(4)); // 4 players created
      });

      test('enemy turn area initializes with empty played cards', () {
        final shopCards = _generateShopCards();
        final playerDeckCards = _generatePlayerDeckCards();
        final enemyCards = _generateEnemyCards();
        
        final gameState = GameStateModel.newGame(shopCards, playerDeckCards, enemyCards);
        
        expect(gameState.enemyTurnArea.playedCards, isNotNull);
        expect(gameState.enemyTurnArea.playedCards.hasNoCards, isTrue);
      });

      test('enemy turn area starts with turn not finished', () {
        final shopCards = _generateShopCards();
        final playerDeckCards = _generatePlayerDeckCards();
        final enemyCards = _generateEnemyCards();
        
        final gameState = GameStateModel.newGame(shopCards, playerDeckCards, enemyCards);
        
        expect(gameState.enemyTurnArea.turnFinished, isFalse);
      });
    });

    group('player turn validation', () {
      test('player turn has correct player model', () {
        final shopCards = _generateShopCards();
        final playerDeckCards = _generatePlayerDeckCards();
        final enemyCards = _generateEnemyCards();
        
        final gameState = GameStateModel.newGame(shopCards, playerDeckCards, enemyCards);
        
        expect(gameState.playerTurn.playerModel, isNotNull);
        expect(gameState.playerTurn.playerModel.infoModel.name, equals('Player 1'));
        expect(gameState.playerTurn.playerModel.infoModel.isActive, isTrue);
      });

      test('player turn has team model with correct players', () {
        final shopCards = _generateShopCards();
        final playerDeckCards = _generatePlayerDeckCards();
        final enemyCards = _generateEnemyCards();
        
        final gameState = GameStateModel.newGame(shopCards, playerDeckCards, enemyCards);
        
        expect(gameState.playerTurn.teamModel, isNotNull);
        expect(gameState.playerTurn.teamModel.players.length, equals(4));
        expect(gameState.playerTurn.teamModel.players[0].name, equals('Player 1'));
        expect(gameState.playerTurn.teamModel.players[0].isActive, isTrue);
      });

      test('player turn has team model with correct bases', () {
        final shopCards = _generateShopCards();
        final playerDeckCards = _generatePlayerDeckCards();
        final enemyCards = _generateEnemyCards();
        
        final gameState = GameStateModel.newGame(shopCards, playerDeckCards, enemyCards);
        
        expect(gameState.playerTurn.teamModel.bases, isNotNull);
        expect(gameState.playerTurn.teamModel.bases.allBases.length, equals(3));
        expect(gameState.playerTurn.teamModel.bases.allBases[0].name, equals('Base 1'));
        expect(gameState.playerTurn.teamModel.bases.allBases[0].healthDisplay, equals('5/5'));
      });

      test('player turn has enemies model', () {
        final shopCards = _generateShopCards();
        final playerDeckCards = _generatePlayerDeckCards();
        final enemyCards = _generateEnemyCards();
        
        final gameState = GameStateModel.newGame(shopCards, playerDeckCards, enemyCards);
        
        expect(gameState.playerTurn.enemiesModel, isNotNull);
        expect(gameState.playerTurn.enemiesModel.allEnemies.length, equals(4));
        expect(gameState.playerTurn.enemiesModel.maxNumberOfEnemiesInPlay, equals(3));
      });

      test('player turn has shop model', () {
        final shopCards = _generateShopCards();
        final playerDeckCards = _generatePlayerDeckCards();
        final enemyCards = _generateEnemyCards();
        
        final gameState = GameStateModel.newGame(shopCards, playerDeckCards, enemyCards);
        
        expect(gameState.playerTurn.shopModel, isNotNull);
        expect(gameState.playerTurn.shopModel.numberOfRows, equals(2));
        expect(gameState.playerTurn.shopModel.numberOfColumns, equals(3));
        expect(gameState.playerTurn.shopModel.selectableCards.length, equals(shopCards.length));
      });
    });

    group('player model validation', () {
      test('all players have correct initial health', () {
        final shopCards = _generateShopCards();
        final playerDeckCards = _generatePlayerDeckCards();
        final enemyCards = _generateEnemyCards();
        
        final gameState = GameStateModel.newGame(shopCards, playerDeckCards, enemyCards);
        
        final playerStats = gameState.enemyTurnArea.playerStats;
        for (final player in playerStats) {
          expect(player.health.maxHealth, equals(10));
          expect(player.health.currentHealth, equals(10));
        }
      });

      test('only first player is active', () {
        final shopCards = _generateShopCards();
        final playerDeckCards = _generatePlayerDeckCards();
        final enemyCards = _generateEnemyCards();
        
        final gameState = GameStateModel.newGame(shopCards, playerDeckCards, enemyCards);
        
        final playerStats = gameState.enemyTurnArea.playerStats;
        expect(playerStats[0].isActive, isTrue);
        expect(playerStats[1].isActive, isFalse);
        expect(playerStats[2].isActive, isFalse);
        expect(playerStats[3].isActive, isFalse);
      });

      test('players have correct names', () {
        final shopCards = _generateShopCards();
        final playerDeckCards = _generatePlayerDeckCards();
        final enemyCards = _generateEnemyCards();
        
        final gameState = GameStateModel.newGame(shopCards, playerDeckCards, enemyCards);
        
        final playerStats = gameState.enemyTurnArea.playerStats;
        expect(playerStats[0].name, equals('Player 1'));
        expect(playerStats[1].name, equals('Player 2'));
        expect(playerStats[2].name, equals('Player 3'));
        expect(playerStats[3].name, equals('Player 4'));
      });
    });

    group('card distribution validation', () {
      test('player deck cards are distributed to all players', () {
        final shopCards = _generateShopCards();
        final playerDeckCards = _generatePlayerDeckCards();
        final enemyCards = _generateEnemyCards();
        
        final gameState = GameStateModel.newGame(shopCards, playerDeckCards, enemyCards);
        
        // Note: All players get the same deck cards reference in the current implementation
        final firstPlayerDeck = gameState.playerTurn.playerModel.deckModel;
        expect(firstPlayerDeck.allCards.length, equals(playerDeckCards.length));
      });

      test('enemy cards are properly distributed', () {
        final shopCards = _generateShopCards();
        final playerDeckCards = _generatePlayerDeckCards();
        final enemyCards = _generateEnemyCards();
        
        final gameState = GameStateModel.newGame(shopCards, playerDeckCards, enemyCards);
        
        // Enemy cards should be in enemyTurnArea
        expect(gameState.enemyTurnArea.enemyCards.allCards.length, equals(enemyCards.length));
      });

      test('shop cards are properly assigned', () {
        final shopCards = _generateShopCards();
        final playerDeckCards = _generatePlayerDeckCards();
        final enemyCards = _generateEnemyCards();
        
        final gameState = GameStateModel.newGame(shopCards, playerDeckCards, enemyCards);
        
        expect(gameState.playerTurn.shopModel.selectableCards.length, equals(shopCards.length));
        for (int i = 0; i < shopCards.length; i++) {
          expect(gameState.playerTurn.shopModel.selectableCards[i].name, equals(shopCards[i].name));
          expect(gameState.playerTurn.shopModel.selectableCards[i].cost, equals(shopCards[i].cost));
        }
      });
    });

    group('model consistency validation', () {
      test('player stats in enemy turn area match team model players', () {
        final shopCards = _generateShopCards();
        final playerDeckCards = _generatePlayerDeckCards();
        final enemyCards = _generateEnemyCards();
        
        final gameState = GameStateModel.newGame(shopCards, playerDeckCards, enemyCards);
        
        final enemyAreaPlayers = gameState.enemyTurnArea.playerStats;
        final teamPlayers = gameState.playerTurn.teamModel.players;
        
        expect(enemyAreaPlayers.length, equals(teamPlayers.length));
        for (int i = 0; i < enemyAreaPlayers.length; i++) {
          expect(enemyAreaPlayers[i].name, equals(teamPlayers[i].name));
          expect(enemyAreaPlayers[i].isActive, equals(teamPlayers[i].isActive));
        }
      });

      test('empty inputs create valid game state', () {
        final shopCards = <ShopCardModel>[];
        final playerDeckCards = <CardModel>[];
        final enemyCards = <CardModel>[];
        
        final gameState = GameStateModel.newGame(shopCards, playerDeckCards, enemyCards);
        
        expect(gameState, isNotNull);
        expect(gameState.enemyTurnArea.enemyCards.allCards, isEmpty);
        expect(gameState.playerTurn.shopModel.selectableCards, isEmpty);
      });
    });
  });
}
