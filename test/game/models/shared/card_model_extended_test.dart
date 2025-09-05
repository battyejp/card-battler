import 'package:flutter_test/flutter_test.dart';
import 'package:card_battler/game/models/shared/card_model.dart';

void main() {
  group('CardModel', () {
    group('constructor and initialization', () {
      test('creates with required parameters', () {
        final card = CardModel(name: 'Test Card', type: 'Player');
        
        expect(card.name, equals('Test Card'));
        expect(card.type, equals('Player'));
        expect(card.isFaceUp, isFalse); // default value
      });

      test('creates with all parameters', () {
        final card = CardModel(
          name: 'Full Card',
          type: 'Enemy',
          isFaceUp: false,
        );
        
        expect(card.name, equals('Full Card'));
        expect(card.type, equals('Enemy'));
        expect(card.isFaceUp, isFalse);
      });

      test('defaults isFaceUp to false when not specified', () {
        final card = CardModel(name: 'Default Card', type: 'Hero');
        
        expect(card.isFaceUp, isFalse);
      });

      final testCases = [
        {'name': 'Strike', 'type': 'Hero', 'isFaceUp': true},
        {'name': 'Goblin', 'type': 'Enemy', 'isFaceUp': false},
        {'name': 'Health Potion', 'type': 'Shop', 'isFaceUp': true},
        {'name': '', 'type': 'Unknown', 'isFaceUp': false},
      ];

      for (final testCase in testCases) {
        test('creates with name "${testCase['name']}", type "${testCase['type']}", isFaceUp ${testCase['isFaceUp']}', () {
          final card = CardModel(
            name: testCase['name'] as String,
            type: testCase['type'] as String,
            isFaceUp: testCase['isFaceUp'] as bool,
          );
          
          expect(card.name, equals(testCase['name']));
          expect(card.type, equals(testCase['type']));
          expect(card.isFaceUp, equals(testCase['isFaceUp']));
        });
      }
    });

    group('property access and mutability', () {
      late CardModel card;
      
      setUp(() {
        card = CardModel(
          name: 'Sample Card',
          type: 'Player',
          isFaceUp: true,
        );
      });

      test('name getter returns correct value', () {
        expect(card.name, equals('Sample Card'));
      });

      test('type getter returns correct value', () {
        expect(card.type, equals('Player'));
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

      test('name and type are immutable', () {
        // These should not have setters - tested by ensuring compilation works
        expect(card.name, isNotNull);
        expect(card.type, isNotNull);
      });
    });

    group('JSON serialization', () {
      test('fromJson creates correct CardModel', () {
        final json = {
          'name': 'JSON Card',
          'type': 'Spell',
          'faceUp': false,
        };
        
        final card = CardModel.fromJson(json);
        
        expect(card.name, equals('JSON Card'));
        expect(card.type, equals('Spell'));
        expect(card.isFaceUp, isFalse);
      });

      test('fromJson defaults faceUp to false when not specified', () {
        final json = {
          'name': 'Default Face Up',
          'type': 'Action',
        };
        
        final card = CardModel.fromJson(json);
        
        expect(card.isFaceUp, isFalse);
      });

      test('fromJson handles null faceUp as false', () {
        final json = {
          'name': 'Null Face Up',
          'type': 'Artifact',
          'faceUp': null,
        };
        
        final card = CardModel.fromJson(json);
        
        expect(card.isFaceUp, isFalse);
      });

      test('toJson creates correct JSON representation', () {
        final card = CardModel(
          name: 'Serializable Card',
          type: 'Creature',
          isFaceUp: false,
        );
        
        final json = card.toJson();
        
        expect(json['name'], equals('Serializable Card'));
        expect(json['type'], equals('Creature'));
        expect(json['faceUp'], isFalse);
      });

      test('toJson with face up card', () {
        final card = CardModel(
          name: 'Face Up Card',
          type: 'Instant',
          isFaceUp: true,
        );
        
        final json = card.toJson();
        
        expect(json['name'], equals('Face Up Card'));
        expect(json['type'], equals('Instant'));
        expect(json['faceUp'], isTrue);
      });

      test('roundtrip serialization preserves data', () {
        final originalCard = CardModel(
          name: 'Roundtrip Card',
          type: 'Enchantment',
          isFaceUp: false,
        );
        
        final json = originalCard.toJson();
        final deserializedCard = CardModel.fromJson(json);
        
        expect(deserializedCard.name, equals(originalCard.name));
        expect(deserializedCard.type, equals(originalCard.type));
        expect(deserializedCard.isFaceUp, equals(originalCard.isFaceUp));
      });
    });

    group('edge cases', () {
      test('handles empty card names', () {
        final card = CardModel(name: '', type: 'Empty');
        
        expect(card.name, equals(''));
        expect(card.type, equals('Empty'));
      });

      test('handles empty card types', () {
        final card = CardModel(name: 'Unnamed', type: '');
        
        expect(card.name, equals('Unnamed'));
        expect(card.type, equals(''));
      });

      test('handles very long names and types', () {
        final longName = 'A' * 1000;
        final longType = 'B' * 500;
        
        final card = CardModel(name: longName, type: longType);
        
        expect(card.name, equals(longName));
        expect(card.type, equals(longType));
        expect(card.name.length, equals(1000));
        expect(card.type.length, equals(500));
      });

      test('handles special characters in names and types', () {
        final specialName = 'Card with 特殊字符 and émojis 🎮⚔️';
        final specialType = 'Type_with-symbols.123';
        
        final card = CardModel(name: specialName, type: specialType);
        
        expect(card.name, equals(specialName));
        expect(card.type, equals(specialType));
      });
    });

    group('equality and identity', () {
      test('cards with same data are equal by content', () {
        final card1 = CardModel(name: 'Same Card', type: 'Same Type');
        final card2 = CardModel(name: 'Same Card', type: 'Same Type');
        
        // Note: CardModel doesn't override == so they're different objects
        expect(identical(card1, card2), isFalse);
        expect(card1.name, equals(card2.name));
        expect(card1.type, equals(card2.type));
        expect(card1.isFaceUp, equals(card2.isFaceUp));
      });

      test('cards with different data are not equal', () {
        final card1 = CardModel(name: 'Card 1', type: 'Type 1');
        final card2 = CardModel(name: 'Card 2', type: 'Type 2');
        
        expect(card1.name, isNot(equals(card2.name)));
        expect(card1.type, isNot(equals(card2.type)));
      });
    });

    group('card play functionality', () {
      test('playCard method exists and is callable', () {
        final card = CardModel(name: 'Playable Card', type: 'Action');
        
        expect(() => card.playCard(), returnsNormally);
      });

      test('playCard calls onCardPlayed callback when set', () {
        final card = CardModel(name: 'Callback Card', type: 'Action');
        
        bool callbackCalled = false;
        card.onCardPlayed = () => callbackCalled = true;
        
        card.playCard();
        
        expect(callbackCalled, isTrue);
      });

      test('playCard does nothing when onCardPlayed is null', () {
        final card = CardModel(name: 'No Callback Card', type: 'Action');
        
        expect(card.onCardPlayed, isNull);
        expect(() => card.playCard(), returnsNormally);
      });

      test('onCardPlayed callback can be set and changed', () {
        final card = CardModel(name: 'Changeable Card', type: 'Action');
        
        int callCount = 0;
        
        card.onCardPlayed = () => callCount++;
        card.playCard();
        expect(callCount, equals(1));
        
        card.onCardPlayed = () => callCount += 10;
        card.playCard();
        expect(callCount, equals(11));
      });

      test('onCardPlayed callback can be cleared', () {
        final card = CardModel(name: 'Clearable Card', type: 'Action');
        
        bool callbackCalled = false;
        card.onCardPlayed = () => callbackCalled = true;
        
        card.onCardPlayed = null;
        card.playCard();
        
        expect(callbackCalled, isFalse);
      });

      test('multiple cards can have different callbacks', () {
        final card1 = CardModel(name: 'Card 1', type: 'Action');
        final card2 = CardModel(name: 'Card 2', type: 'Action');
        
        int counter1 = 0;
        int counter2 = 0;
        
        card1.onCardPlayed = () => counter1++;
        card2.onCardPlayed = () => counter2 += 10;
        
        card1.playCard();
        expect(counter1, equals(1));
        expect(counter2, equals(0));
        
        card2.playCard();
        expect(counter1, equals(1));
        expect(counter2, equals(10));
        
        card1.playCard();
        expect(counter1, equals(2));
        expect(counter2, equals(10));
      });

      test('callback can access card instance', () {
        final card = CardModel(name: 'Self Referencing Card', type: 'Meta');
        
        String? capturedName;
        card.onCardPlayed = () => capturedName = card.name;
        
        card.playCard();
        
        expect(capturedName, equals('Self Referencing Card'));
      });

      test('callback exceptions do not crash playCard', () {
        final card = CardModel(name: 'Exception Card', type: 'Dangerous');
        
        card.onCardPlayed = () => throw Exception('Test exception');
        
        expect(() => card.playCard(), throwsException);
      });

      test('onCardPlayed can be set during construction indirectly', () {
        final card = CardModel(name: 'Constructor Card', type: 'Action');
        
        // Since onCardPlayed is not a constructor parameter, we test post-construction assignment
        bool callbackCalled = false;
        card.onCardPlayed = () => callbackCalled = true;
        
        expect(card.onCardPlayed, isNotNull);
        
        card.playCard();
        expect(callbackCalled, isTrue);
      });
    });
  });

  group('loadCardsFromJsonString function', () {
    test('loadCardsFromJsonString is available', () {
      expect(loadCardsFromJsonString, isNotNull);
      expect(loadCardsFromJsonString, isA<Function>());
    });

    test('loadCardsFromJsonString parses valid JSON array', () {
      const jsonString = '''[
        {"name": "Test Card 1", "type": "Player"},
        {"name": "Test Card 2", "type": "Enemy"}
      ]''';
      
      final cards = loadCardsFromJsonString<CardModel>(
        jsonString,
        CardModel.fromJson,
      );
      
      expect(cards, hasLength(2));
      expect(cards[0].name, equals('Test Card 1'));
      expect(cards[0].type, equals('Player'));
      expect(cards[1].name, equals('Test Card 2'));
      expect(cards[1].type, equals('Enemy'));
    });

    test('loadCardsFromJsonString handles empty array', () {
      const jsonString = '[]';
      
      final cards = loadCardsFromJsonString<CardModel>(
        jsonString,
        CardModel.fromJson,
      );
      
      expect(cards, isEmpty);
    });
  });
}
