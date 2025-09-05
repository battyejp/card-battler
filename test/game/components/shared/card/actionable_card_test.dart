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
        final card = ActionableCard(cardModel, onButtonPressed: () {
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

      testWithFlameGame('button triggers callback when clicked', (game) async {
        bool callbackTriggered = false;
        
        final card = ActionableCard(cardModel, onButtonPressed: () {
          callbackTriggered = true;
        })..size = Vector2(100, 150);
        
        await game.ensureAdd(card);
        
        card.isButtonVisible = true;
        card.buttonDisabled = false;
        
        final button = card.children.whereType<FlatButton>().first;
        button.onReleased?.call();
        
        expect(callbackTriggered, isTrue);
      });

      testWithFlameGame('button does not trigger when disabled', (game) async {
        bool callbackTriggered = false;
        
        final card = ActionableCard(cardModel, onButtonPressed: () {
          callbackTriggered = true;
        })..size = Vector2(100, 150);
        
        await game.ensureAdd(card);
        
        card.isButtonVisible = true;
        card.buttonDisabled = true;
        
        final button = card.children.whereType<FlatButton>().first;
        button.onReleased?.call();
        
        expect(callbackTriggered, isFalse);
      });

      testWithFlameGame('button does not trigger when not visible', (game) async {
        bool callbackTriggered = false;
        
        final card = ActionableCard(cardModel, onButtonPressed: () {
          callbackTriggered = true;
        })..size = Vector2(100, 150);
        
        await game.ensureAdd(card);
        
        card.isButtonVisible = false;
        card.buttonDisabled = false;
        
        final button = card.children.whereType<FlatButton>().first;
        button.onReleased?.call();
        
        expect(callbackTriggered, isFalse);
      });
    });

  });
}