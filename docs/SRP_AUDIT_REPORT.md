# Single Responsibility Principle (SRP) Audit Report

## Executive Summary

This document provides a comprehensive audit of the Card Battler codebase to identify violations of the Single Responsibility Principle (SRP). The audit reviewed 92+ Dart files across the game engine, services, coordinators, models, and UI layers.

**Overall Assessment:** The codebase demonstrates good architectural patterns with clear separation of concerns in most areas. However, several components have been identified that mix multiple responsibilities and could benefit from refactoring.

---

## Critical SRP Violations

### 1. `lib/main.dart` - Multiple Platform Concerns
**Location:** `lib/main.dart:6-13`

**Issues:**
- Mixes application initialization, platform configuration, and system UI setup
- Handles three distinct responsibilities:
  1. Flutter binding initialization
  2. Device orientation configuration (SystemChrome)
  3. System UI mode configuration (SystemChrome)
  4. App launching

**Current Code:**
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(const CardBattlerApp());
}
```

**Recommendation:**
Extract platform configuration into a dedicated service:

```dart
// lib/services/platform_configuration_service.dart
class PlatformConfigurationService {
  static Future<void> configureForGame() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }
}

// lib/main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PlatformConfigurationService.configureForGame();
  runApp(const CardBattlerApp());
}
```

**Impact:** Low - The violation is minor but extracting it improves testability and clarity.

---

### 2. `lib/screens/loading_screen.dart` - Mixed UI and Business Logic
**Location:** `lib/screens/loading_screen.dart:11-45`

**Issues:**
- Combines UI rendering, state management, and navigation logic
- The `_simulateLoading()` method contains hardcoded timing logic
- Directly renders different widgets based on state (violates separation of presentation)

**Current Structure:**
```dart
class _LoadingScreenState extends State<LoadingScreen> {
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _simulateLoading();  // Business logic in UI component
  }

  Future<void> _simulateLoading() async {
    await Future.delayed(const Duration(seconds: 2));  // Hardcoded delay
    setState(() {
      _isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoaded) {
      return const Scaffold(...);  // Conditional rendering
    } else {
      return const MenuScreen();   // Direct navigation
    }
  }
}
```

**Recommendation:**
Separate concerns into dedicated components:

```dart
// lib/services/loading_service.dart
class LoadingService {
  static const Duration loadingDuration = Duration(seconds: 2);
  
  Future<bool> performInitialization() async {
    await Future.delayed(loadingDuration);
    // Future: Add actual initialization logic here
    return true;
  }
}

// lib/screens/loading_screen.dart
class _LoadingScreenState extends State<LoadingScreen> {
  final _loadingService = LoadingService();
  
  @override
  void initState() {
    super.initState();
    _initializeAndNavigate();
  }

  Future<void> _initializeAndNavigate() async {
    final success = await _loadingService.performInitialization();
    if (success && mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MenuScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) => const Scaffold(
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 20),
          Text('Loading...', style: TextStyle(fontSize: 24)),
        ],
      ),
    ),
  );
}
```

**Impact:** Medium - Improves separation of concerns and makes the loading logic testable and reusable.

---

### 3. `lib/screens/game_screen.dart` - GameOverlay Mixed Concerns
**Location:** `lib/screens/game_screen.dart:33-81`

**Issues:**
- `_GameOverlayState` manages both UI state and game navigation
- Combines view rendering with navigation logic
- Direct coupling to `GameNavigationService`

**Current Code:**
```dart
class _GameOverlayState extends State<GameOverlay> {
  bool _isInShop = false;  // UI state

  void _toggleView() {  // Mixed logic
    setState(() {
      _isInShop = !_isInShop;
    });

    if (_isInShop) {
      widget.navigationService.navigateToShop();  // Navigation
    } else {
      widget.navigationService.navigateBackFromShop();
    }
  }

