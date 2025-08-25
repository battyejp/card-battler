import 'package:flutter_test/flutter_test.dart';
import 'package:card_battler/game/components/shop/shop.dart';
import 'package:card_battler/game/components/shop/shop_card.dart';
import 'package:card_battler/game/models/shop/shop_model.dart';
import 'package:card_battler/game/models/shop/shop_card_model.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flame/components.dart';

void main() {
  group('Shop Component - Extended Functionality', () {
    group('ShopCard integration', () {
      testWithFlameGame('creates ShopCard components instead of regular Cards', (game) async {
        final shopModel = ShopModel(numberOfRows: 2, numberOfColumns: 3);
        final shop = Shop(shopModel)..size = Vector2(300, 200);
        
        await game.ensureAdd(shop);
        
        final shopCards = shop.children.whereType<ShopCard>().toList();
        expect(shopCards.length, equals(6));
        
        // Verify they are ShopCard instances, not regular Card instances
        for (final shopCard in shopCards) {
          expect(shopCard, isA<ShopCard>());
          expect(shopCard.shopCardModel, isNotNull);
          expect(shopCard.shopCardModel.cost, isNotNull);
        }
      });

      testWithFlameGame('ShopCards display both name and cost', (game) async {
        final shopModel = ShopModel(numberOfRows: 1, numberOfColumns: 2);
        final shop = Shop(shopModel)..size = Vector2(200, 100);
        
        await game.ensureAdd(shop);
        
        final shopCards = shop.children.whereType<ShopCard>().toList();
        
        for (final shopCard in shopCards) {
          final textComponents = shopCard.children.whereType<TextComponent>().toList();
          expect(textComponents.length, equals(2)); // name + cost
          
          // Should have one text component with card name and one with cost
          final hasNameText = textComponents.any((c) => c.text == shopCard.shopCardModel.name);
          final hasCostText = textComponents.any((c) => c.text.startsWith('Cost:'));
          
          expect(hasNameText, isTrue);
          expect(hasCostText, isTrue);
        }
      });

      testWithFlameGame('ShopCards use correct ShopCardModel data', (game) async {
        final shopModel = ShopModel(numberOfRows: 2, numberOfColumns: 2);
        final shop = Shop(shopModel)..size = Vector2(200, 150);
        
        await game.ensureAdd(shop);
        
        final shopCards = shop.children.whereType<ShopCard>().toList();
        final selectableCards = shopModel.selectableCards;
        
        expect(shopCards.length, equals(selectableCards.length));
        
        for (int i = 0; i < shopCards.length; i++) {
          expect(shopCards[i].shopCardModel, equals(selectableCards[i]));
          expect(shopCards[i].shopCardModel.name, equals(selectableCards[i].name));
          expect(shopCards[i].shopCardModel.cost, equals(selectableCards[i].cost));
        }
      });
    });

    group('layout and positioning with ShopCards', () {
      testWithFlameGame('ShopCards maintain correct layout spacing', (game) async {
        final shopModel = ShopModel(numberOfRows: 2, numberOfColumns: 3);
        final shop = Shop(shopModel)..size = Vector2(300, 200);
        
        await game.ensureAdd(shop);
        
        final shopCards = shop.children.whereType<ShopCard>().toList();
        expect(shopCards.length, equals(6));
        
        // Verify cards are laid out in grid pattern
        // First row
        expect(shopCards[0].position.y, equals(shopCards[1].position.y)); // Same row
        expect(shopCards[1].position.y, equals(shopCards[2].position.y)); // Same row
        
        // Second row
        expect(shopCards[3].position.y, equals(shopCards[4].position.y)); // Same row
        expect(shopCards[4].position.y, equals(shopCards[5].position.y)); // Same row
        
        // Different rows have different y positions
        expect(shopCards[0].position.y, isNot(equals(shopCards[3].position.y)));
      });

      testWithFlameGame('ShopCards have consistent sizes', (game) async {
        final shopModel = ShopModel(numberOfRows: 2, numberOfColumns: 2);
        final shop = Shop(shopModel)..size = Vector2(200, 150);
        
        await game.ensureAdd(shop);
        
        final shopCards = shop.children.whereType<ShopCard>().toList();
        final firstCardSize = shopCards.first.size;
        
        for (final shopCard in shopCards) {
          expect(shopCard.size, equals(firstCardSize));
        }
      });
    });

    group('different shop configurations with ShopCards', () {
      final configTestCases = [
        {'rows': 1, 'cols': 3, 'expectedCards': 3},
        {'rows': 2, 'cols': 2, 'expectedCards': 4},
        {'rows': 3, 'cols': 2, 'expectedCards': 6},
        {'rows': 2, 'cols': 4, 'expectedCards': 8},
      ];

      for (final config in configTestCases) {
        testWithFlameGame('${config['rows']}x${config['cols']} shop creates correct ShopCards', (game) async {
          final shopModel = ShopModel(
            numberOfRows: config['rows'] as int,
            numberOfColumns: config['cols'] as int,
          );
          final shop = Shop(shopModel)..size = Vector2(400, 300);
          
          await game.ensureAdd(shop);
          
          final shopCards = shop.children.whereType<ShopCard>().toList();
          expect(shopCards.length, equals(config['expectedCards']));
          
          // Each should be a proper ShopCard with cost display
          for (final shopCard in shopCards) {
            expect(shopCard, isA<ShopCard>());
            final costTexts = shopCard.children.whereType<TextComponent>()
                .where((c) => c.text.startsWith('Cost:')).toList();
            expect(costTexts.length, equals(1));
          }
        });
      }
    });

    group('ShopCard rendering and display', () {
      testWithFlameGame('all ShopCards render without errors', (game) async {
        final shopModel = ShopModel(numberOfRows: 3, numberOfColumns: 3);
        final shop = Shop(shopModel)..size = Vector2(450, 350);
        
        await game.ensureAdd(shop);
        
        final shopCards = shop.children.whereType<ShopCard>().toList();
        
        for (final shopCard in shopCards) {
          expect(shopCard.isMounted, isTrue);
          expect(shopCard.size.x, greaterThan(0));
          expect(shopCard.size.y, greaterThan(0));
          expect(shopCard.children.whereType<TextComponent>().length, equals(2));
        }
      });

      testWithFlameGame('ShopCards display correct cost formatting', (game) async {
        final shopModel = ShopModel(numberOfRows: 1, numberOfColumns: 3);
        final shop = Shop(shopModel)..size = Vector2(300, 100);
        
        await game.ensureAdd(shop);
        
        final shopCards = shop.children.whereType<ShopCard>().toList();
        
        for (final shopCard in shopCards) {
          final costComponent = shopCard.children.whereType<TextComponent>()
              .firstWhere((c) => c.text.startsWith('Cost:'));
          
          expect(costComponent.text, matches(r'Cost: \d+'));
          expect(costComponent.text, equals('Cost: ${shopCard.shopCardModel.cost}'));
        }
      });
    });

    group('dynamic shop behavior with ShopCards', () {
      testWithFlameGame('shop with fewer selectable cards than grid slots', (game) async {
        // Create a shop model that has fewer cards than grid positions
        final shopModel = TestShopModel(numberOfRows: 2, numberOfColumns: 3, availableCards: 4);
        final shop = Shop(shopModel)..size = Vector2(300, 200);
        
        await game.ensureAdd(shop);
        
        final shopCards = shop.children.whereType<ShopCard>().toList();
        expect(shopCards.length, equals(4)); // Should only create cards for available items
        
        for (final shopCard in shopCards) {
          expect(shopCard, isA<ShopCard>());
        }
      });

      testWithFlameGame('empty shop creates no ShopCards', (game) async {
        final shopModel = TestShopModel(numberOfRows: 2, numberOfColumns: 3, availableCards: 0);
        final shop = Shop(shopModel)..size = Vector2(300, 200);
        
        await game.ensureAdd(shop);
        
        final shopCards = shop.children.whereType<ShopCard>().toList();
        expect(shopCards.length, equals(0));
      });
    });

    group('integration with game flow', () {
      testWithFlameGame('ShopCards are ready for interaction', (game) async {
        final shopModel = ShopModel(numberOfRows: 2, numberOfColumns: 2);
        final shop = Shop(shopModel)..size = Vector2(200, 150);
        
        await game.ensureAdd(shop);
        
        final shopCards = shop.children.whereType<ShopCard>().toList();
        
        for (final shopCard in shopCards) {
          expect(shopCard.isMounted, isTrue);
          expect(shopCard.shopCardModel, isNotNull);
          expect(shopCard.shopCardModel.cost, greaterThanOrEqualTo(0));
          
          // Should be positioned within shop bounds
          expect(shopCard.position.x, greaterThanOrEqualTo(0));
          expect(shopCard.position.y, greaterThanOrEqualTo(0));
          expect(shopCard.position.x + shopCard.size.x, lessThanOrEqualTo(shop.size.x));
          expect(shopCard.position.y + shopCard.size.y, lessThanOrEqualTo(shop.size.y));
        }
      });
    });

    group('performance and efficiency', () {
      testWithFlameGame('large shop creates ShopCards efficiently', (game) async {
        final shopModel = ShopModel(numberOfRows: 2, numberOfColumns: 3); // 6 cards max, limited by available (10)
        final shop = Shop(shopModel)..size = Vector2(300, 200);
        
        await game.ensureAdd(shop);
        
        final shopCards = shop.children.whereType<ShopCard>().toList();
        expect(shopCards.length, equals(6)); // 2 rows * 3 columns = 6
        
        // All cards should be properly initialized
        for (final shopCard in shopCards) {
          expect(shopCard.shopCardModel, isNotNull);
          expect(shopCard.children.whereType<TextComponent>().length, equals(2));
        }
      });
    });
  });
}

// Test helper class to create shop models with specific card counts
class TestShopModel extends ShopModel {
  TestShopModel({
    required super.numberOfRows,
    required super.numberOfColumns,
    required int availableCards,
  }) {
    // Override the generated cards with a specific number
    _allCards.clear();
    _selectableCards.clear();
    
    for (int i = 0; i < availableCards; i++) {
      _selectableCards.add(ShopCardModel(name: 'Test Card ${i + 1}', cost: i + 1));
    }
  }
  
  // Access to private fields for testing
  List<ShopCardModel> get _allCards => super.allCards;
  List<ShopCardModel> get _selectableCards => super.selectableCards;
}
