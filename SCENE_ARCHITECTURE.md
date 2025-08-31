# Scene-Based Architecture Migration

## Overview

The EnemyTurnArea has been refactored from an overlay-based approach to a dedicated scene-based architecture for better separation of concerns and improved maintainability.

## Architecture Changes

### Before (Overlay-Based)
```
CardBattlerGame
├── World (main game components)
│   ├── Player
│   ├── Enemies  
│   ├── Shop
│   └── Team
└── Camera.viewport
    └── EnemyTurnArea (Overlay) // Added/removed dynamically
```

### After (Scene-Based)
```
CardBattlerGame
└── SceneManager
    ├── MainGameScene (Component)
    │   ├── Player
    │   ├── Enemies
    │   ├── Shop  
    │   └── Team
    └── EnemyTurnScene (Component) // Transitions in/out cleanly
        ├── PlayArea (RectangleComponent)
        ├── CardDeck
        ├── CardPile
        └── PlayerStats[]
```

## Key Components

### EnemyTurnScene
- **Location**: `lib/game/scenes/enemy_turn_scene.dart`
- **Purpose**: Dedicated scene for enemy turn phase
- **Features**:
  - Same visual components as original overlay
  - Fade in/out animations
  - Model integration for game logic
  - Scene completion callbacks

### SceneManager  
- **Location**: `lib/game/scenes/scene_manager.dart`
- **Purpose**: Manages transitions between game scenes
- **Features**:
  - Scene type tracking (`GameSceneType.main`, `GameSceneType.enemyTurn`)
  - Smooth transitions between scenes
  - Proper cleanup of previous scenes
  - Size management for scene components

## Benefits

1. **Better Separation of Concerns**: Each game phase has its own dedicated scene
2. **Improved Maintainability**: Scene logic is isolated and easier to modify
3. **Scalable Architecture**: Easy to add new scenes (shopping, battle end, etc.)
4. **Cleaner Code**: No overlay-specific logic mixed with game logic
5. **Proper State Management**: Game state preserved during scene transitions

## Usage Example

```dart
// Transition to enemy turn
final enemyTurnScene = EnemyTurnScene(
  model: gameState.enemyTurnArea,
  onSceneComplete: () => returnToMainScene(),
);

sceneManager.transitionToScene(
  GameSceneType.enemyTurn,
  enemyTurnScene,
);

// Return to main game  
sceneManager.returnToMainScene(mainGameScene);
```

## Testing

Comprehensive test coverage includes:
- Unit tests for `EnemyTurnScene` functionality
- Unit tests for `SceneManager` transitions  
- Integration tests for complete game flow
- Edge case handling and error scenarios

## Migration Notes

- Original `EnemyTurnArea` class marked as `@deprecated`
- Existing game state models unchanged (no breaking changes)
- All original functionality preserved with improved architecture
- Compatible with Flame 1.30.1 (no RouterComponent dependency)