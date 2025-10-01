import 'package:card_battler/game/config/game_configuration.dart';
import 'package:card_battler/game/factories/game_state/player_factory.dart';
import 'package:card_battler/game/models/card/card_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PlayerFactory', () {
    late List<CardModel> testCards;
    late GameConfiguration testConfig;

    setUp(() {
      testCards = [
        CardModel(
          name: 'Test Card 1',
          description: 'Test Description 1',
          cost: 1,
          type: CardType.hero,
          filename: 'test_card_1.png',
          effects: [],
        ),
        CardModel(
          name: 'Test Card 2',
          description: 'Test Description 2',
          cost: 2,
          type: CardType.hero,
          filename: 'test_card_2.png',
          effects: [],
        ),
      ];
      testConfig = const GameConfiguration(
        numberOfPlayers: 3,
        defaultHealth: 15,
        playerStartingCredits: 5,
        playerStartingAttack: 2,
      );
    });

    group('createPlayers', () {
      test('creates the specified number of players', () {
        final players = PlayerFactory.createPlayers(
          count: 3,
          playerDeckCards: testCards,
          config: testConfig,
        );

        expect(players.length, equals(3));
      });

      test('creates players with correct initial values', () {
        final players = PlayerFactory.createPlayers(
          count: 2,
          playerDeckCards: testCards,
          config: testConfig,
        );

        for (var i = 0; i < players.length; i++) {
          final player = players[i];
          expect(player.name, equals('Player ${i + 1}'));
          expect(player.healthModel.currentHealth, equals(testConfig.defaultHealth));
          expect(player.healthModel.maxHealth, equals(testConfig.defaultHealth));
          expect(player.credits, equals(testConfig.playerStartingCredits));
          expect(player.attack, equals(testConfig.playerStartingAttack));
          expect(player.deckCards.allCards.length, equals(testCards.length));
        }
      });

      test('first player is active, others are not', () {
        final players = PlayerFactory.createPlayers(
          count: 3,
          playerDeckCards: testCards,
          config: testConfig,
        );

        expect(players[0].isActive, isTrue);
        expect(players[1].isActive, isFalse);
        expect(players[2].isActive, isFalse);
      });

      test('each player gets independent copy of deck', () {
        final players = PlayerFactory.createPlayers(
          count: 2,
          playerDeckCards: testCards,
          config: testConfig,
        );

        final player1Cards = players[0].deckCards.allCards;
        final player2Cards = players[1].deckCards.allCards;

        expect(identical(player1Cards, player2Cards), isFalse);
        expect(identical(player1Cards[0], player2Cards[0]), isFalse);
      });
    });

    group('createPlayer', () {
      test('creates a player with correct index-based name', () {
        final player = PlayerFactory.createPlayer(
          index: 2,
          playerDeckCards: testCards,
          config: testConfig,
        );

        expect(player.name, equals('Player 3'));
      });

      test('creates active player when index is 0', () {
        final player = PlayerFactory.createPlayer(
          index: 0,
          playerDeckCards: testCards,
          config: testConfig,
        );

        expect(player.isActive, isTrue);
      });

      test('creates inactive player when index is not 0', () {
        final player = PlayerFactory.createPlayer(
          index: 1,
          playerDeckCards: testCards,
          config: testConfig,
        );

        expect(player.isActive, isFalse);
      });

      test('creates player with empty hand and discard pile', () {
        final player = PlayerFactory.createPlayer(
          index: 0,
          playerDeckCards: testCards,
          config: testConfig,
        );

        expect(player.handCards.allCards, isEmpty);
        expect(player.discardCards.allCards, isEmpty);
      });

      test('creates player with copy of provided deck', () {
        final player = PlayerFactory.createPlayer(
          index: 0,
          playerDeckCards: testCards,
          config: testConfig,
        );

        expect(player.deckCards.allCards.length, equals(testCards.length));
        expect(identical(player.deckCards.allCards[0], testCards[0]), isFalse);
      });
    });
  });
}
