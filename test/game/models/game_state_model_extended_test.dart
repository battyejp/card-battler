import 'package:flutter_test/flutter_test.dart';
import 'package:card_battler/game/models/game_state_model.dart';
import 'package:card_battler/game/models/shared/card_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('GameStateModel', () {
    group('constructor and initialization', () {
      test('creates new game with default state', () {
        final gameState = GameStateModel.newGame();
        
        expect(gameState, isNotNull);
        expect(gameState.player, isNotNull);
        expect(gameState.enemies, isNotNull);
        expect(gameState.shop, isNotNull);
        expect(gameState.team, isNotNull);
      });

      test('initializes card lists as empty', () {
        final gameState = GameStateModel.newGame();
        
        expect(gameState.enemyCards, isEmpty);
        expect(gameState.shopCards, isEmpty);
        expect(gameState.heroStartingCards, isEmpty);
      });

      test('card lists are mutable', () {
        final gameState = GameStateModel.newGame();
        final testCard = CardModel(name: 'Test Card', type: 'Test');
        
        gameState.enemyCards.add(testCard);
        expect(gameState.enemyCards.length, equals(1));
        expect(gameState.enemyCards.first.name, equals('Test Card'));
      });
    });

    group('card list management', () {
      late GameStateModel gameState;
      
      setUp(() {
        gameState = GameStateModel.newGame();
      });

      test('enemyCards list can be populated', () {
        final enemyCards = [
          CardModel(name: 'Goblin', type: 'Enemy'),
          CardModel(name: 'Orc', type: 'Enemy'),
          CardModel(name: 'Dragon', type: 'Enemy'),
        ];
        
        gameState.enemyCards.addAll(enemyCards);
        
        expect(gameState.enemyCards.length, equals(3));
        expect(gameState.enemyCards[0].name, equals('Goblin'));
        expect(gameState.enemyCards[1].name, equals('Orc'));
        expect(gameState.enemyCards[2].name, equals('Dragon'));
      });

      test('shopCards list can be populated', () {
        final shopCards = [
          CardModel(name: 'Health Potion', type: 'Shop'),
          CardModel(name: 'Mana Potion', type: 'Shop'),
          CardModel(name: 'Sword', type: 'Shop'),
        ];
        
        gameState.shopCards.addAll(shopCards);
        
        expect(gameState.shopCards.length, equals(3));
        expect(gameState.shopCards[0].name, equals('Health Potion'));
        expect(gameState.shopCards[1].name, equals('Mana Potion'));
        expect(gameState.shopCards[2].name, equals('Sword'));
      });

      test('heroStartingCards list can be populated', () {
        final heroCards = [
          CardModel(name: 'Strike', type: 'Hero'),
          CardModel(name: 'Defend', type: 'Hero'),
          CardModel(name: 'Block', type: 'Hero'),
        ];
        
        gameState.heroStartingCards.addAll(heroCards);
        
        expect(gameState.heroStartingCards.length, equals(3));
        expect(gameState.heroStartingCards[0].name, equals('Strike'));
        expect(gameState.heroStartingCards[1].name, equals('Defend'));
        expect(gameState.heroStartingCards[2].name, equals('Block'));
      });

      test('different card lists are independent', () {
        gameState.enemyCards.add(CardModel(name: 'Enemy', type: 'Enemy'));
        gameState.shopCards.add(CardModel(name: 'Shop Item', type: 'Shop'));
        gameState.heroStartingCards.add(CardModel(name: 'Hero Skill', type: 'Hero'));
        
        expect(gameState.enemyCards.length, equals(1));
        expect(gameState.shopCards.length, equals(1));
        expect(gameState.heroStartingCards.length, equals(1));
        
        expect(gameState.enemyCards.first.name, equals('Enemy'));
        expect(gameState.shopCards.first.name, equals('Shop Item'));
        expect(gameState.heroStartingCards.first.name, equals('Hero Skill'));
      });

      test('card lists can be cleared', () {
        gameState.enemyCards.addAll([
          CardModel(name: 'Enemy 1', type: 'Enemy'),
          CardModel(name: 'Enemy 2', type: 'Enemy'),
        ]);
        gameState.shopCards.addAll([
          CardModel(name: 'Item 1', type: 'Shop'),
          CardModel(name: 'Item 2', type: 'Shop'),
        ]);
        gameState.heroStartingCards.addAll([
          CardModel(name: 'Skill 1', type: 'Hero'),
          CardModel(name: 'Skill 2', type: 'Hero'),
        ]);
        
        expect(gameState.enemyCards.length, equals(2));
        expect(gameState.shopCards.length, equals(2));
        expect(gameState.heroStartingCards.length, equals(2));
        
        gameState.enemyCards.clear();
        gameState.shopCards.clear();
        gameState.heroStartingCards.clear();
        
        expect(gameState.enemyCards, isEmpty);
        expect(gameState.shopCards, isEmpty);
        expect(gameState.heroStartingCards, isEmpty);
      });
    });

    group('loadCards functionality', () {
      late GameStateModel gameState;
      
      setUp(() {
        gameState = GameStateModel.newGame();
      });

      test('loadCards function exists and is callable', () {
        expect(gameState.loadCards, isNotNull);
        expect(gameState.loadCards, isA<Function>());
      });

      // Note: Actual testing of loadCards() would require mocking Flutter's
      // rootBundle.loadString method to provide test JSON data.
      // The following tests show the expected behavior:

      test('loadCards method signature returns Future<void>', () {
        final future = gameState.loadCards();
        expect(future, isA<Future<void>>());
      });

      // In a real test environment with proper mocking, you would test:
      // - Successful loading of enemy cards from JSON
      // - Successful loading of shop cards from JSON  
      // - Successful loading of hero starting cards from JSON
      // - Error handling for missing files
      // - Error handling for malformed JSON
      // - Verification that cards are properly parsed and added to lists
      
      test('card lists structure supports expected card types', () {
        // Test that the lists can hold the expected card types based on JSON structure
        final enemyCard = CardModel(name: 'Goblin', type: 'Enemy');
        final shopCard = CardModel(name: 'Health Potion', type: 'Shop');
        final heroCard = CardModel(name: 'Strike', type: 'Hero');
        
        gameState.enemyCards.add(enemyCard);
        gameState.shopCards.add(shopCard);
        gameState.heroStartingCards.add(heroCard);
        
        expect(gameState.enemyCards.first.type, equals('Enemy'));
        expect(gameState.shopCards.first.type, equals('Shop'));
        expect(gameState.heroStartingCards.first.type, equals('Hero'));
      });
    });

    group('integration with other components', () {
      test('GameStateModel contains all required components', () {
        final gameState = GameStateModel.newGame();
        
        expect(gameState.player, isNotNull);
        expect(gameState.enemies, isNotNull);
        expect(gameState.shop, isNotNull);
        expect(gameState.team, isNotNull);
        
        // Card lists should be available for use by components
        expect(gameState.enemyCards, isNotNull);
        expect(gameState.shopCards, isNotNull);
        expect(gameState.heroStartingCards, isNotNull);
      });

      test('card lists can be accessed by component models', () {
        final gameState = GameStateModel.newGame();
        
        // These lists should be accessible for populating component models
        expect(gameState.enemyCards, isA<List<CardModel>>());
        expect(gameState.shopCards, isA<List<CardModel>>());
        expect(gameState.heroStartingCards, isA<List<CardModel>>());
      });
    });

    group('game state consistency', () {
      test('new game state is in consistent initial state', () {
        final gameState = GameStateModel.newGame();
        
        // All card lists should be empty initially
        expect(gameState.enemyCards, isEmpty);
        expect(gameState.shopCards, isEmpty);
        expect(gameState.heroStartingCards, isEmpty);
        
        // All component models should be initialized
        expect(gameState.player, isNotNull);
        expect(gameState.enemies, isNotNull);
        expect(gameState.shop, isNotNull);
        expect(gameState.team, isNotNull);
      });

      test('card data types are consistent with expected JSON structure', () {
        final gameState = GameStateModel.newGame();
        
        // Based on the JSON files, we expect these card types:
        final enemyTypes = ['Enemy'];
        final shopTypes = ['Shop'];
        final heroTypes = ['Hero'];
        
        // Add sample cards that match expected JSON structure
        gameState.enemyCards.add(CardModel(name: 'Goblin', type: 'Enemy'));
        gameState.shopCards.add(CardModel(name: 'Health Potion', type: 'Shop'));
        gameState.heroStartingCards.add(CardModel(name: 'Strike', type: 'Hero'));
        
        expect(enemyTypes.contains(gameState.enemyCards.first.type), isTrue);
        expect(shopTypes.contains(gameState.shopCards.first.type), isTrue);
        expect(heroTypes.contains(gameState.heroStartingCards.first.type), isTrue);
      });
    });
  });
}
