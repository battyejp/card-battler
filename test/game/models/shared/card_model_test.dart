import 'package:flutter_test/flutter_test.dart';
import 'package:card_battler/game/models/shop/shop_card_model.dart';

void main() {
  group('ShopCardModel', () {
    group('constructor and initialization', () {
      final testCases = [
        {'name': 'Test Card', 'cost': 5, 'isFaceUp': true},
        {'name': 'Another Card', 'cost': 10, 'isFaceUp': false},
        {'name': 'Free Card', 'cost': 0, 'isFaceUp': true},
        {'name': '', 'cost': 3, 'isFaceUp': false},
        {'name': 'Negative Cost Card', 'cost': -5, 'isFaceUp': true},
        {'name': 'Expensive Card', 'cost': 999999, 'isFaceUp': false},
      ];

      for (final testCase in testCases) {
        test('creates with name "${testCase['name']}", cost ${testCase['cost']}, and isFaceUp ${testCase['isFaceUp']}', () {
          final card = ShopCardModel(
            name: testCase['name'] as String,
            cost: testCase['cost'] as int,
            isFaceUp: testCase['isFaceUp'] as bool,
          );
          
          expect(card.name, equals(testCase['name']));
          expect(card.cost, equals(testCase['cost']));
          expect(card.isFaceUp, equals(testCase['isFaceUp']));
        });
      }

      test('defaults to face up when isFaceUp not specified', () {
        final card = ShopCardModel(name: 'Default Card', cost: 3);
        
        expect(card.isFaceUp, isTrue);
      });
    });

    group('property access', () {
      late ShopCardModel card;
      
      setUp(() {
        card = ShopCardModel(
          name: 'Sample Card',
          cost: 7,
        );
      });

      test('name getter returns correct value', () {
        expect(card.name, equals('Sample Card'));
      });

      test('cost getter returns correct value', () {
        expect(card.cost, equals(7));
      });

      test('isFaceUp getter returns correct value', () {
        expect(card.isFaceUp, isTrue);
      });
    });
  });
}
