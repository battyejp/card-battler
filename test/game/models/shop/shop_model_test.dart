import 'package:flutter_test/flutter_test.dart';
import 'package:card_battler/game/models/shop/shop_model.dart';
import 'package:card_battler/game/models/shop/shop_card_model.dart';
import 'package:card_battler/game/models/shared/reactive_model.dart';
import 'package:card_battler/game/models/shared/card_model.dart';

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
        
        expect(shop.selectableCards, isNotEmpty);
        expect(shop.selectableCards.length, equals(6));
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

      test('selectableCards getter returns correct list', () {
        final selectableCards = shop.selectableCards;
        
        expect(selectableCards, isA<List<ShopCardModel>>());
        expect(selectableCards.length, equals(6));
      });
    });

    group('card generation behavior', () {
      test('generated cards have expected properties', () {
        final testCards = List.generate(
          10,
          (index) => ShopCardModel(name: 'Card ${index + 1}', cost: 1),
        );
        final shop = ShopModel(numberOfRows: 2, numberOfColumns: 3, cards: testCards);
        final allGeneratedCards = [...shop.selectableCards];
        
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
           
        final expectedSelectableNames = {'Card 1', 'Card 2', 'Card 3', 'Card 4', 'Card 5', 'Card 6'};  
        expect(selectableCardNames, equals(expectedSelectableNames));
      });
    });

    group('ReactiveModel integration', () {
      test('implements ReactiveModel mixin', () {
        final testCards = List.generate(10, (index) => ShopCardModel(name: 'Card ${index + 1}', cost: 1));
        final shop = ShopModel(numberOfRows: 2, numberOfColumns: 3, cards: testCards);
        expect(shop, isA<ReactiveModel<ShopModel>>());
      });

      test('has changes stream available', () {
        final testCards = List.generate(10, (index) => ShopCardModel(name: 'Card ${index + 1}', cost: 1));
        final shop = ShopModel(numberOfRows: 2, numberOfColumns: 3, cards: testCards);
        expect(shop.changes, isA<Stream<ShopModel>>());
      });
    });

    group('card removal functionality', () {
      test('removeSelectableCardFromShop removes card and notifies change', () {
        final testCards = List.generate(10, (index) => ShopCardModel(name: 'Card ${index + 1}', cost: 1));
        final shop = ShopModel(numberOfRows: 2, numberOfColumns: 3, cards: testCards);
        
        final cardToRemove = shop.selectableCards.first;
        final initialCount = shop.selectableCards.length;

        shop.removeSelectableCardFromShop(cardToRemove);

        expect(shop.selectableCards.length, equals(initialCount - 1));
        expect(shop.selectableCards.contains(cardToRemove), isFalse);
      });

      test('removeSelectableCardFromShop emits change notification', () async {
        final testCards = List.generate(10, (index) => ShopCardModel(name: 'Card ${index + 1}', cost: 1));
        final shop = ShopModel(numberOfRows: 2, numberOfColumns: 3, cards: testCards);
        
        final changes = <ShopModel>[];
        final subscription = shop.changes.listen(changes.add);
        
        final cardToRemove = shop.selectableCards.first;
        shop.removeSelectableCardFromShop(cardToRemove);
        
        await Future.delayed(Duration.zero);
        
        expect(changes.length, equals(1));
        expect(changes.first, equals(shop));
        
        await subscription.cancel();
        shop.dispose();
      });

      test('removing non-existent card does not affect shop', () {
        final testCards = List.generate(10, (index) => ShopCardModel(name: 'Card ${index + 1}', cost: 1));
        final shop = ShopModel(numberOfRows: 2, numberOfColumns: 3, cards: testCards);
        
        final nonExistentCard = ShopCardModel(name: 'Non-existent', cost: 999);
        final initialCount = shop.selectableCards.length;

        shop.removeSelectableCardFromShop(nonExistentCard);

        expect(shop.selectableCards.length, equals(initialCount));
      });
    });

    group('card played callback functionality', () {
      test('sets up onCardPlayed callback on selectable cards during initialization', () {
        final testCards = List.generate(10, (index) => ShopCardModel(name: 'Card ${index + 1}', cost: 1));
        final shop = ShopModel(numberOfRows: 2, numberOfColumns: 3, cards: testCards);
        
        for (final card in shop.selectableCards) {
          expect(card.onCardPlayed, isNotNull);
        }
      });

      test('cardPlayed callback is called when shop card is played', () {
        final testCards = List.generate(10, (index) => ShopCardModel(name: 'Card ${index + 1}', cost: 1));
        final shop = ShopModel(numberOfRows: 2, numberOfColumns: 3, cards: testCards);
        
        CardModel? playedCard;
        shop.cardPlayed = (card) => playedCard = card;
        
        final cardToPlay = shop.selectableCards.first;
        cardToPlay.onCardPlayed?.call();
        
        expect(playedCard, equals(cardToPlay));
      });

      test('onCardPlayed callback is cleared after card is played', () {
        final testCards = List.generate(10, (index) => ShopCardModel(name: 'Card ${index + 1}', cost: 1));
        final shop = ShopModel(numberOfRows: 2, numberOfColumns: 3, cards: testCards);
        
        final cardToPlay = shop.selectableCards.first;
        expect(cardToPlay.onCardPlayed, isNotNull);
        
        shop.cardPlayed = (card) {};
        cardToPlay.onCardPlayed?.call();
        
        expect(cardToPlay.onCardPlayed, isNull);
      });

      test('multiple cards can be played through their callbacks', () {
        final testCards = List.generate(10, (index) => ShopCardModel(name: 'Card ${index + 1}', cost: 1));
        final shop = ShopModel(numberOfRows: 2, numberOfColumns: 3, cards: testCards);
        
        final playedCards = <CardModel>[];
        shop.cardPlayed = (card) => playedCards.add(card);
        
        final firstCard = shop.selectableCards[0];
        final secondCard = shop.selectableCards[1];
        
        firstCard.onCardPlayed?.call();
        secondCard.onCardPlayed?.call();
        
        expect(playedCards.length, equals(2));
        expect(playedCards, containsAll([firstCard, secondCard]));
      });
    });
  });
}