  @override
  Widget build(BuildContext context) => SafeArea(
    child: Padding(
      padding: const EdgeInsets.all(0.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () => Navigator.of(context).pop(),  // Navigation
                icon: const Icon(Icons.arrow_back, size: 20),
                // ... styling
              ),
              IconButton(
                onPressed: _toggleView,
                icon: Icon(_isInShop ? Icons.gamepad : Icons.shop_2, size: 20),
                // ... styling
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
```

**Recommendation:**
Extract UI state management from navigation logic:

```dart
// lib/screens/game_screen_overlay_controller.dart
class GameScreenOverlayController {
  GameScreenOverlayController(this._navigationService);
  
  final GameNavigationService _navigationService;
  bool _isInShop = false;
  
  bool get isInShop => _isInShop;
  
  void toggleView() {
    _isInShop = !_isInShop;
    
    if (_isInShop) {
      _navigationService.navigateToShop();
    } else {
      _navigationService.navigateBackFromShop();
    }
  }
}

// Updated GameOverlay
class _GameOverlayState extends State<GameOverlay> {
  late final GameScreenOverlayController _controller;
  
  @override
  void initState() {
    super.initState();
    _controller = GameScreenOverlayController(widget.navigationService);
  }
  
  void _handleToggle() {
    setState(() {
      _controller.toggleView();
    });
  }
  
  // ... build method with cleaner separation
}
```

**Impact:** Low-Medium - Better separation but current implementation is acceptable for a simple UI.

---

## Moderate SRP Violations

### 4. `lib/game/services/game/coordinators_manager.dart` - God Object Pattern
**Location:** `lib/game/services/game/coordinators_manager.dart:20-102`

**Issues:**
- Orchestrates creation of ALL game coordinators
- Contains complex initialization logic with dependencies
- Manages lifecycle of multiple unrelated coordinator types
- 102 lines of constructor logic performing multiple setup tasks

**Responsibilities Identified:**
1. Creating player coordinators
2. Creating team coordinator
3. Configuring effect processor
4. Configuring active player manager
5. Creating enemy coordinators
6. Creating enemy turn coordinator
7. Creating shop coordinator
8. Creating game scene coordinator
9. Managing coordinator references

**Current Code Structure:**
```dart
class CoordinatorsManager {
  CoordinatorsManager(
    GamePhaseManager gamePhaseManager,
    GameStateModel state,
    ActivePlayerManager activePlayerManager,
    DialogService dialogService,
  ) {
    // Creates effect processor
    final effectProcessor = EffectProcessor();

    // Creates player coordinators
    final playerCoordinators = PlayerCoordinatorFactory.createPlayerCoordinators(...);

    // Creates team coordinator
    final teamCoordinator = TeamCoordinatorFactory.createTeamCoordinator(...);

    // Configures effect processor
    effectProcessor.teamCoordinator = teamCoordinator;

    // Configures active player manager
    activePlayerManager.players = playerCoordinators;
    activePlayerManager.setNextPlayerToActive();

    // Creates enemy coordinators
    final enemyCoordinators = EnemyCoordinatorFactory.createEnemyCoordinators(...);

    // Creates enemy turn coordinator
    _enemyTurnSceneCoordinator = EnemyCoordinatorFactory.createEnemyTurnSceneCoordinator(...);

    // Creates enemies coordinator
    final enemiesCoordinator = EnemyCoordinatorFactory.createEnemiesCoordinator(...);

    // Creates shop coordinator
    _shopSceneCoordinator = ShopSceneCoordinatorFactory.createShopCoordinator(...);

    // Creates game scene coordinator
    _gameSceneCoordinator = GameSceneCoordinatorFactory.createGameSceneCoordinator(...);
  }

  late GameSceneCoordinator _gameSceneCoordinator;
  late EnemyTurnCoordinator _enemyTurnSceneCoordinator;
  late ShopSceneCoordinator _shopSceneCoordinator;

  GameSceneCoordinator get gameSceneCoordinator => _gameSceneCoordinator;
  EnemyTurnCoordinator get enemyTurnSceneCoordinator => _enemyTurnSceneCoordinator;
  ShopSceneCoordinator get shopSceneCoordinator => _shopSceneCoordinator;
}
```

**Recommendation:**
Break down into specialized coordinator builders:

```dart
// lib/game/services/game/coordinators/player_coordinators_builder.dart
class PlayerCoordinatorsBuilder {
  static PlayerCoordinatorsResult build({
    required GameStateModel state,
    required GamePhaseManager gamePhaseManager,
    required ActivePlayerManager activePlayerManager,
  }) {
    final effectProcessor = EffectProcessor();
    
    final playerCoordinators = PlayerCoordinatorFactory.createPlayerCoordinators(
      players: state.players,
      gamePhaseManager: gamePhaseManager,
      activePlayerManager: activePlayerManager,
      effectProcessor: effectProcessor,
    );
    
    final teamCoordinator = TeamCoordinatorFactory.createTeamCoordinator(
      playerCoordinators: playerCoordinators,
      state: state,
    );
    
    effectProcessor.teamCoordinator = teamCoordinator;
    activePlayerManager.players = playerCoordinators;
    activePlayerManager.setNextPlayerToActive();
    
    return PlayerCoordinatorsResult(
      playerCoordinators: playerCoordinators,
      teamCoordinator: teamCoordinator,
      effectProcessor: effectProcessor,
    );
  }
}

// lib/game/services/game/coordinators/enemy_coordinators_builder.dart
class EnemyCoordinatorsBuilder {
  static EnemyCoordinatorsResult build({
    required GameStateModel state,
    required GamePhaseManager gamePhaseManager,
    required ActivePlayerManager activePlayerManager,
    required EffectProcessor effectProcessor,
  }) {
    // Enemy coordinator creation logic
  }
}

// lib/game/services/game/coordinators/scene_coordinators_builder.dart
class SceneCoordinatorsBuilder {
  static SceneCoordinatorsResult build({
    required PlayerCoordinatorsResult playerResult,
    required EnemyCoordinatorsResult enemyResult,
    required GameStateModel state,
    required GamePhaseManager gamePhaseManager,
    required ActivePlayerManager activePlayerManager,
    required DialogService dialogService,
  }) {
    // Scene coordinator creation logic
  }
}

// Simplified CoordinatorsManager
class CoordinatorsManager {
  CoordinatorsManager(
    GamePhaseManager gamePhaseManager,
    GameStateModel state,
    ActivePlayerManager activePlayerManager,
    DialogService dialogService,
  ) {
    final playerResult = PlayerCoordinatorsBuilder.build(
      state: state,
      gamePhaseManager: gamePhaseManager,
      activePlayerManager: activePlayerManager,
    );
    
    final enemyResult = EnemyCoordinatorsBuilder.build(
      state: state,
      gamePhaseManager: gamePhaseManager,
      activePlayerManager: activePlayerManager,
      effectProcessor: playerResult.effectProcessor,
    );
    
    final sceneResult = SceneCoordinatorsBuilder.build(
      playerResult: playerResult,
      enemyResult: enemyResult,
      state: state,
      gamePhaseManager: gamePhaseManager,
      activePlayerManager: activePlayerManager,
      dialogService: dialogService,
    );
    
    _gameSceneCoordinator = sceneResult.gameSceneCoordinator;
    _enemyTurnSceneCoordinator = sceneResult.enemyTurnSceneCoordinator;
    _shopSceneCoordinator = sceneResult.shopSceneCoordinator;
  }
  
  // ... getters
}
```

**Impact:** High - This is the most significant violation. Breaking it down would greatly improve:
- Testability (each builder can be tested independently)
- Maintainability (easier to understand and modify specific coordinator creation)
- Reusability (builders can be used independently)
- Debugging (clearer responsibility boundaries)

---

### 5. `lib/game/services/game/game_phase_manager.dart` - Mixed State and Notification
**Location:** `lib/game/services/game/game_phase_manager.dart:21-104`

**Issues:**
- Manages game phase state transitions
- Implements observer pattern for phase change notifications
- Contains complex phase transition logic
- Manages listener lifecycle

**Current Responsibilities:**
1. Game phase state management
2. Phase transition logic (switch statement with business rules)
3. Round and player turn tracking
4. Observer pattern implementation (listener management and notification)

**Current Code:**
```dart
class GamePhaseManager {
  GamePhaseManager({required int numberOfPlayers})
    : _numberOfPlayers = numberOfPlayers;

  GamePhase _currentPhase = GamePhase.waitingToDrawPlayerCards;
  GamePhase _previousPhase = GamePhase.waitingToDrawPlayerCards;
  int _round = 0;
  int _playerTurn = 0;
  final int _numberOfPlayers;
  final List<Function(GamePhase, GamePhase)> _phaseChangeListeners = [];

  GamePhase get currentPhase => _currentPhase;

  void addPhaseChangeListener(Function(GamePhase, GamePhase) listener) {
    _phaseChangeListeners.add(listener);
  }

  void removePhaseChangeListener(Function(GamePhase, GamePhase) listener) {
    _phaseChangeListeners.remove(listener);
  }

  void _notifyPhaseChange(GamePhase previousPhase, GamePhase newPhase) {
    for (final listener in _phaseChangeListeners) {
      try {
        listener(previousPhase, newPhase);
      } catch (e) {
        // Error handling
      }
    }
  }

  GamePhase nextPhase() {
    switch (_currentPhase) {
      case GamePhase.playerCardsDrawnWaitingForEnemyTurn:
        _setPhase(GamePhase.enemyTurnWaitingToDrawCards);
        break;
      // ... complex transition logic
    }
    return _currentPhase;
  }

  void _setPhase(GamePhase newPhase) {
    if (_currentPhase != newPhase) {
      _previousPhase = _currentPhase;
      _currentPhase = newPhase;
      _notifyPhaseChange(_previousPhase, newPhase);
    }
  }
}
```

**Recommendation:**
Extract the observer pattern into a mixin or separate class:

```dart
// lib/game/services/common/phase_change_notifier.dart
mixin PhaseChangeNotifier {
  final List<Function(GamePhase, GamePhase)> _phaseChangeListeners = [];

  void addPhaseChangeListener(Function(GamePhase, GamePhase) listener) {
    _phaseChangeListeners.add(listener);
  }

  void removePhaseChangeListener(Function(GamePhase, GamePhase) listener) {
    _phaseChangeListeners.remove(listener);
  }

  void notifyPhaseChange(GamePhase previousPhase, GamePhase newPhase) {
    for (final listener in _phaseChangeListeners) {
      try {
        listener(previousPhase, newPhase);
      } catch (e) {
        // Log error - in production, use proper logging
      }
    }
  }
  
  void dispose() {
    _phaseChangeListeners.clear();
  }
}

// Updated GamePhaseManager
class GamePhaseManager with PhaseChangeNotifier {
  GamePhaseManager({required int numberOfPlayers})
    : _numberOfPlayers = numberOfPlayers;

  GamePhase _currentPhase = GamePhase.waitingToDrawPlayerCards;
  GamePhase _previousPhase = GamePhase.waitingToDrawPlayerCards;
  int _round = 0;
  int _playerTurn = 0;
  final int _numberOfPlayers;

  GamePhase get currentPhase => _currentPhase;

  GamePhase nextPhase() {
    // Transition logic remains
    return _currentPhase;
  }

  void _setPhase(GamePhase newPhase) {
    if (_currentPhase != newPhase) {
      _previousPhase = _currentPhase;
      _currentPhase = newPhase;
      notifyPhaseChange(_previousPhase, newPhase);  // From mixin
    }
  }
}
```

**Impact:** Medium - Improves code organization and reusability of the observer pattern.

---

### 6. `lib/game/services/ui/dialog_service.dart` - Mixed Dialog Management and Routing
**Location:** `lib/game/services/ui/dialog_service.dart:5-59`

**Issues:**
- Manages dialog state (current title, message, callbacks)
- Creates dialog routes
- Handles dialog lifecycle
- Couples routing concerns with dialog state management

**Current Code:**
```dart
class DialogService {
  RouterComponent? _router;

  void initialize({required RouterComponent router}) {
    _router = router;
  }

  VoidCallback? _currentOnConfirm;
  VoidCallback? _currentOnCancel;
  String _currentTitle = 'Confirm Action';
  String _currentMessage = 'Are you sure you want to continue?';

  /// Get confirmation dialog route for router setup
  Map<String, Route> getDialogRoutes() => {
      'confirm': OverlayRoute((context, game) => ConfirmDialog(
          title: _currentTitle,
          message: _currentMessage,
          onCancel: _handleConfirmCancel,
          onConfirm: _handleConfirmAccept,
        )),
    };

  /// Show custom confirmation dialog
  void showCustomConfirmation({
    required String title,
    required String message,
    required VoidCallback onConfirm,
    required VoidCallback onCancel,
  }) {
    if (_router == null) {
      return;
    }

    _currentTitle = title;
    _currentMessage = message;
    _currentOnConfirm = onConfirm;
    _currentOnCancel = onCancel;

    try {
      _router!.pushNamed('confirm');
    } catch (e) {
      onConfirm();
    }
  }

  void _handleConfirmCancel() {
    _router?.pop();
    _currentOnCancel?.call();
  }

  void _handleConfirmAccept() {
    _router?.pop();
    _currentOnConfirm?.call();
  }
}
```

**Recommendation:**
Separate dialog state from routing logic:

```dart
// lib/game/services/ui/dialog_state.dart
class DialogState {
  DialogState({
    this.title = 'Confirm Action',
    this.message = 'Are you sure you want to continue?',
    this.onConfirm,
    this.onCancel,
  });
  
  final String title;
  final String message;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
}

// lib/game/services/ui/dialog_service.dart
class DialogService {
  RouterComponent? _router;
  DialogState _currentState = DialogState();

  void initialize({required RouterComponent router}) {
    _router = router;
  }

  Map<String, Route> getDialogRoutes() => {
    'confirm': OverlayRoute((context, game) => ConfirmDialog(
      title: _currentState.title,
      message: _currentState.message,
      onCancel: _handleConfirmCancel,
      onConfirm: _handleConfirmAccept,
    )),
  };

  void showCustomConfirmation({
    required String title,
    required String message,
    required VoidCallback onConfirm,
    required VoidCallback onCancel,
  }) {
    if (_router == null) {
      return;
    }

    _currentState = DialogState(
      title: title,
      message: message,
      onConfirm: onConfirm,
      onCancel: onCancel,
    );

    try {
      _router!.pushNamed('confirm');
    } catch (e) {
      onConfirm();
    }
  }

  void _handleConfirmCancel() {
    _router?.pop();
    _currentState.onCancel?.call();
  }

  void _handleConfirmAccept() {
    _router?.pop();
    _currentState.onConfirm?.call();
  }
}
```

**Impact:** Low-Medium - Improves state encapsulation and makes dialog state testable.

---

### 7. `lib/game/coordinators/components/scenes/game_scene_coordinator.dart` - Multiple Coordination Responsibilities
**Location:** `lib/game/coordinators/components/scenes/game_scene_coordinator.dart:13-93`

**Issues:**
- Coordinates game scene rendering
- Listens to game phase changes
- Listens to active player changes
- Manages turn lifecycle
- Delegates to turn lifecycle manager
- Configures shop card purchase callback

**Current Responsibilities:**
1. Scene coordinator (primary responsibility)
2. Phase change observer and handler
3. Active player observer and handler
4. Turn lifecycle management delegation
5. Shop integration
6. Reactive coordinator (via mixin)

**Recommendation:**
Extract observation handlers into dedicated classes:

```dart
// lib/game/coordinators/components/scenes/game_scene_phase_handler.dart
class GameScenePhaseHandler {
  GameScenePhaseHandler({
    required PlayerTurnLifecycleManager turnLifecycleManager,
    required Function() onSceneChange,
  }) : _turnLifecycleManager = turnLifecycleManager,
       _onSceneChange = onSceneChange;
  
  final PlayerTurnLifecycleManager _turnLifecycleManager;
  final Function() _onSceneChange;
  
  void handlePhaseChange(GamePhase previousPhase, GamePhase newPhase) {
    if (_turnLifecycleManager.isTurnOver(previousPhase, newPhase)) {
      _turnLifecycleManager.handleTurnEnd();
    } else if (_turnLifecycleManager.hasSwitchedBetweenPlayerAndEnemyTurn(newPhase)) {
      _onSceneChange();
    }
  }
}

// lib/game/coordinators/components/scenes/game_scene_player_handler.dart
class GameScenePlayerHandler {
  GameScenePlayerHandler({
    required PlayerTurnLifecycleManager turnLifecycleManager,
    required Function(PlayerCoordinator) onPlayerChange,
  }) : _turnLifecycleManager = turnLifecycleManager,
       _onPlayerChange = onPlayerChange;
  
  final PlayerTurnLifecycleManager _turnLifecycleManager;
  final Function(PlayerCoordinator) _onPlayerChange;
  
  void handleActivePlayerChange(PlayerCoordinator newActivePlayer) {
    _turnLifecycleManager.updatePlayerCoordinator(newActivePlayer);
    _onPlayerChange(newActivePlayer);
  }
}

// Simplified GameSceneCoordinator
class GameSceneCoordinator with ReactiveCoordinator<GameSceneCoordinator> {
  GameSceneCoordinator({...}) {
    _phaseHandler = GameScenePhaseHandler(
      turnLifecycleManager: _turnLifecycleManager,
      onSceneChange: notifyChange,
    );
    
    _playerHandler = GameScenePlayerHandler(
      turnLifecycleManager: _turnLifecycleManager,
      onPlayerChange: _handlePlayerChange,
    );
    
    gamePhaseManager.addPhaseChangeListener(_phaseHandler.handlePhaseChange);
    _activePlayerManager.addActivePlayerChangeListener(_playerHandler.handleActivePlayerChange);
    
    shopCoordinator.onCardBought = (card) {
      playerCoordinator.discardCardsCoordinator.addCard(card);
    };
  }
  
  late final GameScenePhaseHandler _phaseHandler;
  late final GameScenePlayerHandler _playerHandler;
  
  void _handlePlayerChange(PlayerCoordinator newActivePlayer) {
    _playerCoordinator = newActivePlayer;
    notifyChange();
  }
  
  // ... rest of implementation
}
```

**Impact:** Medium - Reduces complexity of GameSceneCoordinator and makes handlers testable independently.

---

## Minor SRP Violations

### 8. `lib/game/services/player/active_player_manager.dart` - Mixed Player Tracking and Notification
**Location:** `lib/game/services/player/active_player_manager.dart:4-70`

**Issues:**
- Manages active player state
- Implements observer pattern for active player changes
- Listens to game phase changes
- Updates player coordinator states

**Recommendation:**
Similar to GamePhaseManager, extract the observer pattern:

```dart
mixin ActivePlayerChangeNotifier {
  final List<Function(PlayerCoordinator)> _activePlayerChangeListeners = [];

  void addActivePlayerChangeListener(Function(PlayerCoordinator) listener) {
    _activePlayerChangeListeners.add(listener);
  }

  void removeActivePlayerChangeListener(Function(PlayerCoordinator) listener) {
    _activePlayerChangeListeners.remove(listener);
  }

  void notifyActivePlayerChange(PlayerCoordinator newActivePlayer) {
    for (final listener in _activePlayerChangeListeners) {
      try {
        listener(newActivePlayer);
      } catch (e) {
        // Error handling
      }
    }
  }
}
```

**Impact:** Low - Similar improvement to GamePhaseManager refactoring.

---

### 9. `lib/game/models/game_state_model.dart` - Factory Pattern in Model
**Location:** `lib/game/models/game_state_model.dart:21-54`

**Issues:**
- Model class contains factory initialization logic
- Mixes data structure with initialization/creation logic
- `initialize` factory method orchestrates creation using multiple factories

**Current Code:**
```dart
class GameStateModel {
  // Constructor
  GameStateModel({...});

  // Factory method with complex initialization
  factory GameStateModel.initialize(
    List<ShopCardModel> shopCards,
    List<CardModel> playerDeckCards,
    List<CardModel> enemyCards,
    List<BaseModel> bases, {
    GameConfiguration config = GameConfiguration.defaultConfig,
  }) {
    final players = PlayerFactory.createPlayers(...);
    final enemiesModel = EnemyFactory.createEnemiesModel(...);
    final basesModel = BaseFactory.createBases(...);

    return GameStateModel(
      shop: ShopModel(...),
      players: players,
      enemiesModel: enemiesModel,
      bases: basesModel,
    );
  }

  // Model properties
  final ShopModel shop;
  final List<PlayerModel> players;
  final EnemiesModel enemiesModel;
  final List<BaseModel> bases;

  PlayerModel get activePlayer => players.firstWhere((player) => player.isActive);
}
```

**Recommendation:**
The initialization is already extracted to `GameStateFactory`, so remove the factory from the model:

```dart
class GameStateModel {
  GameStateModel({
    required this.shop,
    required this.players,
    required this.bases,
    required this.enemiesModel,
  });

  final ShopModel shop;
  final List<PlayerModel> players;
  final EnemiesModel enemiesModel;
  final List<BaseModel> bases;

  PlayerModel get activePlayer => players.firstWhere((player) => player.isActive);
}
```

Move all initialization logic to `GameStateFactory.create()` method.

**Impact:** Low - The factory is already extracted, but removing the duplicate factory method improves clarity.

---

## Good SRP Practices Found

The following components demonstrate excellent adherence to SRP:

### 1. `lib/game/services/card/card_loader_service.dart`
- **Single Responsibility:** Loading cards from JSON files
- **Why it's good:** Pure utility service with clear, focused purpose
- Generic implementation supports reuse without modification

### 2. `lib/screens/services/game_navigation_service.dart`
- **Single Responsibility:** Game scene navigation
- **Why it's good:** Encapsulates all navigation logic, separating it from UI state
- Clean API with focused methods

### 3. `lib/game/services/initialization/game_state_factory.dart`
- **Single Responsibility:** Creating initial game state
- **Why it's good:** Focused factory that loads data and delegates to model initialization
- Clear separation from the model itself

### 4. `lib/game/services/card/effects/effect_processor.dart`
- **Single Responsibility:** Processing card effects
- **Why it's good:** Focused on effect application, delegates target resolution and handling

### 5. `lib/game/coordinators/common/reactive_coordinator.dart`
- **Single Responsibility:** Providing reactive capabilities
- **Why it's good:** Clean mixin pattern for reusable reactive behavior
- Single concern: change notification

### 6. `lib/game/factories/team_coordinator_factory.dart`
- **Single Responsibility:** Creating team coordinators
- **Why it's good:** Focused factory with single static creation method
- Clear purpose and minimal dependencies

### 7. `lib/game/services/turn/player_turn_lifecycle_manager.dart`
- **Single Responsibility:** Managing player turn lifecycle
- **Why it's good:** Encapsulates all turn end logic
- Clear methods for specific lifecycle phases

---

## Summary of Recommendations

### Priority 1 (High Impact)
1. **Refactor CoordinatorsManager** - Break into specialized builders
   - Most significant violation
   - Greatest impact on testability and maintainability

### Priority 2 (Medium Impact)
2. **Extract Platform Configuration** from main.dart
3. **Refactor LoadingScreen** - Separate loading logic from UI
4. **Simplify GameSceneCoordinator** - Extract handlers
5. **Refactor GamePhaseManager** - Extract observer pattern

### Priority 3 (Low Impact)
6. **Simplify DialogService** - Extract dialog state
7. **Clean up GameStateModel** - Remove duplicate factory
8. **Refactor GameOverlay** - Extract controller
9. **Refactor ActivePlayerManager** - Extract observer pattern

---

## Conclusion

The Card Battler codebase demonstrates solid architectural patterns with most components following SRP well. The primary areas for improvement are:

1. **God Objects:** The `CoordinatorsManager` class tries to do too much
2. **Mixed Concerns:** Some UI components mix rendering, state, and navigation
3. **Observer Pattern Duplication:** The observer pattern is implemented multiple times; consider a reusable mixin

The recommended refactorings would improve:
- **Testability:** Smaller, focused components are easier to test
- **Maintainability:** Clear responsibilities make changes safer
- **Reusability:** Extracted components can be reused elsewhere
- **Debugging:** Clearer boundaries make issues easier to track

Overall, the codebase is in good shape, and these recommendations would polish an already well-structured application.

---

## Appendix: Files Reviewed

### Game Engine (21 files)
- lib/game/card_battler_game.dart
- lib/game/game_variables.dart
- lib/game/config/game_configuration.dart

### Models (14 files)
- lib/game/models/game_state_model.dart
- lib/game/models/player/player_model.dart
- lib/game/models/enemy/enemy_model.dart
- lib/game/models/card/card_model.dart
- lib/game/models/shop/shop_model.dart
- And 9 more model files

### Services (19 files)
- All files in lib/game/services/ directory
- Including initialization, game, player, turn, UI, and card services

### Coordinators (18 files)
- All files in lib/game/coordinators/ directory
- Including player, enemy, team, shop, scene coordinators

### UI Components (20+ files)
- All files in lib/game/ui/components/ directory

### Application Layer (4 files)
- lib/main.dart
- lib/card_battler_app.dart
- lib/screens/*.dart

**Total Files Reviewed:** 92+ Dart files
