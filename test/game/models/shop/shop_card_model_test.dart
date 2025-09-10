import 'package:flutter_test/flutter_test.dart';
import 'package:card_battler/game_legacy/models/shop/shop_card_model.dart';

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
          expect(card.type, equals('Shop'));
        });
      }

      test('defaults to face up when isFaceUp not specified', () {
        final card = ShopCardModel(name: 'Default Card', cost: 3);
        
        expect(card.isFaceUp, isTrue);
      });

      test('inherits from CardModel with Shop type', () {
        final card = ShopCardModel(name: 'Shop Card', cost: 5);
        
        expect(card.name, equals('Shop Card'));
        expect(card.type, equals('Shop'));
        expect(card.cost, equals(5));
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

      test('type getter returns Shop', () {
        expect(card.type, equals('Shop'));
      });

      test('isFaceUp getter returns correct value', () {
        expect(card.isFaceUp, isTrue);
      });

      test('isFaceUp is mutable', () {
        expect(card.isFaceUp, isTrue);
        
        card.isFaceUp = false;
        expect(card.isFaceUp, isFalse);
        
        card.isFaceUp = true;
        expect(card.isFaceUp, isTrue);
      });
    });

    group('JSON serialization', () {
      test('fromJson creates correct ShopCardModel', () {
        final json = {
          'name': 'JSON Card',
          'cost': 15,
          'faceUp': false,
        };
        
        final card = ShopCardModel.fromJson(json);
        
        expect(card.name, equals('JSON Card'));
        expect(card.cost, equals(15));
        expect(card.isFaceUp, isFalse);
        expect(card.type, equals('Shop'));
      });

      test('fromJson defaults faceUp to true when not specified', () {
        final json = {
          'name': 'Default Face Up',
          'cost': 8,
        };
        
        final card = ShopCardModel.fromJson(json);
        
        expect(card.isFaceUp, isTrue);
      });

      test('toJson creates correct JSON representation', () {
        final card = ShopCardModel(
          name: 'Serializable Card',
          cost: 12,
          isFaceUp: false,
        );
        
        final json = card.toJson();
        
        expect(json['name'], equals('Serializable Card'));
        expect(json['cost'], equals(12));
        expect(json['faceUp'], isFalse);
        expect(json['type'], equals('Shop'));
      });

      test('toJson includes inherited fields from CardModel', () {
        final card = ShopCardModel(
          name: 'Complete Card',
          cost: 20,
          isFaceUp: true,
        );
        
        final json = card.toJson();
        
        expect(json, containsPair('name', 'Complete Card'));
        expect(json, containsPair('type', 'Shop'));
        expect(json, containsPair('faceUp', true));
        expect(json, containsPair('cost', 20));
      });

      test('roundtrip serialization preserves data', () {
        final originalCard = ShopCardModel(
          name: 'Roundtrip Card',
          cost: 25,
          isFaceUp: false,
        );
        
        final json = originalCard.toJson();
        final deserializedCard = ShopCardModel.fromJson(json);
        
        expect(deserializedCard.name, equals(originalCard.name));
        expect(deserializedCard.cost, equals(originalCard.cost));
        expect(deserializedCard.isFaceUp, equals(originalCard.isFaceUp));
        expect(deserializedCard.type, equals(originalCard.type));
      });
    });

    group('edge cases', () {
      test('handles extremely long card names', () {
        final longName = 'A' * 1000;
        final card = ShopCardModel(name: longName, cost: 1);
        
        expect(card.name, equals(longName));
        expect(card.name.length, equals(1000));
      });

      test('handles zero cost', () {
        final card = ShopCardModel(name: 'Free Card', cost: 0);
        
        expect(card.cost, equals(0));
      });

      test('handles very high costs', () {
        final card = ShopCardModel(name: 'Expensive Card', cost: 999999999);
        
        expect(card.cost, equals(999999999));
      });

      test('handles negative costs', () {
        final card = ShopCardModel(name: 'Refund Card', cost: -100);
        
        expect(card.cost, equals(-100));
      });

      test('handles empty card names', () {
        final card = ShopCardModel(name: '', cost: 5);
        
        expect(card.name, equals(''));
        expect(card.cost, equals(5));
      });
    });
  });
}
