import 'package:flutter_test/flutter_test.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:card_battler/game/services/scene_manager.dart';
import 'package:card_battler/game/services/game_state_manager.dart';
import 'package:card_battler/game/models/game_state_model.dart';
import 'package:card_battler/game/services/card_selection_service.dart';
import 'package:card_battler/game/models/shared/card_model.dart';

// Mock classes for testing
class MockRouterComponent extends RouterComponent {
  final List<String> routeStack = [];
  
  MockRouterComponent() : super(routes: {}, initialRoute: 'initial');
  
  @override
  void pushNamed(String name, {bool replace = false}) {
    routeStack.add(name);
  }
  
  @override
  void pop() {
    if (routeStack.isNotEmpty) {
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

      test('showEndTurnConfirmation pushes confirm route', () {
        sceneManager.showEndTurnConfirmation();
        expect(mockRouter.routeStack, contains('confirm'));
      });

      test('pop removes last route', () {
        mockRouter.routeStack.addAll(['playerTurn', 'confirm']);
        sceneManager.pop();
        expect(mockRouter.routeStack, equals(['playerTurn']));
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
        
        // Create router to set up listeners  
        sceneManager.createRouter(Vector2(800, 600));
      });

      test('automatically navigates to enemy turn when phase changes', () {
        gameStateManager.nextPhase(); // waitingToDrawCards -> cardsDrawn
        gameStateManager.nextPhase(); // cardsDrawn -> enemyTurn
        
        expect(mockRouter.routeStack, contains('enemyTurn'));
      });

      test('handles enemy turn to player turn transition with delay', () async {
        gameStateManager.nextPhase(); // waitingToDrawCards -> cardsDrawn
        gameStateManager.nextPhase(); // cardsDrawn -> enemyTurn
        gameStateManager.nextPhase(); // enemyTurn -> playerTurn
        
        // Should trigger delayed pop after enemy turn ends
        await Future.delayed(const Duration(seconds: 2));
        // Note: In a real test environment, we'd need to mock the timer
      });
    });

    group('confirmation dialog handling', () {
      setUp(() {
        sceneManager.initialize(
          router: mockRouter,
          playerTurnScene: MockPlayerTurnScene(),
        );
        
        sceneManager.createRouter(Vector2(800, 600));
      });

      test('shows confirmation dialog when requested by GameStateManager', () {
        gameStateManager.requestConfirmation();
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
        
        expect(() => sceneManager.handleBackgroundDeselection(), returnsNormally);
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
class MockPlayerTurnScene {
  bool deselectCalled = false;
  final MockCardSelectionService cardSelectionService = MockCardSelectionService();
}

class MockCardSelectionService implements CardSelectionService {
  bool deselectCalled = false;
  CardModel? _selectedCard;
  final List<void Function(CardModel?)> _listeners = [];
  
  @override
  void deselectCard() {
    deselectCalled = true;
    _selectedCard = null;
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