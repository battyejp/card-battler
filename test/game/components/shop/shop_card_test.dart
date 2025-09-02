import 'package:flutter_test/flutter_test.dart';
import 'package:card_battler/game/components/shop/shop_card.dart';
import 'package:card_battler/game/models/shop/shop_card_model.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flame/components.dart';

void main() {
  group('ShopCard', () {
    // Basic tests from shop_card_test.dart
    group('constructor and initialization', () {
      testWithFlameGame('creates with ShopCardModel parameter', (game) async {
        final cardModel = ShopCardModel(name: 'Test Card', cost: 5);
        final card = ShopCard(cardModel);

        expect(card.cardModel, equals(cardModel));
        expect(card.shopCardModel, equals(cardModel));
        expect(card.cardModel.name, equals('Test Card'));
        expect(card.shopCardModel.cost, equals(5));
      });
    });

    group('onLoad functionality', () {
      testWithFlameGame('creates text components on load when face up', (game) async {
        final cardModel = ShopCardModel(name: 'Magic Missile', cost: 2);
        final card = ShopCard(cardModel)..size = Vector2(100, 150);

        await game.ensureAdd(card);

        expect(card.children.length, equals(3)); // 2 text components + 1 button
        expect(card.children.whereType<TextComponent>().length, equals(2));
        
        final textComponents = card.children.whereType<TextComponent>().toList();
        final nameComponent = textComponents.firstWhere((c) => c.text == 'Magic Missile');
        final costComponent = textComponents.firstWhere((c) => c.text == 'Cost: 2');
        
        expect(nameComponent.text, equals('Magic Missile'));
        expect(costComponent.text, equals('Cost: 2'));
        expect(nameComponent.anchor, equals(Anchor.center));
        expect(costComponent.anchor, equals(Anchor.center));
      });

      testWithFlameGame('text components update with different card data', (game) async {
        final cardModel = ShopCardModel(name: 'Heal', cost: 1);
        final card = ShopCard(cardModel)..size = Vector2(80, 120);

        await game.ensureAdd(card);

        final textComponents = card.children.whereType<TextComponent>().toList();
        final nameComponent = textComponents.firstWhere((c) => c.text == 'Heal');
        final costComponent = textComponents.firstWhere((c) => c.text == 'Cost: 1');
        
        expect(nameComponent.text, equals('Heal'));
        expect(costComponent.text, equals('Cost: 1'));
      });

      testWithFlameGame('handles empty card name', (game) async {
        final cardModel = ShopCardModel(name: '', cost: 0);
        final card = ShopCard(cardModel)..size = Vector2(50, 75);

        await game.ensureAdd(card);

        final textComponents = card.children.whereType<TextComponent>().toList();
        final nameComponent = textComponents.firstWhere((c) => c.text == '');
        final costComponent = textComponents.firstWhere((c) => c.text == 'Cost: 0');
        
        expect(nameComponent.text, equals(''));
        expect(costComponent.text, equals('Cost: 0'));
      });
    });

    group('face up/down functionality', () {
      testWithFlameGame('shop card is face up by default', (game) async {
        final cardModel = ShopCardModel(name: 'Test Card', cost: 3);
        final card = ShopCard(cardModel)..size = Vector2(100, 150);

        await game.ensureAdd(card);

        expect(card.children.length, equals(3)); // name and cost components + button
        expect(card.cardModel.isFaceUp, equals(true));
      });

      testWithFlameGame('shop card shows card details when face up', (game) async {
        final cardModel = ShopCardModel(name: 'Fire Ball', cost: 5, isFaceUp: true);
        final card = ShopCard(cardModel)..size = Vector2(100, 150);

        await game.ensureAdd(card);

        expect(card.children.length, equals(3)); // name and cost components + button
        
        final textComponents = card.children.whereType<TextComponent>().toList();
        final nameComponent = textComponents.firstWhere((c) => c.text == 'Fire Ball');
        final costComponent = textComponents.firstWhere((c) => c.text == 'Cost: 5');
        
        expect(nameComponent.text, equals('Fire Ball'));
        expect(costComponent.text, equals('Cost: 5'));
      });

      testWithFlameGame('shop card shows back when face down', (game) async {
        final cardModel = ShopCardModel(name: 'Secret Card', cost: 7, isFaceUp: false);
        final card = ShopCard(cardModel)..size = Vector2(100, 150);

        await game.ensureAdd(card);

        expect(card.children.length, equals(2)); // back text + button
        
        final textComponents = card.children.whereType<TextComponent>().toList();
        expect(textComponents.first.text, equals('Back'));
      });
    });

    // Extended tests from shop_card_extended_test.dart
    group('constructor and inheritance (extended)', () {
      testWithFlameGame('creates ShopCard with ShopCardModel', (game) async {
        final shopCardModel = ShopCardModel(name: 'Shop Item', cost: 10);
        final shopCard = ShopCard(shopCardModel);
        
        expect(shopCard.cardModel, equals(shopCardModel));
        expect(shopCard.shopCardModel, equals(shopCardModel));
        expect(shopCard.cardModel.name, equals('Shop Item'));
        expect(shopCard.shopCardModel.cost, equals(10));
      });

      testWithFlameGame('inherits from Card properly', (game) async {
        final shopCardModel = ShopCardModel(name: 'Inherited Card', cost: 5);
        final shopCard = ShopCard(shopCardModel);
        
        // Should have all Card properties
        expect(shopCard.cardModel, isNotNull);
        expect(shopCard.cardModel.name, equals('Inherited Card'));
        expect(shopCard.cardModel.type, equals('Shop'));
      });
    });

    group('face-up display functionality (extended)', () {
      testWithFlameGame('displays name and cost when face up', (game) async {
        final shopCardModel = ShopCardModel(name: 'Magic Sword', cost: 15, isFaceUp: true);
        final shopCard = ShopCard(shopCardModel)..size = Vector2(100, 150);
        
        await game.ensureAdd(shopCard);
        
        final textComponents = shopCard.children.whereType<TextComponent>().toList();
        expect(textComponents.length, equals(2));
        
        final nameComponent = textComponents.firstWhere((c) => c.text == 'Magic Sword');
        final costComponent = textComponents.firstWhere((c) => c.text == 'Cost: 15');
        
        expect(nameComponent.text, equals('Magic Sword'));
        expect(costComponent.text, equals('Cost: 15'));
      });

      testWithFlameGame('positions name text higher than center', (game) async {
        final shopCardModel = ShopCardModel(name: 'Positioned Card', cost: 8);
        final shopCard = ShopCard(shopCardModel)..size = Vector2(100, 150);
        
        await game.ensureAdd(shopCard);
        
        final nameComponent = shopCard.children.whereType<TextComponent>()
            .firstWhere((c) => c.text == 'Positioned Card');
        
        // Should be positioned higher than center (y = 75 - 15 = 60)
        expect(nameComponent.position, equals(Vector2(50, 60)));
      });

      testWithFlameGame('positions cost text lower than center', (game) async {
        final shopCardModel = ShopCardModel(name: 'Cost Card', cost: 12);
        final shopCard = ShopCard(shopCardModel)..size = Vector2(100, 150);
        
        await game.ensureAdd(shopCard);
        
        final costComponent = shopCard.children.whereType<TextComponent>()
            .firstWhere((c) => c.text == 'Cost: 12');
        
        // Should be positioned lower than center (y = 75 + 15 = 90)
        expect(costComponent.position, equals(Vector2(50, 90)));
      });

      testWithFlameGame('both text components are centered horizontally', (game) async {
        final shopCardModel = ShopCardModel(name: 'Centered Card', cost: 20);
        final shopCard = ShopCard(shopCardModel)..size = Vector2(200, 300);
        
        await game.ensureAdd(shopCard);
        
        final textComponents = shopCard.children.whereType<TextComponent>().toList();
        
        for (final component in textComponents) {
          expect(component.position.x, equals(100)); // Half of width
          expect(component.anchor, equals(Anchor.center));
        }
      });
    });

    group('face-down display functionality (extended)', () {
      testWithFlameGame('shows only back text when face down', (game) async {
        final shopCardModel = ShopCardModel(name: 'Hidden Item', cost: 25, isFaceUp: false);
        final shopCard = ShopCard(shopCardModel)..size = Vector2(100, 150);
        
        await game.ensureAdd(shopCard);
        
        final textComponents = shopCard.children.whereType<TextComponent>().toList();
        expect(textComponents.length, equals(1));
        
        final backComponent = textComponents.first;
        expect(backComponent.text, equals('Back'));
        expect(backComponent.position, equals(Vector2(50, 75))); // centered
      });

      testWithFlameGame('calls parent implementation for face-down cards', (game) async {
        final shopCardModel = ShopCardModel(name: 'Parent Call Card', cost: 30, isFaceUp: false);
        final shopCard = ShopCard(shopCardModel)..size = Vector2(100, 150);
        
        await game.ensureAdd(shopCard);
        
        // Should behave exactly like base Card class when face down
        final textComponents = shopCard.children.whereType<TextComponent>().toList();
        expect(textComponents.length, equals(1));
        expect(textComponents.first.text, equals('Back'));
      });
    });

    group('cost display variations', () {
      final costTestCases = [
        {'cost': 0, 'expected': 'Cost: 0'},
        {'cost': 1, 'expected': 'Cost: 1'},
        {'cost': 10, 'expected': 'Cost: 10'},
        {'cost': 999, 'expected': 'Cost: 999'},
        {'cost': -5, 'expected': 'Cost: -5'},
      ];

      for (final testCase in costTestCases) {
        testWithFlameGame('displays cost ${testCase['cost']} correctly', (game) async {
          final shopCardModel = ShopCardModel(
            name: 'Test Card',
            cost: testCase['cost'] as int,
          );
          final shopCard = ShopCard(shopCardModel)..size = Vector2(100, 150);
          
          await game.ensureAdd(shopCard);
          
          final costComponent = shopCard.children.whereType<TextComponent>()
              .firstWhere((c) => c.text == testCase['expected']);
          
          expect(costComponent.text, equals(testCase['expected']));
        });
      }
    });

    group('different card sizes', () {
      final sizeTestCases = [
        {
          'size': Vector2(80, 120),
          'namePos': Vector2(40, 45), // center.y - 15
          'costPos': Vector2(40, 75), // center.y + 15
        },
        {
          'size': Vector2(120, 180),
          'namePos': Vector2(60, 75), // center.y - 15
          'costPos': Vector2(60, 105), // center.y + 15
        },
        {
          'size': Vector2(200, 300),
          'namePos': Vector2(100, 135), // center.y - 15
          'costPos': Vector2(100, 165), // center.y + 15
        },
      ];

      for (final testCase in sizeTestCases) {
        testWithFlameGame('text positioning for size ${testCase['size']}', (game) async {
          final shopCardModel = ShopCardModel(name: 'Size Test', cost: 5);
          final shopCard = ShopCard(shopCardModel)..size = testCase['size'] as Vector2;
          
          await game.ensureAdd(shopCard);
          
          final nameComponent = shopCard.children.whereType<TextComponent>()
              .firstWhere((c) => c.text == 'Size Test');
          final costComponent = shopCard.children.whereType<TextComponent>()
              .firstWhere((c) => c.text == 'Cost: 5');
          
          expect(nameComponent.position, equals(testCase['namePos']));
          expect(costComponent.position, equals(testCase['costPos']));
        });
      }
    });

    group('text styling and appearance', () {
      testWithFlameGame('name text uses inherited styling from base Card', (game) async {
        final shopCardModel = ShopCardModel(name: 'Styled Name', cost: 8);
        final shopCard = ShopCard(shopCardModel)..size = Vector2(100, 150);
        
        await game.ensureAdd(shopCard);
        
        final nameComponent = shopCard.children.whereType<TextComponent>()
            .firstWhere((c) => c.text == 'Styled Name');
        
        expect(nameComponent.textRenderer, isNotNull);
        expect(nameComponent.anchor, equals(Anchor.center));
      });

      testWithFlameGame('cost text has proper styling', (game) async {
        final shopCardModel = ShopCardModel(name: 'Cost Style', cost: 12);
        final shopCard = ShopCard(shopCardModel)..size = Vector2(100, 150);
        
        await game.ensureAdd(shopCard);
        
        final costComponent = shopCard.children.whereType<TextComponent>()
            .firstWhere((c) => c.text == 'Cost: 12');
        
        expect(costComponent.textRenderer, isNotNull);
        expect(costComponent.anchor, equals(Anchor.center));
      });
    });

    group('edge cases and error handling', () {
      testWithFlameGame('handles empty card name with cost', (game) async {
        final shopCardModel = ShopCardModel(name: '', cost: 7);
        final shopCard = ShopCard(shopCardModel)..size = Vector2(100, 150);
        
        await game.ensureAdd(shopCard);
        
        final textComponents = shopCard.children.whereType<TextComponent>().toList();
        expect(textComponents.length, equals(2));
        
        final nameComponent = textComponents.firstWhere((c) => c.text == '');
        final costComponent = textComponents.firstWhere((c) => c.text == 'Cost: 7');
        
        expect(nameComponent.text, equals(''));
        expect(costComponent.text, equals('Cost: 7'));
      });

      testWithFlameGame('handles very long card names with cost', (game) async {
        final longName = 'This is an extremely long card name that should still display correctly';
        final shopCardModel = ShopCardModel(name: longName, cost: 100);
        final shopCard = ShopCard(shopCardModel)..size = Vector2(100, 150);
        
        await game.ensureAdd(shopCard);
        
        final nameComponent = shopCard.children.whereType<TextComponent>()
            .firstWhere((c) => c.text == longName);
        final costComponent = shopCard.children.whereType<TextComponent>()
            .firstWhere((c) => c.text == 'Cost: 100');
        
        expect(nameComponent.text, equals(longName));
        expect(costComponent.text, equals('Cost: 100'));
      });

      testWithFlameGame('handles special characters in name', (game) async {
        final specialName = 'Magical Sword ⚔️ with 特殊字符';
        final shopCardModel = ShopCardModel(name: specialName, cost: 50);
        final shopCard = ShopCard(shopCardModel)..size = Vector2(100, 150);
        
        await game.ensureAdd(shopCard);
        
        final nameComponent = shopCard.children.whereType<TextComponent>()
            .firstWhere((c) => c.text == specialName);
        
        expect(nameComponent.text, equals(specialName));
      });
    });

    group('state changes and updates', () {
      testWithFlameGame('maintains cost display when name changes', (game) async {
        final shopCardModel = ShopCardModel(name: 'Original Name', cost: 15);
        final shopCard = TestShopCard(shopCardModel)..size = Vector2(100, 150);
        
        await game.ensureAdd(shopCard);
        
        // Initially should show both name and cost
        expect(shopCard.children.whereType<TextComponent>().length, equals(2));
        
        // Cost should remain consistent
        final costComponent = shopCard.children.whereType<TextComponent>()
            .firstWhere((c) => c.text == 'Cost: 15');
        expect(costComponent.text, equals('Cost: 15'));
      });

      testWithFlameGame('responds to face up/down state changes', (game) async {
        final shopCardModel = ShopCardModel(name: 'State Card', cost: 20, isFaceUp: true);
        final shopCard = TestShopCard(shopCardModel)..size = Vector2(100, 150);
        
        await game.ensureAdd(shopCard);
        
        // Initially face up - should show name and cost
        expect(shopCard.children.whereType<TextComponent>().length, equals(2));
        
        // Change to face down and refresh
        shopCardModel.isFaceUp = false;
        shopCard.refreshDisplay();
        await game.ready();
        
        // Should now show only back text
        expect(shopCard.children.whereType<TextComponent>().length, equals(1));
        expect(shopCard.children.whereType<TextComponent>().first.text, equals('Back'));
      });
    });

    group('integration with shop model', () {
      testWithFlameGame('works with ShopCardModel from shop generation', (game) async {
        final shopCardModel = ShopCardModel(name: 'Generated Item', cost: 1);
        final shopCard = ShopCard(shopCardModel)..size = Vector2(100, 150);
        
        await game.ensureAdd(shopCard);
        
        expect(shopCard.shopCardModel.name, equals('Generated Item'));
        expect(shopCard.shopCardModel.cost, equals(1));
        expect(shopCard.shopCardModel.type, equals('Shop'));
      });
    });
  });
}

// Test helper class
class TestShopCard extends ShopCard {
  TestShopCard(super.shopCardModel);

  void refreshDisplay() {
    final textComponents = children.whereType<TextComponent>().toList();
    for (final component in textComponents) {
      remove(component);
    }
    addTextComponent();
  }
}
