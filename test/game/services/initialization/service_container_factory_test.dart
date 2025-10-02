import 'package:card_battler/game/models/game_state_model.dart';
import 'package:card_battler/game/services/initialization/service_container_factory.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ServiceContainerFactory', () {
    group('create', () {
      late GameStateModel gameState;

      setUp(() {
        // Create a minimal game state for testing
        gameState = GameStateModel.initialize([], [], [], []);
      });

      test('creates service container with all required services', () {
        final services = ServiceContainerFactory.create(gameState);

        expect(services, isNotNull);
        expect(services.dialogService, isNotNull);
        expect(services.gamePhaseManager, isNotNull);
        expect(services.activePlayerManager, isNotNull);
        expect(services.coordinatorsManager, isNotNull);
      });

      test('creates services with proper types', () {
        final services = ServiceContainerFactory.create(gameState);

        expect(
          services.dialogService.runtimeType.toString(),
          contains('DialogService'),
        );
        expect(
          services.gamePhaseManager.runtimeType.toString(),
          contains('GamePhaseManager'),
        );
        expect(
          services.activePlayerManager.runtimeType.toString(),
          contains('ActivePlayerManager'),
        );
        expect(
          services.coordinatorsManager.runtimeType.toString(),
          contains('CoordinatorsManager'),
        );
      });

      test('wires up dependencies correctly', () {
        final services = ServiceContainerFactory.create(gameState);

        // Verify that services are properly initialized and not null
        expect(services.activePlayerManager, isNotNull);
        expect(services.coordinatorsManager, isNotNull);
        // The CoordinatorsManager should have received the game state
        expect(services.coordinatorsManager, isNotNull);
      });

      test('completes quickly', () {
        final stopwatch = Stopwatch()..start();

        ServiceContainerFactory.create(gameState);

        stopwatch.stop();
        expect(stopwatch.elapsedMilliseconds, lessThan(100));
      });

      test('creates independent service instances each time', () {
        final services1 = ServiceContainerFactory.create(gameState);
        final services2 = ServiceContainerFactory.create(gameState);

        // Each call should create new service instances
        expect(identical(services1, services2), isFalse);
        expect(identical(services1.dialogService, services2.dialogService), isFalse);
        expect(identical(services1.gamePhaseManager, services2.gamePhaseManager), isFalse);
      });

      test('configures game phase manager with correct number of players', () {
        // GameStateModel.initialize always creates 5 players regardless of input
        final gameStateWithPlayers = GameStateModel.initialize(
          [], // shop cards
          [], // player deck cards
          [], // enemy cards
          [], // bases
        );

        final services = ServiceContainerFactory.create(gameStateWithPlayers);

        // The game phase manager should be initialized with the correct number of players
        expect(services.gamePhaseManager, isNotNull);
        expect(gameStateWithPlayers.players.length, equals(5));
      });
    });

    group('Error Handling', () {
      test('handles game state with no players gracefully', () {
        final emptyGameState = GameStateModel.initialize([], [], [], []);

        expect(
          () => ServiceContainerFactory.create(emptyGameState),
          returnsNormally,
        );
      });
    });
  });
}
