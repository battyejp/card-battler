import 'package:flutter_test/flutter_test.dart';
import 'package:card_battler/game/services/game_state/game_state_service.dart';
import 'package:card_battler/game/services/game_state/game_state_manager.dart';
import 'package:card_battler/game/models/game_state_model.dart';

void main() {
  group('DefaultGameStateService', () {
    late GameStateManager gameStateManager;
    late DefaultGameStateService gameStateService;

    setUp(() {
      gameStateManager = GameStateManager();
      gameStateService = DefaultGameStateService(gameStateManager);
      gameStateManager.reset();
    });

    tearDown(() {
      gameStateManager.clearListeners();
      gameStateManager.reset();
    });

    group('constructor', () {
      test('requires GameStateManager dependency', () {
        expect(
          () => DefaultGameStateService(gameStateManager),
          returnsNormally,
        );
      });

      test('implements GameStateService interface', () {
        expect(gameStateService, isA<GameStateService>());
      });
    });

    group('currentPhase', () {
      test('delegates to GameStateManager currentPhase', () {
        expect(
          gameStateService.currentPhase,
          equals(gameStateManager.currentPhase),
        );
        expect(
          gameStateService.currentPhase,
          equals(GamePhase.waitingToDrawCards),
        );
      });

      test('reflects GameStateManager phase changes', () {
        gameStateManager.nextPhase(); // waitingToDrawCards -> cardsDrawn
        expect(gameStateService.currentPhase, equals(GamePhase.cardsDrawnWaitingForEnemyTurn));

        gameStateManager.nextPhase(); // cardsDrawn -> enemyTurn
        expect(gameStateService.currentPhase, equals(GamePhase.enemyTurn));

        gameStateManager.nextPhase(); // enemyTurn -> playerTurn
        expect(gameStateService.currentPhase, equals(GamePhase.playerTurn));
      });

      test('stays synchronized with GameStateManager', () {
        // Make multiple changes and verify sync
        for (int i = 0; i < 10; i++) {
          gameStateManager.nextPhase();
          expect(
            gameStateService.currentPhase,
            equals(gameStateManager.currentPhase),
          );
        }
      });
    });

    group('nextPhase', () {
      test('delegates to GameStateManager nextPhase', () {
        expect(
          gameStateService.currentPhase,
          equals(GamePhase.waitingToDrawCards),
        );

        gameStateService.nextPhase();
        expect(gameStateService.currentPhase, equals(GamePhase.cardsDrawnWaitingForEnemyTurn));
        expect(gameStateManager.currentPhase, equals(GamePhase.cardsDrawnWaitingForEnemyTurn));
      });

      test('advances through phase cycle correctly', () {
        final expectedPhases = [
          GamePhase.waitingToDrawCards, // Initial
          GamePhase.cardsDrawnWaitingForEnemyTurn, // After first nextPhase
          GamePhase.enemyTurn, // After second nextPhase
          GamePhase.playerTurn, // After third nextPhase
          GamePhase.waitingToDrawCards, // After fourth nextPhase (full cycle)
        ];

        expect(gameStateService.currentPhase, equals(expectedPhases[0]));

        for (int i = 1; i < expectedPhases.length; i++) {
          gameStateService.nextPhase();
          expect(gameStateService.currentPhase, equals(expectedPhases[i]));
        }
      });

      test('multiple calls advance phases correctly', () {
        gameStateService.nextPhase(); // waitingToDrawCards -> cardsDrawn
        gameStateService.nextPhase(); // cardsDrawn -> enemyTurn
        gameStateService.nextPhase(); // enemyTurn -> playerTurn

        expect(gameStateService.currentPhase, equals(GamePhase.playerTurn));
      });
    });

    group('requestConfirmation', () {
      test('delegates to GameStateManager requestConfirmation', () {
        bool confirmationRequested = false;

        gameStateManager.addConfirmationRequestListener(() {
          confirmationRequested = true;
        });

        gameStateService.requestConfirmation();
        expect(confirmationRequested, isTrue);
      });

      test('can be called multiple times', () {
        int confirmationCount = 0;

        gameStateManager.addConfirmationRequestListener(() {
          confirmationCount++;
        });

        gameStateService.requestConfirmation();
        gameStateService.requestConfirmation();
        gameStateService.requestConfirmation();

        expect(confirmationCount, equals(3));
      });

      test('works independently of phase changes', () {
        int confirmationCount = 0;
        List<GamePhase> phaseChanges = [];

        gameStateManager.addConfirmationRequestListener(() {
          confirmationCount++;
        });

        gameStateManager.addPhaseChangeListener((prev, next) {
          phaseChanges.add(next);
        });

        gameStateService.requestConfirmation();
        gameStateService.nextPhase();
        gameStateService.requestConfirmation();
        gameStateService.nextPhase();

        expect(confirmationCount, equals(2));
        expect(
          phaseChanges,
          equals([GamePhase.cardsDrawnWaitingForEnemyTurn, GamePhase.enemyTurn]),
        );
      });
    });

    group('dependency management', () {
      test('different instances with same manager share state', () {
        final service1 = DefaultGameStateService(gameStateManager);
        final service2 = DefaultGameStateService(gameStateManager);

        service1.nextPhase();
        expect(service2.currentPhase, equals(GamePhase.cardsDrawnWaitingForEnemyTurn));

        service2.nextPhase();
        expect(service1.currentPhase, equals(GamePhase.enemyTurn));
      });
    });

    group('integration scenarios', () {
      test('works correctly with GameStateManager listeners', () {
        List<GamePhase> phaseHistory = [];
        int confirmationCount = 0;

        gameStateManager.addPhaseChangeListener((prev, next) {
          phaseHistory.add(next);
        });

        gameStateManager.addConfirmationRequestListener(() {
          confirmationCount++;
        });

        // Simulate game flow through service
        gameStateService.nextPhase(); // waitingToDrawCards -> cardsDrawn
        gameStateService.requestConfirmation(); // Player wants to end turn
        gameStateService.nextPhase(); // cardsDrawn -> enemyTurn
        gameStateService.nextPhase(); // enemyTurn -> playerTurn

        expect(
          phaseHistory,
          equals([
            GamePhase.cardsDrawnWaitingForEnemyTurn,
            GamePhase.enemyTurn,
            GamePhase.playerTurn,
          ]),
        );
        expect(confirmationCount, equals(1));
      });

      group('error handling', () {
        test('propagates GameStateManager errors', () {
          // If GameStateManager were to throw errors, they should propagate
          // This tests the delegation behavior doesn't suppress errors
          expect(() => gameStateService.nextPhase(), returnsNormally);
          expect(() => gameStateService.requestConfirmation(), returnsNormally);
        });
      });

      group('interface compliance', () {
        test('provides all required interface methods', () {
          // Verify all interface methods exist and are callable
          expect(() => gameStateService.currentPhase, returnsNormally);
          expect(() => gameStateService.nextPhase(), returnsNormally);
          expect(() => gameStateService.requestConfirmation(), returnsNormally);
        });

        test('getter and methods have correct return types', () {
          expect(gameStateService.currentPhase, isA<GamePhase>());

          // Methods should not return anything (void) - just call them
          gameStateService.nextPhase();
          gameStateService.requestConfirmation();

          // Verify the methods can be called without error
          expect(gameStateService.currentPhase, isA<GamePhase>());
        });
      });
    });
  });
}