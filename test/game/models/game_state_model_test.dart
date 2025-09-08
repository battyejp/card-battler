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
        
        GameStateModel.initialize(shopCards, playerDeckCards, enemyCards);

        expect(GameStateModel.instance, isNotNull);
        expect(GameStateModel.instance.enemyTurnArea, isNotNull);
        expect(GameStateModel.instance.playerTurn, isNotNull);
      });

      test('creates with empty shop cards', () {
        final shopCards = <ShopCardModel>[];
        final playerDeckCards = _generatePlayerDeckCards();
        final enemyCards = _generateEnemyCards();

        GameStateModel.initialize(shopCards, playerDeckCards, enemyCards);

        expect(GameStateModel.instance, isNotNull);
        expect(GameStateModel.instance.enemyTurnArea, isNotNull);
        expect(GameStateModel.instance.playerTurn, isNotNull);
      });

      test('creates with empty player deck cards', () {
        final shopCards = _generateShopCards();
        final playerDeckCards = <CardModel>[];
        final enemyCards = _generateEnemyCards();

        GameStateModel.initialize(shopCards, playerDeckCards, enemyCards);

        expect(GameStateModel.instance, isNotNull);
        expect(GameStateModel.instance.enemyTurnArea, isNotNull);
        expect(GameStateModel.instance.playerTurn, isNotNull);
      });

      test('creates with empty enemy cards', () {
        final shopCards = _generateShopCards();
        final playerDeckCards = _generatePlayerDeckCards();
        final enemyCards = <CardModel>[];

        GameStateModel.initialize(shopCards, playerDeckCards, enemyCards);

        expect(GameStateModel.instance, isNotNull);
        expect(GameStateModel.instance.enemyTurnArea, isNotNull);
        expect(GameStateModel.instance.playerTurn, isNotNull);
      });
    });

    group('enemy turn area validation', () {
      test('enemy turn area has correct enemy cards', () {
        final shopCards = _generateShopCards();
        final playerDeckCards = _generatePlayerDeckCards();
        final enemyCards = _generateEnemyCards();

        GameStateModel.initialize(shopCards, playerDeckCards, enemyCards);

        expect(GameStateModel.instance.enemyTurnArea.enemyCards, isNotNull);
        expect(GameStateModel.instance.enemyTurnArea.enemyCards.allCards.length, equals(enemyCards.length));
      });

      test('enemy turn area has player stats', () {
        final shopCards = _generateShopCards();
        final playerDeckCards = _generatePlayerDeckCards();
        final enemyCards = _generateEnemyCards();

        GameStateModel.initialize(shopCards, playerDeckCards, enemyCards);

        expect(GameStateModel.instance.enemyTurnArea.playersModel.players, isNotNull);
        expect(GameStateModel.instance.enemyTurnArea.playersModel.players.length, equals(2)); // 2 players created
      });

      test('enemy turn area initializes with empty played cards', () {
        final shopCards = _generateShopCards();
        final playerDeckCards = _generatePlayerDeckCards();
        final enemyCards = _generateEnemyCards();

        GameStateModel.initialize(shopCards, playerDeckCards, enemyCards);

        expect(GameStateModel.instance.enemyTurnArea.playedCards, isNotNull);
        expect(GameStateModel.instance.enemyTurnArea.playedCards.hasNoCards, isTrue);
      });
    });

    group('player turn validation', () {
      test('player turn has correct player model', () {
        final shopCards = _generateShopCards();
        final playerDeckCards = _generatePlayerDeckCards();
        final enemyCards = _generateEnemyCards();

        GameStateModel.initialize(shopCards, playerDeckCards, enemyCards);

        expect(GameStateModel.instance.playerTurn.playerModel, isNotNull);
        expect(GameStateModel.instance.playerTurn.playerModel.infoModel.name, equals('Player 1'));
      });

      test('player turn has team model with correct players', () {
        final shopCards = _generateShopCards();
        final playerDeckCards = _generatePlayerDeckCards();
        final enemyCards = _generateEnemyCards();

        GameStateModel.initialize(shopCards, playerDeckCards, enemyCards);

        expect(GameStateModel.instance.playerTurn.teamModel, isNotNull);
        expect(GameStateModel.instance.playerTurn.teamModel.playersModel.players.length, equals(2));
        expect(GameStateModel.instance.playerTurn.teamModel.playersModel.players[0].name, equals('Player 1'));
        expect(GameStateModel.instance.playerTurn.teamModel.playersModel.players[0].isActive, isTrue);
      });

      test('player turn has team model with correct bases', () {
        final shopCards = _generateShopCards();
        final playerDeckCards = _generatePlayerDeckCards();
        final enemyCards = _generateEnemyCards();

        GameStateModel.initialize(shopCards, playerDeckCards, enemyCards);

        expect(GameStateModel.instance.playerTurn.teamModel.bases, isNotNull);
        expect(GameStateModel.instance.playerTurn.teamModel.bases.allBases.length, equals(3));
        expect(GameStateModel.instance.playerTurn.teamModel.bases.allBases[0].name, equals('Base 1'));
        expect(GameStateModel.instance.playerTurn.teamModel.bases.allBases[0].healthDisplay, equals('5/5'));
      });

      test('player turn has enemies model', () {
        final shopCards = _generateShopCards();
        final playerDeckCards = _generatePlayerDeckCards();
        final enemyCards = _generateEnemyCards();

        GameStateModel.initialize(shopCards, playerDeckCards, enemyCards);

        expect(GameStateModel.instance.playerTurn.enemiesModel, isNotNull);
        expect(GameStateModel.instance.playerTurn.enemiesModel.allEnemies.length, equals(4));
        expect(GameStateModel.instance.playerTurn.enemiesModel.maxNumberOfEnemiesInPlay, equals(3));
      });

      test('player turn has shop model', () {
        final shopCards = _generateShopCards();
        final playerDeckCards = _generatePlayerDeckCards();
        final enemyCards = _generateEnemyCards();

        GameStateModel.initialize(shopCards, playerDeckCards, enemyCards);

        expect(GameStateModel.instance.playerTurn.shopModel, isNotNull);
        expect(GameStateModel.instance.playerTurn.shopModel.numberOfRows, equals(2));
        expect(GameStateModel.instance.playerTurn.shopModel.numberOfColumns, equals(3));
        expect(GameStateModel.instance.playerTurn.shopModel.selectableCards.length, equals(shopCards.length));
      });
    });

    group('player model validation', () {
      test('all players have correct initial health', () {
        final shopCards = _generateShopCards();
        final playerDeckCards = _generatePlayerDeckCards();
        final enemyCards = _generateEnemyCards();

        GameStateModel.initialize(shopCards, playerDeckCards, enemyCards);

        final playerStats = GameStateModel.instance.enemyTurnArea.playersModel.players;
        for (final player in playerStats) {
          expect(player.health.maxHealth, equals(10));
          expect(player.health.currentHealth, equals(10));
        }
      });

      test('only first player is active', () {
        final shopCards = _generateShopCards();
        final playerDeckCards = _generatePlayerDeckCards();
        final enemyCards = _generateEnemyCards();

        GameStateModel.initialize(shopCards, playerDeckCards, enemyCards);

        final playerStats = GameStateModel.instance.enemyTurnArea.playersModel.players;
        expect(playerStats[0].isActive, isTrue);
        expect(playerStats[1].isActive, isFalse);
      });

      test('players have correct names', () {
        final shopCards = _generateShopCards();
        final playerDeckCards = _generatePlayerDeckCards();
        final enemyCards = _generateEnemyCards();

        GameStateModel.initialize(shopCards, playerDeckCards, enemyCards);

        final playerStats = GameStateModel.instance.enemyTurnArea.playersModel.players;
        expect(playerStats[0].name, equals('Player 1'));
        expect(playerStats[1].name, equals('Player 2'));
      });
    });

    group('card distribution validation', () {
      test('player deck cards are distributed to all players', () {
        final shopCards = _generateShopCards();
        final playerDeckCards = _generatePlayerDeckCards();
        final enemyCards = _generateEnemyCards();

        GameStateModel.initialize(shopCards, playerDeckCards, enemyCards);

        // Note: All players get the same deck cards reference in the current implementation
        final firstPlayerDeck = GameStateModel.instance.playerTurn.playerModel.deckCards;
        expect(firstPlayerDeck.allCards.length, equals(playerDeckCards.length));
      });

      test('enemy cards are properly distributed', () {
        final shopCards = _generateShopCards();
        final playerDeckCards = _generatePlayerDeckCards();
        final enemyCards = _generateEnemyCards();

        GameStateModel.initialize(shopCards, playerDeckCards, enemyCards);

        // Enemy cards should be in enemyTurnArea
        expect(GameStateModel.instance.enemyTurnArea.enemyCards.allCards.length, equals(enemyCards.length));
      });

      test('shop cards are properly assigned', () {
        final shopCards = _generateShopCards();
        final playerDeckCards = _generatePlayerDeckCards();
        final enemyCards = _generateEnemyCards();

        GameStateModel.initialize(shopCards, playerDeckCards, enemyCards);

        final selectableCards = GameStateModel.instance.playerTurn.shopModel.selectableCards;
        
        // Verify we have the expected number of selectable cards (6 for 2x3 shop)
        expect(selectableCards.length, equals(6));
        
        // Verify all selectable cards are from the original set (cards are now shuffled)
        final originalNames = shopCards.map((c) => c.name).toSet();
        final selectableNames = selectableCards.map((c) => c.name).toSet();
        expect(selectableNames.difference(originalNames), isEmpty);
        
        // Verify all selectable cards have valid properties
        for (final card in selectableCards) {
          expect(card.name, isNotNull);
          expect(card.cost, greaterThanOrEqualTo(0));
        }
      });
    });

    group('model consistency validation', () {
      test('player stats in enemy turn area match team model players', () {
        final shopCards = _generateShopCards();
        final playerDeckCards = _generatePlayerDeckCards();
        final enemyCards = _generateEnemyCards();

        GameStateModel.initialize(shopCards, playerDeckCards, enemyCards);

        final enemyAreaPlayers = GameStateModel.instance.enemyTurnArea.playersModel.players;
        final teamPlayers = GameStateModel.instance.playerTurn.teamModel.playersModel.players;

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

        GameStateModel.initialize(shopCards, playerDeckCards, enemyCards);

        expect(GameStateModel.instance, isNotNull);
        expect(GameStateModel.instance.enemyTurnArea.enemyCards.allCards, isEmpty);
        expect(GameStateModel.instance.playerTurn.shopModel.selectableCards, isEmpty);
      });
    });
  });
}
