import 'package:flutter_test/flutter_test.dart';
import 'package:card_battler/game/models/shop/shop_model.dart';
import 'package:card_battler/game/models/shop/shop_card_model.dart';

void main() {
  group('ShopModel', () {
    group('constructor and initialization', () {
      test('creates and initializes shop with generated items', () {
        // Create test cards
        final testCards = List.generate(
          10,
          (index) => ShopCardModel(name: 'Card ${index + 1}', cost: 1),
        );
        
        final shop = ShopModel(
          numberOfRows: 2, 
          numberOfColumns: 3,
          cards: testCards
        );
        
        expect(shop.allCards, isNotEmpty);
        expect(shop.selectableCards, isNotEmpty);
        expect(shop.allCards.length, equals(4));
        expect(shop.selectableCards.length, equals(6));
      });

      test('generates correct total number of cards', () {
        final testCards = List.generate(
          10,
          (index) => ShopCardModel(name: 'Card ${index + 1}', cost: 1),
        );
        final shop = ShopModel(numberOfRows: 2, numberOfColumns: 3, cards: testCards);
        final totalCards = shop.allCards.length + shop.selectableCards.length;
        
        expect(totalCards, equals(10));
      });

      test('selectable cards are first 6 cards from generated set', () {
        final testCards = List.generate(
          10,
          (index) => ShopCardModel(name: 'Card ${index + 1}', cost: 1),
        );
        final shop = ShopModel(numberOfRows: 2, numberOfColumns: 3, cards: testCards);
        
        for (int i = 0; i < shop.selectableCards.length; i++) {
          expect(shop.selectableCards[i].name, equals('Card ${i + 1}'));
          expect(shop.selectableCards[i].cost, equals(1));
          expect(shop.selectableCards[i].isFaceUp, isTrue);
        }
      });

      test('remaining cards are last 4 cards from generated set', () {
        final testCards = List.generate(
          10,
          (index) => ShopCardModel(name: 'Card ${index + 1}', cost: 1),
        );
        final shop = ShopModel(numberOfRows: 2, numberOfColumns: 3, cards: testCards);
        
        for (int i = 0; i < shop.allCards.length; i++) {
          final expectedCardNumber = i + 7;
          expect(shop.allCards[i].name, equals('Card $expectedCardNumber'));
          expect(shop.allCards[i].cost, equals(1));
          expect(shop.allCards[i].isFaceUp, isTrue);
        }
      });
    });

    group('property access', () {
      late ShopModel shop;
      
      setUp(() {
        final testCards = List.generate(
          10,
          (index) => ShopCardModel(name: 'Card ${index + 1}', cost: 1),
        );
        shop = ShopModel(numberOfRows: 2, numberOfColumns: 3, cards: testCards);
      });

      test('allCards getter returns correct list', () {
        final allCards = shop.allCards;
        
        expect(allCards, isA<List<ShopCardModel>>());
        expect(allCards.length, equals(4));
      });

      test('selectableCards getter returns correct list', () {
        final selectableCards = shop.selectableCards;
        
        expect(selectableCards, isA<List<ShopCardModel>>());
        expect(selectableCards.length, equals(6));
      });

      test('getters return same list instances', () {
        final allCards1 = shop.allCards;
        final allCards2 = shop.allCards;
        final selectableCards1 = shop.selectableCards;
        final selectableCards2 = shop.selectableCards;
        
        expect(identical(allCards1, allCards2), isTrue);
        expect(identical(selectableCards1, selectableCards2), isTrue);
      });
    });

    group('card generation behavior', () {
      test('generated cards have expected properties', () {
        final testCards = List.generate(
          10,
          (index) => ShopCardModel(name: 'Card ${index + 1}', cost: 1),
        );
        final shop = ShopModel(numberOfRows: 2, numberOfColumns: 3, cards: testCards);
        final allGeneratedCards = [...shop.selectableCards, ...shop.allCards];
        
        for (int i = 0; i < allGeneratedCards.length; i++) {
          final card = allGeneratedCards[i];
          expect(card.name, equals('Card ${i + 1}'));
          expect(card.cost, equals(1));
          expect(card.isFaceUp, isTrue);
        }
      });

      test('cards are properly partitioned between lists', () {
        final testCards = List.generate(
          10,
          (index) => ShopCardModel(name: 'Card ${index + 1}', cost: 1),
        );
        final shop = ShopModel(numberOfRows: 2, numberOfColumns: 3, cards: testCards);
        final selectableCardNames = shop.selectableCards.map((c) => c.name).toSet();
        final allCardNames = shop.allCards.map((c) => c.name).toSet();
        
        expect(selectableCardNames.intersection(allCardNames).isEmpty, isTrue);
        
        final expectedSelectableNames = {'Card 1', 'Card 2', 'Card 3', 'Card 4', 'Card 5', 'Card 6'};
        final expectedAllCardNames = {'Card 7', 'Card 8', 'Card 9', 'Card 10'};
        
        expect(selectableCardNames, equals(expectedSelectableNames));
        expect(allCardNames, equals(expectedAllCardNames));
      });
    });
  });
}