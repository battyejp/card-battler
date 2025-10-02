import 'package:card_battler/game/services/initialization/game_state_factory.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('GameStateFactory', () {
    group('create', () {
      test('loads game state with required card types', () async {
        final gameState = await GameStateFactory.create();

        expect(gameState, isNotNull);
        expect(gameState.shop, isNotNull);
        expect(gameState.players, isNotNull);
        expect(gameState.bases, isNotNull);
        expect(gameState.enemiesModel, isNotNull);
      });

      test('creates game state with multiple players', () async {
        final gameState = await GameStateFactory.create();

        expect(gameState.players, isNotEmpty);
        expect(gameState.players.length, greaterThan(0));
      });

      test('initializes shop with cards', () async {
        final gameState = await GameStateFactory.create();

        expect(gameState.shop.inventoryCards.allCards, isNotEmpty);
      });

      test('initializes players with starting deck', () async {
        final gameState = await GameStateFactory.create();

        for (final player in gameState.players) {
          expect(player.deckCards.allCards, isNotEmpty);
        }
      });

      test('initializes enemies with cards', () async {
        final gameState = await GameStateFactory.create();

        expect(gameState.enemiesModel.enemies, isNotEmpty);
        expect(gameState.enemiesModel.deckCards.allCards, isNotEmpty);
      });

      test('completes within reasonable time', () async {
        final stopwatch = Stopwatch()..start();

        await GameStateFactory.create();

        stopwatch.stop();
        expect(stopwatch.elapsedMilliseconds, lessThan(3000)); // 3 seconds max
      });

      test('creates independent game state instances', () async {
        final gameState1 = await GameStateFactory.create();
        final gameState2 = await GameStateFactory.create();

        expect(identical(gameState1, gameState2), isFalse);
        expect(gameState1.players.length, equals(gameState2.players.length));
      });
    });

    group('Error Handling', () {
      test('handles asset loading gracefully', () async {
        try {
          await GameStateFactory.create();
        } catch (e) {
          fail('GameStateFactory.create() should not throw during normal operation: $e');
        }
      });
    });
  });
}
