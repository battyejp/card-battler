import 'package:flutter_test/flutter_test.dart';
import 'package:flame/game.dart';
import 'package:card_battler/game/services/scene_manager.dart';
import 'package:card_battler/game/services/game_state_manager.dart';
import 'package:card_battler/game/models/game_state_model.dart';
import 'package:card_battler/game/services/card_selection_service.dart';
import 'package:card_battler/game/models/shared/card_model.dart';
import 'package:card_battler/game/scenes/player_turn_scene.dart';
import 'package:card_battler/game/models/player/player_turn_model.dart';
import 'package:card_battler/game/models/player/player_model.dart';
import 'package:card_battler/game/models/player/info_model.dart';
import 'package:card_battler/game/models/player/card_hand_model.dart';
import 'package:card_battler/game/models/shared/card_pile_model.dart';
import 'package:card_battler/game/models/shared/health_model.dart';
import 'package:card_battler/game/models/shared/value_image_label_model.dart';
import 'package:card_battler/game/models/team/team_model.dart';
import 'package:card_battler/game/models/team/bases_model.dart';
import 'package:card_battler/game/models/enemy/enemies_model.dart';
import 'package:card_battler/game/models/shop/shop_model.dart';
import 'package:card_battler/game/services/game_state_service.dart';

// Mock classes for testing
class MockRouterComponent extends RouterComponent {
  final List<String> routeStack = ['initial']; // Start with initial route
  
  MockRouterComponent() : super(routes: {}, initialRoute: 'initial');
  
  @override
  void pushNamed(String name, {bool replace = false}) {
    if (replace && routeStack.isNotEmpty) {
      routeStack.removeLast();
    }
    routeStack.add(name);
  }
  
  @override
  void pop() {
    if (routeStack.length > 1) { // Keep at least one route
      routeStack.removeLast();
    }
  }
}

void main() {
  group('SceneManager', () {
    late SceneManager sceneManager;
    late MockRouterComponent mockRouter;
    late GameStateManager gameStateManager;

    setUp(() {
      sceneManager = SceneManager();
      mockRouter = MockRouterComponent();
      gameStateManager = GameStateManager();
      gameStateManager.reset();
      GameStateModel.reset();
    });

    tearDown(() {
      gameStateManager.clearListeners();
      gameStateManager.reset();
      GameStateModel.reset();
    });

    group('singleton behavior', () {
      test('returns same instance', () {
        final instance1 = SceneManager();
        final instance2 = SceneManager();
        expect(identical(instance1, instance2), isTrue);
      });

      test('maintains state across instances', () {
        final instance1 = SceneManager();
        instance1.initialize(
          router: mockRouter,
          playerTurnScene: MockPlayerTurnScene(),
        );
        
        final instance2 = SceneManager();
        // Should not throw because already initialized
        expect(() => instance2.goToPlayerTurn(), returnsNormally);
      });
    });

    group('initialization', () {
      test('initialize sets up required components', () {
        expect(() => sceneManager.initialize(
          router: mockRouter,
          playerTurnScene: MockPlayerTurnScene(),
        ), returnsNormally);
      });

      test('createRouter returns configured RouterComponent', () {
        final gameSize = Vector2(800, 600);
        final router = sceneManager.createRouter(gameSize);
        
        expect(router, isA<RouterComponent>());
      });

      test('createRouter sets up routes correctly', () {
        final gameSize = Vector2(800, 600);
        final router = sceneManager.createRouter(gameSize);
        
        expect(router.routes.keys, contains('playerTurn'));
        expect(router.routes.keys, contains('enemyTurn'));
        expect(router.routes.keys, contains('confirm'));
      });
    });

    group('navigation methods', () {
      setUp(() {
        sceneManager.initialize(
          router: mockRouter,
          playerTurnScene: MockPlayerTurnScene(),
        );
      });

      test('goToPlayerTurn pushes playerTurn route', () {
        sceneManager.goToPlayerTurn();
        expect(mockRouter.routeStack, contains('playerTurn'));
      });

      test('goToEnemyTurn pushes enemyTurn route', () {
        sceneManager.goToEnemyTurn();
        expect(mockRouter.routeStack, contains('enemyTurn'));
      });

      test('pop removes last route', () {
        // Start with initial route, add two more
        mockRouter.routeStack.addAll(['playerTurn', 'confirm']);
        expect(mockRouter.routeStack, equals(['initial', 'playerTurn', 'confirm']));
        
        sceneManager.pop();
        expect(mockRouter.routeStack, equals(['initial', 'playerTurn']));
      });
    });

    group('game state integration', () {
      setUp(() {
        sceneManager.initialize(
          router: mockRouter,
          playerTurnScene: MockPlayerTurnScene(),
        );
        
        // Create router to set up listeners
        sceneManager.createRouter(Vector2(800, 600));
      });

      test('endPlayerTurn calls model endTurn', () {
        // Set up game state for player turn
        gameStateManager.nextPhase(); // waitingToDrawCards -> cardsDrawn
        gameStateManager.nextPhase(); // cardsDrawn -> enemyTurn
        gameStateManager.nextPhase(); // enemyTurn -> playerTurn
        
        expect(gameStateManager.currentPhase, equals(GamePhase.playerTurn));
        
        sceneManager.endPlayerTurn();
        
        // Should advance to next phase (back to waitingToDrawCards)
        expect(gameStateManager.currentPhase, equals(GamePhase.waitingToDrawCards));
      });

      test('handleTurnButtonPress delegates to model', () {
        // This tests that the method exists and delegates properly
        expect(() => sceneManager.handleTurnButtonPress(), returnsNormally);
      });
    });

    group('phase change listener', () {
      setUp(() {
        sceneManager.initialize(
          router: mockRouter,
          playerTurnScene: MockPlayerTurnScene(),
        );
      });

      test('navigation methods work with mock router', () {
        // Test that the basic navigation methods work correctly
        // This verifies the scene manager can interact with our mock router
        sceneManager.goToEnemyTurn();
        expect(mockRouter.routeStack, contains('enemyTurn'));
        
        sceneManager.goToPlayerTurn();
        expect(mockRouter.routeStack, contains('playerTurn'));
      });
    });

    group('confirmation dialog handling', () {
      setUp(() {
        sceneManager.initialize(
          router: mockRouter,
          playerTurnScene: MockPlayerTurnScene(),
        );
      });

      test('showEndTurnConfirmation pushes confirm route', () {
        sceneManager.showEndTurnConfirmation();
        expect(mockRouter.routeStack, contains('confirm'));
      });
    });

    group('background deselection', () {
      test('handleBackgroundDeselection calls playerTurnScene deselect', () {
        final mockPlayerScene = MockPlayerTurnScene();
        sceneManager.initialize(
          router: mockRouter,
          playerTurnScene: mockPlayerScene,
        );
        
        // Call the method and verify deselect was called
        sceneManager.handleBackgroundDeselection();
        expect(mockPlayerScene.deselectCalled, isTrue);
      });
    });

    group('debug information', () {
      test('debugInfo returns meaningful information', () {
        final debugInfo = sceneManager.debugInfo;
        expect(debugInfo, contains('SceneManager'));
        expect(debugInfo, contains('router'));
      });
    });

    group('error handling and edge cases', () {
      test('handles operations before initialization gracefully', () {
        final freshSceneManager = SceneManager();
        
        // These might throw or handle gracefully - depends on implementation
        // We test that they don't crash the application
        expect(() => freshSceneManager.goToPlayerTurn(), returnsNormally);
        expect(() => freshSceneManager.debugInfo, returnsNormally);
      });

      test('handles multiple initialization calls', () {
        sceneManager.initialize(
          router: mockRouter,
          playerTurnScene: MockPlayerTurnScene(),
        );
        
        // Second initialization should not cause issues
        expect(() => sceneManager.initialize(
          router: mockRouter,
          playerTurnScene: MockPlayerTurnScene(),
        ), returnsNormally);
      });
    });
  });
}

