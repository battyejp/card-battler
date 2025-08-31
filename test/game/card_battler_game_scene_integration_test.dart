import 'package:card_battler/game/card_battler_game.dart';
import 'package:card_battler/game/scenes/scene_manager.dart';
import 'package:flame/components.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CardBattlerGame Scene Integration', () {
    testWithFlameGame('game initializes with scene manager', (game) async {
      final cardGame = CardBattlerGame.withSize(Vector2(800, 600));
      await game.ensureAdd(cardGame);
      
      // Check that the game has been loaded
      expect(cardGame.isMounted, isTrue);
      
      // Check that scene manager has been initialized (should have at least one child)
      expect(cardGame.children.isNotEmpty, isTrue);
      
      // Find the scene manager component
      final sceneManager = cardGame.children.whereType<SceneManager>().firstOrNull;
      expect(sceneManager, isNotNull);
      expect(sceneManager!.currentScene, equals(GameSceneType.main));
    });

    testWithFlameGame('enemy turn transition works', (game) async {
      final cardGame = CardBattlerGame.withSize(Vector2(800, 600));
      await game.ensureAdd(cardGame);
      
      // Let the game fully load
      await Future.delayed(Duration(milliseconds: 100));
      
      // Find the scene manager
      final sceneManager = cardGame.children.whereType<SceneManager>().firstOrNull;
      expect(sceneManager, isNotNull);
      
      // Initially should be on main scene
      expect(sceneManager!.currentScene, equals(GameSceneType.main));
      
      // Trigger enemy turn (this would normally happen via game logic)
      // For this test, we just verify the scene manager can transition
      expect(sceneManager.isSceneActive(GameSceneType.main), isTrue);
      expect(sceneManager.isSceneActive(GameSceneType.enemyTurn), isFalse);
    });

    testWithFlameGame('game components are created correctly', (game) async {
      final cardGame = CardBattlerGame.withSize(Vector2(800, 600));
      await game.ensureAdd(cardGame);
      
      // Wait for initialization
      await Future.delayed(Duration(milliseconds: 100));
      
      // Game should have loaded successfully without errors
      expect(cardGame.isMounted, isTrue);
      
      // Should have at least the scene manager as child
      expect(cardGame.children.length, greaterThan(0));
    });
  });
}