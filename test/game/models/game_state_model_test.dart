import 'package:flutter_test/flutter_test.dart';
import 'package:card_battler/game/models/game_state_model.dart';
import 'package:card_battler/game/models/shop/shop_card_model.dart';
import 'package:card_battler/game/models/shared/card_model.dart';

List<CardModel> _generatePlayerDeckCards() {
  return List.generate(20, (index) => CardModel(
    name: 'Player Card ${index + 1}',
    type: 'Player',
    isFaceUp: false,
  ));
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('GameStateModel', () {
    group('constructor and initialization', () {
      test('creates new game with default state', () {
        // Create empty shop cards list for new game
        final shopCards = <ShopCardModel>[];
        final playerDeckCards = _generatePlayerDeckCards();
        final gameState = GameStateModel.newGame(shopCards, playerDeckCards);
        
        expect(gameState, isNotNull);
        expect(gameState.player, isNotNull);
        expect(gameState.enemies, isNotNull);
        expect(gameState.shop, isNotNull);
        expect(gameState.team, isNotNull);
      });
    });

    group('integration with other components', () {
      test('GameStateModel contains all required components', () {
        // Create empty shop cards list for new game
        final shopCards = <ShopCardModel>[];
        final playerDeckCards = _generatePlayerDeckCards();
        final gameState = GameStateModel.newGame(shopCards, playerDeckCards);
        
        expect(gameState.player, isNotNull);
        expect(gameState.enemies, isNotNull);
        expect(gameState.shop, isNotNull);
        expect(gameState.team, isNotNull);
      });
    });

    group('game state consistency', () {
      test('new game state is in consistent initial state', () {
        // Create empty shop cards list for new game
        final shopCards = <ShopCardModel>[];
        final playerDeckCards = _generatePlayerDeckCards();
        final gameState = GameStateModel.newGame(shopCards, playerDeckCards);
        
        // All component models should be initialized
        expect(gameState.player, isNotNull);
        expect(gameState.enemies, isNotNull);
        expect(gameState.shop, isNotNull);
        expect(gameState.team, isNotNull);
      });
    });
  });
}
