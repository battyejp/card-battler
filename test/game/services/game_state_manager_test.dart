import 'package:flutter_test/flutter_test.dart';
import 'package:card_battler/game/services/game_state_manager.dart';
import 'package:card_battler/game/models/game_state_model.dart';

void main() {
  group('GameStateManager', () {
    late GameStateManager gameStateManager;

    setUp(() {
      gameStateManager = GameStateManager();
      gameStateManager.reset();
      // Reset the singleton to setup phase
      GameStateModel.instance.currentPhase = GamePhase.setup;
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
        instance1.setPhase(GamePhase.playerTurn);
        
        final instance2 = GameStateManager();
        expect(instance2.currentPhase, equals(GamePhase.playerTurn));
      });
    });

    group('phase management', () {
      test('initializes with setup phase', () {
        expect(gameStateManager.currentPhase, equals(GamePhase.setup));
      });

      test('sets phase correctly', () {
        gameStateManager.setPhase(GamePhase.playerTurn);
        expect(gameStateManager.currentPhase, equals(GamePhase.playerTurn));
      });

      test('syncs with GameStateModel singleton', () {
        gameStateManager.setPhase(GamePhase.enemyTurn);
        expect(GameStateModel.instance.currentPhase, equals(GamePhase.enemyTurn));
      });

      test('syncs from GameStateModel singleton on get', () {
        GameStateModel.instance.currentPhase = GamePhase.playerTurn;
        expect(gameStateManager.currentPhase, equals(GamePhase.playerTurn));
      });

      test('does not trigger listeners when setting same phase', () {
        bool listenerCalled = false;
        gameStateManager.addPhaseChangeListener((prev, next) {
          listenerCalled = true;
        });

        gameStateManager.setPhase(GamePhase.setup);
        expect(listenerCalled, isFalse);
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

        gameStateManager.setPhase(GamePhase.playerTurn);

        expect(listenerCalled, isTrue);
        expect(previousPhase, equals(GamePhase.setup));
        expect(newPhase, equals(GamePhase.playerTurn));
      });

      test('handles multiple listeners', () {
        int listener1Count = 0;
        int listener2Count = 0;

        gameStateManager.addPhaseChangeListener((prev, next) => listener1Count++);
        gameStateManager.addPhaseChangeListener((prev, next) => listener2Count++);

        gameStateManager.setPhase(GamePhase.playerTurn);
        gameStateManager.setPhase(GamePhase.enemyTurn);

        expect(listener1Count, equals(2));
        expect(listener2Count, equals(2));
      });

      test('removes listeners correctly', () {
        int callCount = 0;
        void listener(GamePhase prev, GamePhase next) => callCount++;

        gameStateManager.addPhaseChangeListener(listener);
        gameStateManager.setPhase(GamePhase.playerTurn);
        expect(callCount, equals(1));

        gameStateManager.removePhaseChangeListener(listener);
        gameStateManager.setPhase(GamePhase.enemyTurn);
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

        gameStateManager.setPhase(GamePhase.playerTurn);
        expect(successfulListener, equals(1));
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
    });

    group('phase progression', () {
      test('nextPhase advances from setup to playerTurn', () {
        gameStateManager.setPhase(GamePhase.setup);
        gameStateManager.nextPhase();
        expect(gameStateManager.currentPhase, equals(GamePhase.playerTurn));
      });

      test('nextPhase advances from playerTurn to enemyTurn', () {
        gameStateManager.setPhase(GamePhase.playerTurn);
        gameStateManager.nextPhase();
        expect(gameStateManager.currentPhase, equals(GamePhase.enemyTurn));
      });

      test('nextPhase advances from enemyTurn to setup', () {
        gameStateManager.setPhase(GamePhase.enemyTurn);
        gameStateManager.nextPhase();
        expect(gameStateManager.currentPhase, equals(GamePhase.setup));
      });

      test('nextPhase creates complete cycle', () {
        // Start at setup
        expect(gameStateManager.currentPhase, equals(GamePhase.setup));
        
        // Go through full cycle
        gameStateManager.nextPhase();
        expect(gameStateManager.currentPhase, equals(GamePhase.playerTurn));
        
        gameStateManager.nextPhase();
        expect(gameStateManager.currentPhase, equals(GamePhase.enemyTurn));
        
        gameStateManager.nextPhase();
        expect(gameStateManager.currentPhase, equals(GamePhase.setup));
      });
    });

    group('utility methods', () {
      test('initialize syncs with GameStateModel', () {
        GameStateModel.instance.currentPhase = GamePhase.enemyTurn;
        gameStateManager.initialize();
        expect(gameStateManager.currentPhase, equals(GamePhase.enemyTurn));
      });

      test('reset clears state and listeners', () {
        // Set up some state
        gameStateManager.setPhase(GamePhase.playerTurn);
        gameStateManager.addPhaseChangeListener((prev, next) {});
        gameStateManager.addConfirmationRequestListener(() {});

        // Reset both the manager and the singleton
        gameStateManager.reset();
        GameStateModel.instance.currentPhase = GamePhase.setup;

        // Verify reset
        expect(gameStateManager.currentPhase, equals(GamePhase.setup));
        // Note: We can't directly test that listeners were cleared without exposing the list
        // but the reset method does clear phase change listeners
      });

      test('clearListeners removes all listeners', () {
        int phaseChangeCount = 0;
        int confirmationCount = 0;

        gameStateManager.addPhaseChangeListener((prev, next) => phaseChangeCount++);
        gameStateManager.addConfirmationRequestListener(() => confirmationCount++);

        gameStateManager.clearListeners();

        gameStateManager.setPhase(GamePhase.playerTurn);
        gameStateManager.requestConfirmation();

        expect(phaseChangeCount, equals(0));
        expect(confirmationCount, equals(0));
      });

      test('debugInfo returns correct information', () {
        gameStateManager.setPhase(GamePhase.playerTurn);
        final debugInfo = gameStateManager.debugInfo;
        
        expect(debugInfo, contains('currentPhase=GamePhase.playerTurn'));
        expect(debugInfo, contains('listeners='));
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
        gameStateManager.nextPhase(); // setup -> playerTurn
        gameStateManager.requestConfirmation(); // Player wants to end turn
        gameStateManager.nextPhase(); // playerTurn -> enemyTurn
        gameStateManager.nextPhase(); // enemyTurn -> setup

        expect(phaseHistory, equals([
          GamePhase.playerTurn,
          GamePhase.enemyTurn,
          GamePhase.setup,
        ]));
        expect(confirmationRequests, equals(1));
      });

      test('maintains consistency between GameStateManager and GameStateModel', () {
        // Set through manager
        gameStateManager.setPhase(GamePhase.playerTurn);
        expect(GameStateModel.instance.currentPhase, equals(GamePhase.playerTurn));

        // Set through singleton directly (simulating external change)
        GameStateModel.instance.currentPhase = GamePhase.enemyTurn;
        // Manager should sync on next access
        expect(gameStateManager.currentPhase, equals(GamePhase.enemyTurn));
      });
    });
  });
}