// Mock classes for testing
class MockPlayerTurnScene extends PlayerTurnScene {
  bool deselectCalled = false;
  late final MockCardSelectionService _mockCardSelectionService;

  MockPlayerTurnScene()
      : super(
          model: PlayerTurnModel(
            playerModel: PlayerModel(
              infoModel: InfoModel(
                attack: ValueImageLabelModel(value: 0, label: 'Attack'),
                credits: ValueImageLabelModel(value: 0, label: 'Credits'),
                name: 'Test Player',
                healthModel: HealthModel(maxHealth: 10),
              ),
              handModel: CardHandModel(),
              deckModel: CardPileModel(),
              discardModel: CardPileModel(),
              gameStateService: DummyGameStateService(),
              cardSelectionService: DefaultCardSelectionService(),
            ),
            teamModel: TeamModel(
              bases: BasesModel(bases: []),
              players: [],
            ),
            enemiesModel: EnemiesModel(
              totalEnemies: 1,
              maxNumberOfEnemiesInPlay: 1,
              maxEnemyHealth: 10,
              enemyCards: [],
            ),
            shopModel: ShopModel(
              numberOfRows: 1,
              numberOfColumns: 1,
              cards: [],
            ),
            gameStateService: DummyGameStateService(),
          ),
          size: Vector2(800, 600),
        ) {
    _mockCardSelectionService = MockCardSelectionService();
    _mockCardSelectionService.onDeselectCalled = () {
      deselectCalled = true;
    };
  }

  @override
  CardSelectionService get cardSelectionService => _mockCardSelectionService;
}

class DummyGameStateService implements GameStateService {
  @override
  GamePhase get currentPhase => GamePhase.playerTurn;
  
  @override
  void nextPhase() {}
  
  @override
  void requestConfirmation() {}
}

class MockCardSelectionService implements CardSelectionService {
  bool deselectCalled = false;
  CardModel? _selectedCard;
  final List<void Function(CardModel?)> _listeners = [];
  void Function()? onDeselectCalled;
  
  @override
  void deselectCard() {
    deselectCalled = true;
    _selectedCard = null;
    onDeselectCalled?.call();
  }
  
  @override
  CardModel? get selectedCard => _selectedCard;
  
  @override
  bool isCardSelected(CardModel card) => _selectedCard == card;
  
  @override
  void selectCard(CardModel card) {
    _selectedCard = card;
  }
  
  @override
  bool get hasSelection => _selectedCard != null;
  
  @override
  void addSelectionListener(void Function(CardModel?) listener) {
    _listeners.add(listener);
  }
  
  @override
  void removeSelectionListener(void Function(CardModel?) listener) {
    _listeners.remove(listener);
  }
  
  void reset() {
    _selectedCard = null;
    _listeners.clear();
  }
}