import 'package:flame/components.dart';

/// Enumeration of available game scenes
enum GameSceneType {
  main,
  enemyTurn,
}

/// Simple scene manager for handling transitions between game scenes
/// This replaces RouterComponent functionality for Flame 1.30.1
class SceneManager extends Component {
  GameSceneType _currentScene = GameSceneType.main;
  Component? _currentSceneComponent;
  
  /// Gets the currently active scene type
  GameSceneType get currentScene => _currentScene;
  
  /// Gets the current scene component
  Component? get currentSceneComponent => _currentSceneComponent;

  /// Transitions to a new scene
  /// [sceneType] - The scene to transition to
  /// [sceneComponent] - The component representing the new scene
  /// [onTransitionComplete] - Optional callback when transition is complete
  Future<void> transitionToScene(
    GameSceneType sceneType,
    Component sceneComponent, {
    VoidCallback? onTransitionComplete,
  }) async {
    // Remove current scene if it exists
    if (_currentSceneComponent != null) {
      _currentSceneComponent!.removeFromParent();
    }

    // Set new scene
    _currentScene = sceneType;
    _currentSceneComponent = sceneComponent;
    
    // Set the scene size to match the parent game size
    if (parent?.size != null) {
      sceneComponent.size = parent!.size;
    }

    // Add the new scene
    add(sceneComponent);
    
    onTransitionComplete?.call();
  }

  /// Returns to the main game scene
  /// [mainSceneComponent] - The main game scene component
  /// [onTransitionComplete] - Optional callback when transition is complete
  Future<void> returnToMainScene(
    Component mainSceneComponent, {
    VoidCallback? onTransitionComplete,
  }) async {
    await transitionToScene(
      GameSceneType.main, 
      mainSceneComponent,
      onTransitionComplete: onTransitionComplete,
    );
  }

  /// Removes the current scene without transitioning to a new one
  void clearCurrentScene() {
    if (_currentSceneComponent != null) {
      _currentSceneComponent!.removeFromParent();
      _currentSceneComponent = null;
    }
  }
  
  /// Checks if a specific scene is currently active
  bool isSceneActive(GameSceneType sceneType) {
    return _currentScene == sceneType;
  }
}