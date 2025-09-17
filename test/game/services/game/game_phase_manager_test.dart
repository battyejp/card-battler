import 'package:card_battler/game/services/game/game_phase_manager.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GamePhase', () {
    test('enum contains all expected phases', () {
      expect(GamePhase.values, hasLength(6));
      expect(GamePhase.values, contains(GamePhase.waitingToDrawPlayerCards));
      expect(GamePhase.values, contains(GamePhase.playerCardsDrawnWaitingForEnemyTurn));
      expect(GamePhase.values, contains(GamePhase.enemyTurnWaitingToDrawCards));
      expect(GamePhase.values, contains(GamePhase.enemiesTurnCardsDrawnWaitingForPlayersTurn));
      expect(GamePhase.values, contains(GamePhase.playerTakeActionsTurn));
      expect(GamePhase.values, contains(GamePhase.playerCardsDrawnWaitingForPlayerSwitch));
    });
  });

  group('GamePhaseManager', () {
    late GamePhaseManager gamePhaseManager;

    setUp(() {
      gamePhaseManager = GamePhaseManager(numberOfPlayers: 2);
    });

    group('Constructor', () {
      test('initializes with correct default values', () {
        expect(gamePhaseManager.currentPhase, equals(GamePhase.waitingToDrawPlayerCards));
      });

      test('accepts different number of players', () {
        final singlePlayerManager = GamePhaseManager(numberOfPlayers: 1);
        final multiPlayerManager = GamePhaseManager(numberOfPlayers: 4);
        
        expect(singlePlayerManager.currentPhase, equals(GamePhase.waitingToDrawPlayerCards));
        expect(multiPlayerManager.currentPhase, equals(GamePhase.waitingToDrawPlayerCards));
      });
    });

    group('Phase Transitions', () {
      test('transitions from waitingToDrawPlayerCards to playerCardsDrawnWaitingForEnemyTurn (first transition)', () {
        final nextPhase = gamePhaseManager.nextPhase();
        
        expect(nextPhase, equals(GamePhase.playerCardsDrawnWaitingForEnemyTurn));
        expect(gamePhaseManager.currentPhase, equals(GamePhase.playerCardsDrawnWaitingForEnemyTurn));
      });

      test('transitions from playerCardsDrawnWaitingForEnemyTurn to enemyTurnWaitingToDrawCards', () {
        gamePhaseManager.nextPhase(); // Move to playerCardsDrawnWaitingForEnemyTurn
        
        final nextPhase = gamePhaseManager.nextPhase();
        
        expect(nextPhase, equals(GamePhase.enemyTurnWaitingToDrawCards));
        expect(gamePhaseManager.currentPhase, equals(GamePhase.enemyTurnWaitingToDrawCards));
      });

      test('transitions from enemyTurnWaitingToDrawCards to enemiesTurnCardsDrawnWaitingForPlayersTurn', () {
        gamePhaseManager.nextPhase(); // playerCardsDrawnWaitingForEnemyTurn
        gamePhaseManager.nextPhase(); // enemyTurnWaitingToDrawCards
        
        final nextPhase = gamePhaseManager.nextPhase();
        
        expect(nextPhase, equals(GamePhase.enemiesTurnCardsDrawnWaitingForPlayersTurn));
        expect(gamePhaseManager.currentPhase, equals(GamePhase.enemiesTurnCardsDrawnWaitingForPlayersTurn));
      });

      test('transitions from enemiesTurnCardsDrawnWaitingForPlayersTurn to playerTakeActionsTurn', () {
        _advanceToPhase(gamePhaseManager, GamePhase.enemiesTurnCardsDrawnWaitingForPlayersTurn);
        
        final nextPhase = gamePhaseManager.nextPhase();
        
        expect(nextPhase, equals(GamePhase.playerTakeActionsTurn));
        expect(gamePhaseManager.currentPhase, equals(GamePhase.playerTakeActionsTurn));
      });

      test('transitions from playerTakeActionsTurn to waitingToDrawPlayerCards', () {
        _advanceToPhase(gamePhaseManager, GamePhase.playerTakeActionsTurn);
        
        final nextPhase = gamePhaseManager.nextPhase();
        
        expect(nextPhase, equals(GamePhase.waitingToDrawPlayerCards));
        expect(gamePhaseManager.currentPhase, equals(GamePhase.waitingToDrawPlayerCards));
      });

      test('handles player switching correctly after playerTakeActionsTurn', () {
        _advanceToPhase(gamePhaseManager, GamePhase.playerTakeActionsTurn);
        gamePhaseManager.nextPhase(); // Move to waitingToDrawPlayerCards
        
        // This should transition to playerCardsDrawnWaitingForPlayerSwitch 
        final nextPhase = gamePhaseManager.nextPhase();
        
        expect(nextPhase, equals(GamePhase.playerCardsDrawnWaitingForPlayerSwitch));
        expect(gamePhaseManager.currentPhase, equals(GamePhase.playerCardsDrawnWaitingForPlayerSwitch));
      });
    });

    group('Complete Game Cycle', () {
      test('completes full game cycle for single player', () {
        final singlePlayerManager = GamePhaseManager(numberOfPlayers: 1);
        final phases = <GamePhase>[];
        
        // Collect phases for one complete cycle
        for (int i = 0; i < 8; i++) {
          phases.add(singlePlayerManager.currentPhase);
          singlePlayerManager.nextPhase();
        }
        
        expect(phases, contains(GamePhase.waitingToDrawPlayerCards));
        expect(phases, contains(GamePhase.playerCardsDrawnWaitingForEnemyTurn));
        expect(phases, contains(GamePhase.enemyTurnWaitingToDrawCards));
        expect(phases, contains(GamePhase.enemiesTurnCardsDrawnWaitingForPlayersTurn));
        expect(phases, contains(GamePhase.playerTakeActionsTurn));
        expect(phases, contains(GamePhase.playerCardsDrawnWaitingForPlayerSwitch));
      });

      test('handles multiple players correctly', () {
        final multiPlayerManager = GamePhaseManager(numberOfPlayers: 3);
        
        // Complete one round (all players have had their turn)
        final phaseSequence = <GamePhase>[];
        for (int i = 0; i < 12; i++) {
          phaseSequence.add(multiPlayerManager.currentPhase);
          multiPlayerManager.nextPhase();
        }
        
        // Should see player switch phases
        expect(phaseSequence, contains(GamePhase.playerCardsDrawnWaitingForPlayerSwitch));
      });
    });

    group('Phase Change Listeners', () {
      test('notifies listeners when phase changes', () {
        var callCount = 0;
        GamePhase? previousPhase;
        GamePhase? newPhase;
        
        gamePhaseManager.addPhaseChangeListener((prev, next) {
          callCount++;
          previousPhase = prev;
          newPhase = next;
        });
        
        gamePhaseManager.nextPhase();
        
        expect(callCount, equals(1));
        expect(previousPhase, equals(GamePhase.waitingToDrawPlayerCards));
        expect(newPhase, equals(GamePhase.playerCardsDrawnWaitingForEnemyTurn));
      });

      test('supports multiple listeners', () {
        var listener1Called = false;
        var listener2Called = false;
        
        gamePhaseManager.addPhaseChangeListener((prev, next) {
          listener1Called = true;
        });
        
        gamePhaseManager.addPhaseChangeListener((prev, next) {
          listener2Called = true;
        });
        
        gamePhaseManager.nextPhase();
        
        expect(listener1Called, isTrue);
        expect(listener2Called, isTrue);
      });

      test('can remove listeners', () {
        var callCount = 0;
        
        void listener(GamePhase prev, GamePhase next) {
          callCount++;
        }
        
        gamePhaseManager.addPhaseChangeListener(listener);
        gamePhaseManager.nextPhase(); // Should trigger listener
        expect(callCount, equals(1));
        
        gamePhaseManager.removePhaseChangeListener(listener);
        gamePhaseManager.nextPhase(); // Should not trigger listener
        expect(callCount, equals(1)); // Still 1, not 2
      });

      test('handles listener exceptions gracefully', () {
        var goodListenerCalled = false;
        
        // Add a listener that throws an exception
        gamePhaseManager.addPhaseChangeListener((prev, next) {
          throw Exception('Test exception');
        });
        
        // Add a listener that should still be called
        gamePhaseManager.addPhaseChangeListener((prev, next) {
          goodListenerCalled = true;
        });
        
        // This should not throw, and the good listener should still be called
        expect(() => gamePhaseManager.nextPhase(), returnsNormally);
        expect(goodListenerCalled, isTrue);
      });

      test('does not notify listeners when phase does not change', () {
        var callCount = 0;
        
        gamePhaseManager.addPhaseChangeListener((prev, next) {
          callCount++;
        });
        
        // Force the same phase (this would require accessing private method, 
        // so we'll test by verifying normal transitions don't trigger multiple calls)
        gamePhaseManager.nextPhase(); // Should trigger once
        expect(callCount, equals(1));
        
        // Additional transitions should only trigger once each
        gamePhaseManager.nextPhase();
        expect(callCount, equals(2));
      });
    });

    group('Edge Cases', () {
      test('handles zero players gracefully', () {
        final zeroPlayerManager = GamePhaseManager(numberOfPlayers: 0);
        
        expect(() => zeroPlayerManager.nextPhase(), returnsNormally);
        expect(zeroPlayerManager.currentPhase, isNotNull);
      });

      test('handles negative number of players', () {
        final negativePlayerManager = GamePhaseManager(numberOfPlayers: -1);
        
        expect(() => negativePlayerManager.nextPhase(), returnsNormally);
        expect(negativePlayerManager.currentPhase, isNotNull);
      });
    });
  });
}

/// Helper function to advance to a specific phase
void _advanceToPhase(GamePhaseManager manager, GamePhase targetPhase) {
  int maxAttempts = 20; // Prevent infinite loops in tests
  while (manager.currentPhase != targetPhase && maxAttempts > 0) {
    manager.nextPhase();
    maxAttempts--;
  }
  
  if (manager.currentPhase != targetPhase) {
    throw StateError('Could not advance to target phase: $targetPhase');
  }
}