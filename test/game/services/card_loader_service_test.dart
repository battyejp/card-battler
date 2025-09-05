import 'package:flutter_test/flutter_test.dart';
import 'package:card_battler/game/models/shop/shop_card_model.dart';

void main() {
  group('CardLoaderService', () {
    group('JSON parsing', () {
      test('creates ShopCardModel from JSON', () {
        final json = {
          'name': 'Test Card',
          'type': 'Action',
          'cost': 10
        };

        final card = ShopCardModel.fromJson(json);

        expect(card.name, equals('Test Card'));
        expect(card.type, equals('Shop'));  // ShopCardModel always has type 'Shop'
        expect(card.cost, equals(10));
      });

      test('creates multiple ShopCardModels from JSON list', () {
        final jsonList = [
          {'name': 'Card 1', 'type': 'Action', 'cost': 5},
          {'name': 'Card 2', 'type': 'Spell', 'cost': 8}
        ];

        final cards = jsonList.map((json) => ShopCardModel.fromJson(json)).toList();

        expect(cards, hasLength(2));
        expect(cards[0].name, equals('Card 1'));
        expect(cards[0].type, equals('Shop'));  // ShopCardModel always has type 'Shop'
        expect(cards[0].cost, equals(5));
        expect(cards[1].name, equals('Card 2'));
        expect(cards[1].type, equals('Shop'));  // ShopCardModel always has type 'Shop'
        expect(cards[1].cost, equals(8));
      });
    });
  });
}