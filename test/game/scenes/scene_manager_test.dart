import 'package:card_battler/game/scenes/scene_manager.dart';
import 'package:flame/components.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SceneManager', () {
    group('initialization', () {
      testWithFlameGame('creates with default main scene', (game) async {
        final sceneManager = SceneManager();
        
        expect(sceneManager.currentScene, equals(GameSceneType.main));
        expect(sceneManager.currentSceneComponent, isNull);
      });
    });

    group('scene transitions', () {
      testWithFlameGame('transitions to new scene successfully', (game) async {
        final sceneManager = SceneManager();
        await game.ensureAdd(sceneManager);
        
        final testScene = Component();
        bool transitionCompleted = false;
        
        await sceneManager.transitionToScene(
          GameSceneType.enemyTurn,
          testScene,
          onTransitionComplete: () => transitionCompleted = true,
        );
        
        expect(sceneManager.currentScene, equals(GameSceneType.enemyTurn));
        expect(sceneManager.currentSceneComponent, equals(testScene));
        expect(transitionCompleted, isTrue);
        expect(sceneManager.children.contains(testScene), isTrue);
      });

      testWithFlameGame('removes previous scene when transitioning', (game) async {
        final sceneManager = SceneManager();
        await game.ensureAdd(sceneManager);
        
        final firstScene = Component();
        final secondScene = Component();
        
        // Add first scene
        await sceneManager.transitionToScene(GameSceneType.main, firstScene);
        expect(sceneManager.children.contains(firstScene), isTrue);
        
        // Transition to second scene
        await sceneManager.transitionToScene(GameSceneType.enemyTurn, secondScene);
        
        expect(sceneManager.children.contains(firstScene), isFalse);
        expect(sceneManager.children.contains(secondScene), isTrue);
        expect(sceneManager.currentSceneComponent, equals(secondScene));
      });

      testWithFlameGame('returnToMainScene works correctly', (game) async {
        final sceneManager = SceneManager();
        await game.ensureAdd(sceneManager);
        
        final enemyScene = Component();
        final mainScene = Component();
        
        // Transition to enemy scene
        await sceneManager.transitionToScene(GameSceneType.enemyTurn, enemyScene);
        expect(sceneManager.currentScene, equals(GameSceneType.enemyTurn));
        
        // Return to main scene
        bool returnCompleted = false;
        await sceneManager.returnToMainScene(
          mainScene,
          onTransitionComplete: () => returnCompleted = true,
        );
        
        expect(sceneManager.currentScene, equals(GameSceneType.main));
        expect(sceneManager.currentSceneComponent, equals(mainScene));
        expect(returnCompleted, isTrue);
        expect(sceneManager.children.contains(enemyScene), isFalse);
        expect(sceneManager.children.contains(mainScene), isTrue);
      });
    });

    group('scene state management', () {
      testWithFlameGame('isSceneActive works correctly', (game) async {
        final sceneManager = SceneManager();
        await game.ensureAdd(sceneManager);
        
        // Initially on main scene
        expect(sceneManager.isSceneActive(GameSceneType.main), isTrue);
        expect(sceneManager.isSceneActive(GameSceneType.enemyTurn), isFalse);
        
        // Transition to enemy turn
        final enemyScene = Component();
        await sceneManager.transitionToScene(GameSceneType.enemyTurn, enemyScene);
        
        expect(sceneManager.isSceneActive(GameSceneType.main), isFalse);
        expect(sceneManager.isSceneActive(GameSceneType.enemyTurn), isTrue);
      });

      testWithFlameGame('clearCurrentScene removes current scene', (game) async {
        final sceneManager = SceneManager();
        await game.ensureAdd(sceneManager);
        
        final testScene = Component();
        await sceneManager.transitionToScene(GameSceneType.enemyTurn, testScene);
        
        expect(sceneManager.currentSceneComponent, equals(testScene));
        expect(sceneManager.children.contains(testScene), isTrue);
        
        sceneManager.clearCurrentScene();
        
        expect(sceneManager.currentSceneComponent, isNull);
        expect(sceneManager.children.contains(testScene), isFalse);
      });
    });

    group('edge cases', () {
      testWithFlameGame('handles null current scene component', (game) async {
        final sceneManager = SceneManager();
        await game.ensureAdd(sceneManager);
        
        final testScene = Component();
        
        // Should not throw when transitioning from null current scene
        expect(() async => await sceneManager.transitionToScene(
          GameSceneType.enemyTurn, 
          testScene,
        ), returnsNormally);
        
        expect(sceneManager.currentSceneComponent, equals(testScene));
      });

      testWithFlameGame('handles multiple clearCurrentScene calls', (game) async {
        final sceneManager = SceneManager();
        await game.ensureAdd(sceneManager);
        
        // Clear when no current scene - should not throw
        expect(() => sceneManager.clearCurrentScene(), returnsNormally);
        
        // Add a scene then clear it twice
        final testScene = Component();
        await sceneManager.transitionToScene(GameSceneType.main, testScene);
        
        sceneManager.clearCurrentScene();
        expect(() => sceneManager.clearCurrentScene(), returnsNormally);
      });
    });

    group('scene sizing', () {
      testWithFlameGame('sets scene size to match parent when available', (game) async {
        final sceneManager = SceneManager();
        sceneManager.size = Vector2(800, 600); // Set scene manager size
        await game.ensureAdd(sceneManager);
        
        final testScene = Component();
        await sceneManager.transitionToScene(GameSceneType.enemyTurn, testScene);
        
        expect(testScene.size, equals(Vector2(800, 600)));
      });
    });
  });
}