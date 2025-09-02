import 'package:flutter_test/flutter_test.dart';
import 'package:flame_test/flame_test.dart';
import 'package:card_battler/game/components/shared/card/actionable_card.dart';
import 'package:card_battler/game/components/shared/flat_button.dart';
import 'package:card_battler/game/models/shared/card_model.dart';
import 'package:flame/components.dart';

void main() {
  group('ActionableCard', () {
    late CardModel cardModel;

    setUp(() {
      cardModel = CardModel(name: 'Test Card', type: 'test');
    });

    group('constructor and initialization', () {
      testWithFlameGame('creates with card model', (game) async {
        final card = ActionableCard(cardModel);
        
        expect(card.cardModel, equals(cardModel));
        expect(card.onButtonPressed, isNull);
      });

      testWithFlameGame('creates with button press callback', (game) async {
        bool callbackTriggered = false;
        final card = ActionableCard(cardModel, onButtonPressed: () {
          callbackTriggered = true;
        });
        
        expect(card.cardModel, equals(cardModel));
        expect(card.onButtonPressed, isNotNull);
      });
    });

    group('button functionality', () {
      testWithFlameGame('has button after onLoad', (game) async {
        final card = ActionableCard(cardModel)..size = Vector2(100, 150);
        
        await game.ensureAdd(card);
        
        final buttons = card.children.whereType<FlatButton>().toList();
        expect(buttons.length, equals(1));
        
        final button = buttons.first;
        expect(button.isVisible, isFalse);
      });

      testWithFlameGame('button has correct default label', (game) async {
        final card = ActionableCard(cardModel)..size = Vector2(100, 150);
        
        await game.ensureAdd(card);
        
        final button = card.children.whereType<FlatButton>().first;
        final textComponent = button.children.whereType<TextComponent>().first;
        expect(textComponent.text, equals('Play'));
      });

      testWithFlameGame('button visibility can be controlled', (game) async {
        final card = ActionableCard(cardModel)..size = Vector2(100, 150);
        
        await game.ensureAdd(card);
        
        expect(card.isButtonVisible, isFalse);
        
        card.isButtonVisible = true;
        expect(card.isButtonVisible, isTrue);
        
        card.isButtonVisible = false;
        expect(card.isButtonVisible, isFalse);
      });

      testWithFlameGame('button disabled state can be controlled', (game) async {
        final card = ActionableCard(cardModel)..size = Vector2(100, 150);
        
        await game.ensureAdd(card);
        
        expect(card.buttonDisabled, isFalse);
        
        card.buttonDisabled = true;
        expect(card.buttonDisabled, isTrue);
        
        card.buttonDisabled = false;
        expect(card.buttonDisabled, isFalse);
      });

      testWithFlameGame('button triggers card play when clicked', (game) async {
        bool cardPlayed = false;
        cardModel.onCardPlayed = () => cardPlayed = true;
        
        final card = ActionableCard(cardModel)..size = Vector2(100, 150);
        
        await game.ensureAdd(card);
        
        card.isButtonVisible = true;
        card.buttonDisabled = false;
        
        final button = card.children.whereType<FlatButton>().first;
        button.onReleased?.call();
        
        expect(cardPlayed, isTrue);
      });

      testWithFlameGame('button does not trigger when disabled', (game) async {
        bool cardPlayed = false;
        cardModel.onCardPlayed = () => cardPlayed = true;
        
        final card = ActionableCard(cardModel)..size = Vector2(100, 150);
        
        await game.ensureAdd(card);
        
        card.isButtonVisible = true;
        card.buttonDisabled = true;
        
        final button = card.children.whereType<FlatButton>().first;
        button.onReleased?.call();
        
        expect(cardPlayed, isFalse);
      });

      testWithFlameGame('button does not trigger when not visible', (game) async {
        bool cardPlayed = false;
        cardModel.onCardPlayed = () => cardPlayed = true;
        
        final card = ActionableCard(cardModel)..size = Vector2(100, 150);
        
        await game.ensureAdd(card);
        
        card.isButtonVisible = false;
        card.buttonDisabled = false;
        
        final button = card.children.whereType<FlatButton>().first;
        button.onReleased?.call();
        
        expect(cardPlayed, isFalse);
      });
    });

    group('button customization', () {
      testWithFlameGame('addButton creates button with custom properties', (game) async {
        final card = ActionableCard(cardModel)..size = Vector2(100, 150);
        
        await game.ensureAdd(card);
        
        bool customActionCalled = false;
        final customButton = card.addButton('Custom', 50.0, () {
          customActionCalled = true;
        });
        
        expect(customButton, isA<FlatButton>());
        expect(customButton.position.x, equals(50.0));
        expect(customButton.size.x, equals(100.0));
        expect(customButton.size.y, equals(15.0)); // 0.1 * 150
        
        customButton.onReleased?.call();
        expect(customActionCalled, isTrue);
      });

      testWithFlameGame('multiple buttons can be added', (game) async {
        final card = ActionableCard(cardModel)..size = Vector2(100, 150);
        
        await game.ensureAdd(card);
        
        final button1 = card.addButton('First', 25.0, () {});
        final button2 = card.addButton('Second', 75.0, () {});
        
        final buttons = card.children.whereType<FlatButton>().toList();
        expect(buttons.length, equals(3)); // Original Play button + 2 custom buttons
        expect(buttons, contains(button1));
        expect(buttons, contains(button2));
      });
    });

    group('inheritance from Card', () {
      testWithFlameGame('inherits card rendering and text display', (game) async {
        final card = ActionableCard(cardModel)..size = Vector2(100, 150);
        
        await game.ensureAdd(card);
        
        // Should have text component from parent Card class
        final textComponents = card.children.whereType<TextComponent>();
        expect(textComponents.length, greaterThanOrEqualTo(1));
        
        // Plus the button
        final buttons = card.children.whereType<FlatButton>();
        expect(buttons.length, equals(1));
        
        // Total children should include both
        expect(card.children.length, equals(2));
      });

      testWithFlameGame('card model properties are accessible', (game) async {
        final namedCard = CardModel(name: 'Special Card', type: 'magic');
        final card = ActionableCard(namedCard)..size = Vector2(100, 150);
        
        await game.ensureAdd(card);
        
        expect(card.cardModel.name, equals('Special Card'));
        expect(card.cardModel.type, equals('magic'));
      });
    });
  });
}