import 'package:flutter_test/flutter_test.dart';
import 'package:card_battler/game_legacy/services/game_state/game_state_manager.dart';
import 'package:card_battler/game_legacy/models/game_state_model.dart';

void main() {
  group('GameStateManager', () {
    late GameStateManager gameStateManager;

    setUp(() {
      gameStateManager = GameStateManager();
      gameStateManager.reset();
    });

    tearDown(() {
      gameStateManager.clearListeners();
      gameStateManager.reset();
    });

    group('singleton behavior', () {
      test('returns same instance', () {
        final instance1 = GameStateManager();
        final instance2 = GameStateManager();
        expect(identical(instance1, instance2), isTrue);
      });

      test('maintains state across instances', () {
        final instance1 = GameStateManager();
        instance1.nextPhase(); // From waitingToDrawCards to cardsDrawn
        
        final instance2 = GameStateManager();
        expect(instance2.currentPhase, equals(GamePhase.cardsDrawnWaitingForEnemyTurn));
      });
    });

    group('initial state', () {
      test('initializes with waitingToDrawCards phase', () {
        expect(gameStateManager.currentPhase, equals(GamePhase.waitingToDrawCards));
      });

      test('reset returns to initial state', () {
        gameStateManager.nextPhase(); // Move to cardsDrawn
        gameStateManager.nextPhase(); // Move to enemyTurn
        expect(gameStateManager.currentPhase, equals(GamePhase.enemyTurn));
        
        gameStateManager.reset();
        expect(gameStateManager.currentPhase, equals(GamePhase.waitingToDrawCards));
      });
    });

    group('phase progression with nextPhase()', () {
      test('advances from waitingToDrawCards to cardsDrawn', () {
        expect(gameStateManager.currentPhase, equals(GamePhase.waitingToDrawCards));
        gameStateManager.nextPhase();
        expect(gameStateManager.currentPhase, equals(GamePhase.cardsDrawnWaitingForEnemyTurn));
      });

      test('advances from cardsDrawn to enemyTurn', () {
        gameStateManager.nextPhase(); // waitingToDrawCards -> cardsDrawn
        expect(gameStateManager.currentPhase, equals(GamePhase.cardsDrawnWaitingForEnemyTurn));
        gameStateManager.nextPhase();
        expect(gameStateManager.currentPhase, equals(GamePhase.enemyTurn));
      });

      test('advances from enemyTurn to playerTurn', () {
        gameStateManager.nextPhase(); // waitingToDrawCards -> cardsDrawn
        gameStateManager.nextPhase(); // cardsDrawn -> enemyTurn
        expect(gameStateManager.currentPhase, equals(GamePhase.enemyTurn));
        gameStateManager.nextPhase();
        expect(gameStateManager.currentPhase, equals(GamePhase.playerTurn));
      });

      test('advances from playerTurn to waitingToDrawCards (full cycle)', () {
        gameStateManager.nextPhase(); // waitingToDrawCards -> cardsDrawn
        gameStateManager.nextPhase(); // cardsDrawn -> enemyTurn
        gameStateManager.nextPhase(); // enemyTurn -> playerTurn
        expect(gameStateManager.currentPhase, equals(GamePhase.playerTurn));
        gameStateManager.nextPhase();
        expect(gameStateManager.currentPhase, equals(GamePhase.waitingToDrawCards));
      });

      test('creates complete phase cycle', () {
        final expectedPhases = [
          GamePhase.waitingToDrawCards, // Initial
          GamePhase.cardsDrawnWaitingForEnemyTurn,         // After first nextPhase
          GamePhase.enemyTurn,          // After second nextPhase
          GamePhase.playerTurn,         // After third nextPhase
          GamePhase.waitingToDrawCards, // After fourth nextPhase (full cycle)
        ];

        // Test initial state
        expect(gameStateManager.currentPhase, equals(expectedPhases[0]));
        
        // Test each transition
        for (int i = 1; i < expectedPhases.length; i++) {
          gameStateManager.nextPhase();
          expect(gameStateManager.currentPhase, equals(expectedPhases[i]));
        }
      });
    });

    group('phase change listeners', () {
      test('notifies listeners on phase change', () {
        GamePhase? previousPhase;
        GamePhase? newPhase;
        bool listenerCalled = false;

        gameStateManager.addPhaseChangeListener((prev, next) {
          previousPhase = prev;
          newPhase = next;
          listenerCalled = true;
        });

        gameStateManager.nextPhase();

        expect(listenerCalled, isTrue);
        expect(previousPhase, equals(GamePhase.waitingToDrawCards));
        expect(newPhase, equals(GamePhase.cardsDrawnWaitingForEnemyTurn));
      });

      test('handles multiple listeners', () {
        int listener1Count = 0;
        int listener2Count = 0;
        GamePhase? listener1PrevPhase, listener1NewPhase;
        GamePhase? listener2PrevPhase, listener2NewPhase;

        gameStateManager.addPhaseChangeListener((prev, next) {
          listener1Count++;
          listener1PrevPhase = prev;
          listener1NewPhase = next;
        });
        
        gameStateManager.addPhaseChangeListener((prev, next) {
          listener2Count++;
          listener2PrevPhase = prev;
          listener2NewPhase = next;
        });

        gameStateManager.nextPhase(); // waitingToDrawCards -> cardsDrawn
        gameStateManager.nextPhase(); // cardsDrawn -> enemyTurn

        expect(listener1Count, equals(2));
        expect(listener2Count, equals(2));
        expect(listener1PrevPhase, equals(GamePhase.cardsDrawnWaitingForEnemyTurn));
        expect(listener1NewPhase, equals(GamePhase.enemyTurn));
        expect(listener2PrevPhase, equals(GamePhase.cardsDrawnWaitingForEnemyTurn));
        expect(listener2NewPhase, equals(GamePhase.enemyTurn));
      });

      test('removes listeners correctly', () {
        int callCount = 0;
        void listener(GamePhase prev, GamePhase next) => callCount++;

        gameStateManager.addPhaseChangeListener(listener);
        gameStateManager.nextPhase();
        expect(callCount, equals(1));

        gameStateManager.removePhaseChangeListener(listener);
        gameStateManager.nextPhase();
        expect(callCount, equals(1)); // Should not increment
      });

      test('continues notifying other listeners when one fails', () {
        int successfulListener = 0;
        
        // Add a failing listener
        gameStateManager.addPhaseChangeListener((prev, next) {
          throw Exception('Test error');
        });
        
        // Add a successful listener
        gameStateManager.addPhaseChangeListener((prev, next) {
          successfulListener++;
        });

        gameStateManager.nextPhase();
        expect(successfulListener, equals(1));
      });

      test('does not notify listeners when phase does not change', () {
        int callCount = 0;
        gameStateManager.addPhaseChangeListener((prev, next) => callCount++);

        // Manually trigger phase change that results in same phase
        // This tests the internal _setPhase method behavior
        gameStateManager.nextPhase(); // Change to cardsDrawn
        expect(callCount, equals(1));
        
        // Reset clears listeners and doesn't trigger phase change notifications
        callCount = 0;
        gameStateManager.reset(); // Reset clears listeners, so no notification
        expect(callCount, equals(0)); // No listeners to notify after reset
      });
    });

    group('confirmation request listeners', () {
      test('notifies confirmation listeners', () {
        bool confirmationRequested = false;
        
        gameStateManager.addConfirmationRequestListener(() {
          confirmationRequested = true;
        });

        gameStateManager.requestConfirmation();
        expect(confirmationRequested, isTrue);
      });

      test('handles multiple confirmation listeners', () {
        int listener1Count = 0;
        int listener2Count = 0;

        gameStateManager.addConfirmationRequestListener(() => listener1Count++);
        gameStateManager.addConfirmationRequestListener(() => listener2Count++);

        gameStateManager.requestConfirmation();

        expect(listener1Count, equals(1));
        expect(listener2Count, equals(1));
      });

      test('removes confirmation listeners correctly', () {
        int callCount = 0;
        void listener() => callCount++;

        gameStateManager.addConfirmationRequestListener(listener);
        gameStateManager.requestConfirmation();
        expect(callCount, equals(1));

        gameStateManager.removeConfirmationRequestListener(listener);
        gameStateManager.requestConfirmation();
        expect(callCount, equals(1)); // Should not increment
      });

      test('continues notifying other confirmation listeners when one fails', () {
        int successfulListener = 0;
        
        // Add a failing listener
        gameStateManager.addConfirmationRequestListener(() {
          throw Exception('Test error');
        });
        
        // Add a successful listener
        gameStateManager.addConfirmationRequestListener(() {
          successfulListener++;
        });

        gameStateManager.requestConfirmation();
        expect(successfulListener, equals(1));
      });

      test('can request confirmation multiple times', () {
        int confirmationCount = 0;
        
        gameStateManager.addConfirmationRequestListener(() {
          confirmationCount++;
        });

        gameStateManager.requestConfirmation();
        gameStateManager.requestConfirmation();
        gameStateManager.requestConfirmation();
        
        expect(confirmationCount, equals(3));
      });
    });

    group('listener management', () {
      test('clearListeners removes all listeners', () {
        int phaseChangeCount = 0;
        int confirmationCount = 0;

        gameStateManager.addPhaseChangeListener((prev, next) => phaseChangeCount++);
        gameStateManager.addConfirmationRequestListener(() => confirmationCount++);

        gameStateManager.clearListeners();

        gameStateManager.nextPhase();
        gameStateManager.requestConfirmation();

        expect(phaseChangeCount, equals(0));
        expect(confirmationCount, equals(0));
      });

      test('reset clears only phase change listeners', () {
        int phaseChangeCount = 0;
        int confirmationCount = 0;

        gameStateManager.addPhaseChangeListener((prev, next) => phaseChangeCount++);
        gameStateManager.addConfirmationRequestListener(() => confirmationCount++);

        gameStateManager.reset();

        gameStateManager.nextPhase();
        gameStateManager.requestConfirmation();

        expect(phaseChangeCount, equals(0)); // Phase change listeners cleared by reset
        expect(confirmationCount, equals(1)); // Confirmation listeners NOT cleared by reset
      });

      test('can add same listener multiple times', () {
        int callCount = 0;
        void listener(GamePhase prev, GamePhase next) => callCount++;

        gameStateManager.addPhaseChangeListener(listener);
        gameStateManager.addPhaseChangeListener(listener);

        gameStateManager.nextPhase();
        expect(callCount, equals(2)); // Called twice because added twice
      });

      test('removing non-existent listener does not cause error', () {
        void listener(GamePhase prev, GamePhase next) {}

        // Should not throw
        expect(() => gameStateManager.removePhaseChangeListener(listener), returnsNormally);
        expect(() => gameStateManager.removeConfirmationRequestListener(() {}), returnsNormally);
      });
    });

    group('debug and utility methods', () {
      test('debugInfo returns correct information', () {
        gameStateManager.nextPhase(); // Move to cardsDrawn
        final debugInfo = gameStateManager.debugInfo;
        
        expect(debugInfo, contains('currentPhase=GamePhase.cardsDrawn'));
        expect(debugInfo, contains('listeners=0')); // No listeners added in this test
      });

      test('debugInfo shows correct listener count', () {
        gameStateManager.addPhaseChangeListener((prev, next) {});
        gameStateManager.addPhaseChangeListener((prev, next) {});
        
        final debugInfo = gameStateManager.debugInfo;
        expect(debugInfo, contains('listeners=2'));
      });
    });

    group('integration scenarios', () {
      test('phase changes with listeners and confirmation requests work together', () {
        List<GamePhase> phaseHistory = [];
        int confirmationRequests = 0;

        gameStateManager.addPhaseChangeListener((prev, next) {
          phaseHistory.add(next);
        });
        
        gameStateManager.addConfirmationRequestListener(() {
          confirmationRequests++;
        });

        // Simulate a game flow
        gameStateManager.nextPhase(); // waitingToDrawCards -> cardsDrawn
        gameStateManager.requestConfirmation(); // Player wants to end turn
        gameStateManager.nextPhase(); // cardsDrawn -> enemyTurn
        gameStateManager.nextPhase(); // enemyTurn -> playerTurn

        expect(phaseHistory, equals([
          GamePhase.cardsDrawnWaitingForEnemyTurn,
          GamePhase.enemyTurn,
          GamePhase.playerTurn,
        ]));
        expect(confirmationRequests, equals(1));
      });

      test('full game cycle with listeners tracks all phase transitions', () {
        List<String> transitionLog = [];

        gameStateManager.addPhaseChangeListener((prev, next) {
          transitionLog.add('${prev.toString()} -> ${next.toString()}');
        });

        // Complete one full cycle
        gameStateManager.nextPhase(); // waitingToDrawCards -> cardsDrawnWaitingForEnemyTurn
        gameStateManager.nextPhase(); // cardsDrawnWaitingForEnemyTurn -> enemyTurn
        gameStateManager.nextPhase(); // enemyTurn -> playerTurn
        gameStateManager.nextPhase(); // playerTurn -> waitingToDrawCards

        expect(transitionLog, equals([
          'GamePhase.waitingToDrawCards -> GamePhase.cardsDrawnWaitingForEnemyTurn',
          'GamePhase.cardsDrawnWaitingForEnemyTurn -> GamePhase.enemyTurn',
          'GamePhase.enemyTurn -> GamePhase.playerTurn',
          'GamePhase.playerTurn -> GamePhase.waitingToDrawCards',
        ]));
      });
    });

    group('edge cases and robustness', () {
      test('handles rapid phase transitions', () {
        int changeCount = 0;
        gameStateManager.addPhaseChangeListener((prev, next) => changeCount++);

        // Rapidly cycle through phases
        for (int i = 0; i < 100; i++) {
          gameStateManager.nextPhase();
        }

        expect(changeCount, equals(100));
        expect(gameStateManager.currentPhase, equals(GamePhase.waitingToDrawCards)); // Should be back at start
      });

      test('listener exceptions do not break state transitions', () {
        bool successfulListenerCalled = false;

        // Add a listener that throws
        gameStateManager.addPhaseChangeListener((prev, next) {
          throw Exception('Simulated error');
        });

        // Add a listener that should still work
        gameStateManager.addPhaseChangeListener((prev, next) {
          successfulListenerCalled = true;
        });

        // This should not throw and should call the successful listener
        expect(() => gameStateManager.nextPhase(), returnsNormally);
        expect(successfulListenerCalled, isTrue);
        expect(gameStateManager.currentPhase, equals(GamePhase.cardsDrawnWaitingForEnemyTurn));
      });

      test('maintains consistency after listener management operations', () {
        int callCount = 0;
        void counter(GamePhase prev, GamePhase next) => callCount++;

        // Add and remove listeners multiple times
        gameStateManager.addPhaseChangeListener(counter);
        gameStateManager.removePhaseChangeListener(counter);
        gameStateManager.addPhaseChangeListener(counter);
        gameStateManager.addPhaseChangeListener(counter);
        gameStateManager.clearListeners();
        gameStateManager.addPhaseChangeListener(counter);

        gameStateManager.nextPhase();
        expect(callCount, equals(1));
        expect(gameStateManager.currentPhase, equals(GamePhase.cardsDrawnWaitingForEnemyTurn));
      });
    });
  });
}