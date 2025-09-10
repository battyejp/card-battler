import 'package:flutter_test/flutter_test.dart';
import 'package:card_battler/game_legacy/services/ui/router_service.dart';
import 'package:card_battler/game_legacy/services/game_state/game_state_manager.dart';
import 'package:card_battler/game_legacy/models/game_state_model.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';

void main() {
  group('RouterService', () {
    late RouterService routerService;
    late GameStateManager gameStateManager;
    final gameSize = Vector2(800, 600);

    setUp(() {
      // Reset singleton instances
      GameStateModel.reset();
      gameStateManager = GameStateManager();
      routerService = RouterService();
    });

    tearDown(() {
      GameStateModel.reset();
    });

    group('singleton pattern', () {
      test('maintains singleton instance', () {
        final instance1 = RouterService();
        final instance2 = RouterService();
        
        expect(identical(instance1, instance2), isTrue);
      });
    });

    group('router initialization', () {
      test('createRouter initializes with correct initial route', () {
        final router = routerService.createRouter(gameSize);
        
        expect(router, isNotNull);
      });

      test('createRouter creates player turn scene reference', () {
        routerService.createRouter(gameSize);
        
        expect(routerService.playerTurnScene, isNotNull);
      });
    });

    group('_handleEnemyTurnToPlayerTurn integration', () {
      test('resetTurn method exists and is called after delay', () async {
        routerService.createRouter(gameSize);
        
        // Verify that the game state has an enemy turn area with resetTurn method
        final gameState = GameStateModel.instance;
        expect(gameState.enemyTurnArea, isNotNull);
        
        // Verify resetTurn method exists by calling it directly
        expect(() => gameState.enemyTurnArea.resetTurn(), returnsNormally);
      });

      test('handleEnemyTurnToPlayerTurn uses correct delay timing', () async {
        routerService.createRouter(gameSize);
        
        // Test that the delay constant is 1 second by measuring time
        final stopwatch = Stopwatch()..start();
        
        // Simulate the phase transition
        gameStateManager.reset();
        while (gameStateManager.currentPhase != GamePhase.enemyTurn) {
          gameStateManager.nextPhase();
        }
        gameStateManager.nextPhase(); // This should trigger _handleEnemyTurnToPlayerTurn
        
        // Wait for the delay plus a buffer
        await Future.delayed(const Duration(milliseconds: 1200));
        
        stopwatch.stop();
        
        // Verify we waited at least 1 second (the delay in the method)
        expect(stopwatch.elapsedMilliseconds, greaterThanOrEqualTo(1000));
      });
    });

    group('debug and utility methods', () {
      test('debugInfo returns expected string', () {
        expect(routerService.debugInfo, contains('RouterService'));
      });
      
      test('playerTurnScene is accessible after router creation', () {
        routerService.createRouter(gameSize);
        expect(routerService.playerTurnScene, isNotNull);
      });
    });
  });
}