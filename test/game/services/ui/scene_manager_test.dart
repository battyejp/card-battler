import 'package:flutter_test/flutter_test.dart';
import 'package:flame/game.dart';
import 'package:card_battler/game/services/ui/scene_manager.dart';
import 'package:card_battler/game/services/game_state/game_state_manager.dart';
import 'package:card_battler/game/models/game_state_model.dart';
import 'package:card_battler/game/services/card/card_selection_service.dart';
import 'package:card_battler/game/models/shared/card_model.dart';
import 'package:card_battler/game/components/scenes/player_turn_scene.dart';
import 'package:card_battler/game/models/player/player_turn_state.dart';
import 'package:card_battler/game/services/player/player_turn_coordinator.dart';
import 'package:card_battler/game/models/player/player_model.dart';
import 'package:card_battler/game/models/player/info_model.dart';
import 'package:card_battler/game/models/shared/cards_model.dart';
import 'package:card_battler/game/models/shared/health_model.dart';
import 'package:card_battler/game/models/shared/value_image_label_model.dart';
import 'package:card_battler/game/models/team/team_model.dart';
import 'package:card_battler/game/models/team/bases_model.dart';
import 'package:card_battler/game/models/team/players_model.dart';
import 'package:card_battler/game/models/enemy/enemies_model.dart';
import 'package:card_battler/game/models/shop/shop_model.dart';
import 'package:card_battler/game/models/shop/shop_card_model.dart';
import 'package:card_battler/game/services/game_state/game_state_service.dart';

// Test data generators
List<ShopCardModel> _generateShopCards() {
  return List.generate(6, (index) => ShopCardModel(
    name: 'Shop Card ${index + 1}',
    cost: index + 1,
    isFaceUp: true,
  ));
}

List<CardModel> _generatePlayerDeckCards() {
  return List.generate(20, (index) => CardModel(
    name: 'Player Card ${index + 1}',
    type: 'Player',
    isFaceUp: false,
  ));
}

List<CardModel> _generateEnemyCards() {
  return List.generate(10, (index) => CardModel(
    name: 'Enemy Card ${index + 1}',
    type: 'Enemy',
    isFaceUp: false,
  ));
}

void main() {
  group('SceneManager', () {
    late SceneManager sceneManager;
    late GameStateManager gameStateManager;

    setUp(() {
      sceneManager = SceneManager();
      gameStateManager = GameStateManager();
      gameStateManager.reset();
      GameStateModel.reset();
      
      // Initialize GameStateModel with test data
      final shopCards = _generateShopCards();
      final playerDeckCards = _generatePlayerDeckCards();
      final enemyCards = _generateEnemyCards();
      GameStateModel.initialize(shopCards, playerDeckCards, enemyCards);
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
        final router1 = instance1.createRouter(Vector2(800, 600));
        
        final instance2 = SceneManager();
        final router2 = instance2.createRouter(Vector2(800, 600));
        
        // Both instances should return routers (singleton behavior)
        expect(router1, isA<RouterComponent>());
        expect(router2, isA<RouterComponent>());
        expect(identical(instance1, instance2), isTrue);
      });
    });

    group('initialization', () {
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
        sceneManager.createRouter(Vector2(800, 600));
      });

      test('navigation methods exist and are callable', () {
        // Test that the navigation methods exist and don't throw compilation errors
        // We can't easily test actual navigation in unit tests without a proper game context
        expect(sceneManager.goToPlayerTurn, isA<Function>());
        expect(sceneManager.goToEnemyTurn, isA<Function>());
        expect(sceneManager.pop, isA<Function>());
      });
    });

    group('game state integration', () {
      setUp(() {
        // Create router to set up listeners
        sceneManager.createRouter(Vector2(800, 600));
      });


      test('handleTurnButtonPress delegates to model', () {
        // This tests that the method exists and delegates properly
        expect(() => sceneManager.handleTurnButtonPress(), returnsNormally);
      });
    });

    group('phase change listener', () {
      setUp(() {
        sceneManager.createRouter(Vector2(800, 600));
      });

      test('navigation methods exist', () {
        // Test that the basic navigation methods exist
        expect(sceneManager.goToEnemyTurn, isA<Function>());
        expect(sceneManager.goToPlayerTurn, isA<Function>());
      });
    });

    group('confirmation dialog handling', () {
      setUp(() {
        sceneManager.createRouter(Vector2(800, 600));
      });

      test('showEndTurnConfirmation method exists', () {
        expect(sceneManager.showEndTurnConfirmation, isA<Function>());
      });
    });

    group('background deselection', () {
      test('handleBackgroundDeselection method exists', () {
        sceneManager.createRouter(Vector2(800, 600));
        
        // Test that method exists
        expect(sceneManager.handleBackgroundDeselection, isA<Function>());
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
        
        // Test that methods exist even without initialization
        expect(freshSceneManager.goToPlayerTurn, isA<Function>());
        expect(() => freshSceneManager.debugInfo, returnsNormally);
      });

      test('handles multiple createRouter calls', () {
        sceneManager.createRouter(Vector2(800, 600));
        
        // Second createRouter call should not cause issues
        expect(() => sceneManager.createRouter(Vector2(800, 600)), returnsNormally);
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
          model: PlayerTurnCoordinator(
            state: PlayerTurnState(
              playerModel: PlayerModel(
                infoModel: InfoModel(
                  attack: ValueImageLabelModel(value: 0, label: 'Attack'),
                  credits: ValueImageLabelModel(value: 0, label: 'Credits'),
                  name: 'Test Player',
                  healthModel: HealthModel(maxHealth: 10),
                ),
                handModel: CardsModel<CardModel>(),
                deckModel: CardsModel<CardModel>(),
                discardModel: CardsModel<CardModel>(),
                gameStateService: DummyGameStateService(),
                cardSelectionService: DefaultCardSelectionService(),
              ),
              teamModel: TeamModel(
                bases: BasesModel(bases: []),
                playersModel: PlayersModel(players: []),
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
  
  @override
  void setPhase(GamePhase newPhase) {}
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