# CardFanDraggableArea Architecture

## Before Refactoring

```
┌─────────────────────────────────────────┐
│     CardFanDraggableArea                │
│  (Multiple Responsibilities)            │
├─────────────────────────────────────────┤
│ • onTapDown()                           │
│ • onTapUp()                             │
│ • onDragStart()                         │
│ • onDragUpdate()                        │
│ • onDragEnd()                           │
│ • _findCardDragDropArea()               │
│ • render()                              │
│ • _cardFanService management            │
└─────────────────────────────────────────┘
```

**Problems:**
- 5 different responsibilities in one class
- Hard to test each concern independently  
- Changes in one area affect the entire class
- Violates Single Responsibility Principle

## After Refactoring

```
                    ┌──────────────────────────────────┐
                    │   CardFanDraggableArea           │
                    │   (Thin Coordinator)             │
                    │                                  │
                    │  Receives Flame events &         │
                    │  delegates to handlers           │
                    └──────────────────────────────────┘
                              │
              ┌───────────────┼───────────────┐
              │               │               │
              ▼               ▼               ▼
    ┌─────────────────┐ ┌─────────────┐ ┌──────────────────────┐
    │ CardFanInput    │ │ DropArea    │ │ CardFanVisualization │
    │ Handler         │ │ Finder      │ │ Renderer             │
    ├─────────────────┤ ├─────────────┤ ├──────────────────────┤
    │ • onTapDown()   │ │ • findDrop  │ │ • render()           │
    │ • onTapUp()     │ │   Area()    │ │ • showDebugOverlay   │
    │ • onDragStart() │ │             │ │ • overlayColor       │
    │ • onDragUpdate()│ │ (static     │ │                      │
    │ • onDragEnd()   │ │  utility)   │ │ (configurable)       │
    └─────────────────┘ └─────────────┘ └──────────────────────┘
              │
              ▼
    ┌─────────────────┐
    │ CardFanService  │
    │ (existing)      │
    └─────────────────┘
```

## Class Responsibilities

### CardFanDraggableArea (Coordinator)
- **Single Responsibility:** Coordinate between Flame's event system and specialized handlers
- **Changes when:** Coordination logic or component lifecycle changes

### CardFanInputHandler  
- **Single Responsibility:** Receive and delegate input events
- **Changes when:** Input handling flow changes

### DropAreaFinder
- **Single Responsibility:** Navigate component tree to find drop areas
- **Changes when:** Component hierarchy changes

### CardFanVisualizationRenderer
- **Single Responsibility:** Render debug/visualization overlay
- **Changes when:** Rendering requirements change

## Benefits

```
┌────────────────────────────────────────────────────────────┐
│  Single Responsibility Principle (SRP) Compliance          │
├────────────────────────────────────────────────────────────┤
│  ✓ Each class has one reason to change                    │
│  ✓ Concerns are separated                                 │
│  ✓ Easy to test in isolation                              │
│  ✓ Changes are localized                                  │
│  ✓ Code is more reusable                                  │
└────────────────────────────────────────────────────────────┘
```

## Data Flow

```
User Input (Tap/Drag)
    ↓
Flame Event System (TapCallbacks, DragCallbacks)
    ↓
CardFanDraggableArea.onTapDown/onDragStart/etc
    ↓
CardFanInputHandler.onTapDown/onDragStart/etc
    ↓
CardFanService.onTapDown/onDragStart/etc
    ↓
CardFanSelectionService / CardFanDraggableService
    ↓
Update Card State / Move Card / Check Drop Area
```

## Component Tree Hierarchy

```
GameScene
├── Player
│   └── CardFan
│       ├── CardSprite (multiple)
│       └── CardFanDraggableArea  ← We are here
│           ├── CardFanInputHandler (composition)
│           ├── CardFanVisualizationRenderer (composition)
│           └── CardFanService (composition)
└── CardDragDropArea  ← Found by DropAreaFinder
```

## Testing Strategy

### Before (Difficult)
```
Test CardFanDraggableArea
    • Need to mock input events
    • Need to mock component tree
    • Need to mock rendering
    • Need to mock service
    → Complex test setup
```

### After (Easy)
```
Test CardFanInputHandler
    • Only mock CardFanService
    → Simple test

Test DropAreaFinder  
    • Only mock component tree
    → Simple test

Test CardFanVisualizationRenderer
    • Only mock canvas
    → Simple test

Test CardFanDraggableArea
    • Mock all three handlers
    → Simple integration test
```
