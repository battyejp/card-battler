import 'package:flutter_test/flutter_test.dart';
import 'package:card_battler/game/components/shop/shop_card.dart';
import 'package:card_battler/game/models/shop/shop_card_model.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flame/components.dart';

void main() {
  group('ShopCard', () {
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

        expect(card.children.length, equals(2));
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

        expect(card.children.length, equals(2)); // name and cost components
        expect(card.cardModel.isFaceUp, equals(true));
      });

      testWithFlameGame('shop card shows card details when face up', (game) async {
        final cardModel = ShopCardModel(name: 'Fire Ball', cost: 5, isFaceUp: true);
        final card = ShopCard(cardModel)..size = Vector2(100, 150);

        await game.ensureAdd(card);

        expect(card.children.length, equals(2)); // name and cost components
        
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

        expect(card.children.length, equals(1)); // only back text
        
        final textComponents = card.children.whereType<TextComponent>().toList();
        expect(textComponents.first.text, equals('Back'));
      });
    });
  });
}
