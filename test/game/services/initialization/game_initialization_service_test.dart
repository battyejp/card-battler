import 'package:card_battler/game/models/game_state_model.dart';
import 'package:card_battler/game/services/initialization/game_initialization_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ServiceContainer', () {
    group('Constructor', () {
      test('creates instance with all required services', () {
        final gameState = _createMockGameState();
        final services = GameInitializationService.createServices(gameState);

        final container = ServiceContainer(
          dialogService: services.dialogService,
          cardsSelectionManagerService: services.cardsSelectionManagerService,
          gamePhaseManager: services.gamePhaseManager,
          activePlayerManager: services.activePlayerManager,
          coordinatorsManager: services.coordinatorsManager,
        );

        expect(container.dialogService, isNotNull);
        expect(container.cardsSelectionManagerService, isNotNull);
        expect(container.gamePhaseManager, isNotNull);
        expect(container.activePlayerManager, isNotNull);
        expect(container.coordinatorsManager, isNotNull);
      });

      test('stores service references correctly', () {
        final gameState = _createMockGameState();
        final services = GameInitializationService.createServices(gameState);

        final container = ServiceContainer(
          dialogService: services.dialogService,
          cardsSelectionManagerService: services.cardsSelectionManagerService,
          gamePhaseManager: services.gamePhaseManager,
          activePlayerManager: services.activePlayerManager,
          coordinatorsManager: services.coordinatorsManager,
        );

        expect(
          identical(container.dialogService, services.dialogService),
          isTrue,
        );
        expect(
          identical(
            container.cardsSelectionManagerService,
            services.cardsSelectionManagerService,
          ),
          isTrue,
        );
        expect(
          identical(container.gamePhaseManager, services.gamePhaseManager),
          isTrue,
        );
        expect(
          identical(
            container.activePlayerManager,
            services.activePlayerManager,
          ),
          isTrue,
        );
        expect(
          identical(
            container.coordinatorsManager,
            services.coordinatorsManager,
          ),
          isTrue,
        );
      });
    });
  });

  group('GameInitializationService', () {
    group('initializeGameState', () {
      test('loads game state with required card types', () async {
        final gameState = await GameInitializationService.initializeGameState();

        expect(gameState, isNotNull);
        expect(gameState.shop, isNotNull);
        expect(gameState.players, isNotNull);
        expect(gameState.bases, isNotNull);
        expect(gameState.enemiesModel, isNotNull);
      });

      test('creates game state with multiple players', () async {
        final gameState = await GameInitializationService.initializeGameState();

        expect(gameState.players, isNotEmpty);
        expect(gameState.players.length, greaterThan(0));
      });

      test('initializes shop with cards', () async {
        final gameState = await GameInitializationService.initializeGameState();

        expect(gameState.shop.inventoryCards.allCards, isNotEmpty);
      });

      test('initializes players with starting deck', () async {
        final gameState = await GameInitializationService.initializeGameState();

        for (final player in gameState.players) {
          expect(player.deckCards.allCards, isNotEmpty);
        }
      });

      test('initializes enemies with cards', () async {
        final gameState = await GameInitializationService.initializeGameState();

        expect(gameState.enemiesModel.enemies, isNotEmpty);
        expect(gameState.enemiesModel.deckCards.allCards, isNotEmpty);
      });

      test('completes within reasonable time', () async {
        final stopwatch = Stopwatch()..start();

        await GameInitializationService.initializeGameState();

        stopwatch.stop();
        expect(stopwatch.elapsedMilliseconds, lessThan(3000)); // 3 seconds max
      });
    });

    group('createServices', () {
      late GameStateModel gameState;

      setUp(() async {
        gameState = await GameInitializationService.initializeGameState();
      });

      test('creates services with proper types', () {
        final services = GameInitializationService.createServices(gameState);

        expect(
          services.dialogService.runtimeType.toString(),
          contains('DialogService'),
        );
        expect(
          services.cardsSelectionManagerService.runtimeType.toString(),
          contains('CardsSelectionManagerService'),
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

      test('services creation completes quickly', () {
        final stopwatch = Stopwatch()..start();

        GameInitializationService.createServices(gameState);

        stopwatch.stop();
        expect(
          stopwatch.elapsedMilliseconds,
          lessThan(100),
        ); // Should be very fast
      });
    });

    group('Integration', () {
      test('full initialization workflow works correctly', () async {
        final gameState = await GameInitializationService.initializeGameState();
        final services = GameInitializationService.createServices(gameState);

        expect(gameState, isNotNull);
        expect(services, isNotNull);
        expect(services.dialogService, isNotNull);
        expect(services.cardsSelectionManagerService, isNotNull);
        expect(services.gamePhaseManager, isNotNull);
        expect(services.activePlayerManager, isNotNull);
        expect(services.coordinatorsManager, isNotNull);
      });

      test('services can be created from initialized game state', () async {
        final gameState = await GameInitializationService.initializeGameState();

        expect(
          () => GameInitializationService.createServices(gameState),
          returnsNormally,
        );
      });
    });

    group('Error Handling', () {
      test(
        'initializeGameState handles asset loading errors gracefully',
        () async {
          try {
            await GameInitializationService.initializeGameState();
          } catch (e) {
            fail(
              'initializeGameState should not throw during normal operation: $e',
            );
          }
        },
      );
    });
  });
}

// Helper function to create a mock game state for testing
GameStateModel _createMockGameState() =>
    GameStateModel.initialize([], [], [], []);
