import 'package:flutter_test/flutter_test.dart';
import 'package:flame_test/flame_test.dart';
import 'package:card_battler/game/components/shared/card/card_interaction_controller.dart';
import 'package:card_battler/game/components/shared/card/actionable_card.dart';
import 'package:card_battler/game/models/shared/card_model.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';

void main() {
  group('CardInteractionController', () {
    late ActionableCard card;
    late CardModel cardModel;
    late CardInteractionController controller;

    setUp(() {
      cardModel = CardModel(name: 'Test Card', type: 'test');
      card = ActionableCard(cardModel)..size = Vector2(100, 150);
      controller = CardInteractionController(card, null);
    });

    group('constructor and initialization', () {
      test('creates with card parameter', () {
        expect(controller, isNotNull);
      });

      test('creates with card and button enablement function', () {
        bool Function() enablementFunction() => true;
        final controllerWithFunction = CardInteractionController(card, enablementFunction);
        expect(controllerWithFunction, isNotNull);
      });

      test('initially not selected', () {
        expect(controller.isSelected, isFalse);
      });

      test('initially not animating', () {
        expect(controller.isAnimating, isFalse);
      });
    });

    group('static selection management', () {
      test('selectedController is null initially', () {
        expect(CardInteractionController.selectedController, isNull);
      });

      test('isAnyCardSelected is false initially', () {
        expect(CardInteractionController.isAnyCardSelected, isFalse);
      });

      test('deselectAny can be called safely when no card is selected', () {
        expect(() => CardInteractionController.deselectAny(), returnsNormally);
      });

      testWithFlameGame('onTapUp handles tap events and returns boolean', (game) async {
        await game.ensureAdd(card);
        
        final tapEvent = TapUpEvent(1, game, TapUpDetails(localPosition: Vector2(50, 75)));
        final result = controller.onTapUp(tapEvent);
        
        expect(result, isA<bool>());
        expect(result, isTrue);
      });

      testWithFlameGame('tapping selects the card', (game) async {
        await game.ensureAdd(card);
        
        expect(controller.isSelected, isFalse);
        
        final tapEvent = TapUpEvent(1, game, TapUpDetails(localPosition: Vector2(50, 75)));
        controller.onTapUp(tapEvent);
        
        expect(controller.isSelected, isTrue);
      });

      testWithFlameGame('selecting card updates static state', (game) async {
        await game.ensureAdd(card);
        
        expect(CardInteractionController.isAnyCardSelected, isFalse);
        expect(CardInteractionController.selectedController, isNull);
        
        final tapEvent = TapUpEvent(1, game, TapUpDetails(localPosition: Vector2(50, 75)));
        controller.onTapUp(tapEvent);
        
        expect(CardInteractionController.isAnyCardSelected, isTrue);
        expect(CardInteractionController.selectedController, equals(controller));
      });

      testWithFlameGame('deselectAny deselects current selection', (game) async {
        await game.ensureAdd(card);
        
        final tapEvent = TapUpEvent(1, game, TapUpDetails(localPosition: Vector2(50, 75)));
        controller.onTapUp(tapEvent);
        
        expect(controller.isSelected, isTrue);
        
        CardInteractionController.deselectAny();
        
        expect(controller.isSelected, isFalse);
        expect(CardInteractionController.isAnyCardSelected, isFalse);
      });
    });

    group('button enablement integration', () {
      testWithFlameGame('button state is set based on enablement function', (game) async {
        bool buttonEnabled = true;
        final controllerWithEnabler = CardInteractionController(card, () => buttonEnabled);
        
        await game.ensureAdd(card);
        
        expect(card.isButtonVisible, isFalse);
        
        final tapEvent = TapUpEvent(1, game, TapUpDetails(localPosition: Vector2(50, 75)));
        controllerWithEnabler.onTapUp(tapEvent);
        
        expect(card.isButtonVisible, isTrue);
      });

      testWithFlameGame('button enabled by default when no enablement function', (game) async {
        final controllerNoEnabler = CardInteractionController(card, null);
        
        await game.ensureAdd(card);
        
        final tapEvent = TapUpEvent(1, game, TapUpDetails(localPosition: Vector2(50, 75)));
        controllerNoEnabler.onTapUp(tapEvent);
        
        expect(card.isButtonVisible, isTrue);
        expect(card.buttonDisabled, isFalse);
      });
    });

    group('card visual state changes', () {
      testWithFlameGame('card priority changes on selection', (game) async {
        await game.ensureAdd(card);
        
        final initialPriority = card.priority;
        
        final tapEvent = TapUpEvent(1, game, TapUpDetails(localPosition: Vector2(50, 75)));
        controller.onTapUp(tapEvent);
        
        expect(card.priority, greaterThan(initialPriority));
      });

      testWithFlameGame('button visibility changes with selection', (game) async {
        await game.ensureAdd(card);
        
        expect(card.isButtonVisible, isFalse);
        
        final tapEvent = TapUpEvent(1, game, TapUpDetails(localPosition: Vector2(50, 75)));
        controller.onTapUp(tapEvent);
        
        expect(card.isButtonVisible, isTrue);
        
        CardInteractionController.deselectAny();
        expect(card.isButtonVisible, isFalse);
      });
    });

    group('multiple controller interaction', () {
      testWithFlameGame('selecting one card deselects others', (game) async {
        final card2 = ActionableCard(CardModel(name: 'Card 2', type: 'test'))
          ..size = Vector2(100, 150);
        final controller2 = CardInteractionController(card2, null);
        
        await game.ensureAdd(card);
        await game.ensureAdd(card2);
        
        // Select first card
        final tapEvent1 = TapUpEvent(1, game, TapUpDetails(localPosition: Vector2(50, 75)));
        controller.onTapUp(tapEvent1);
        
        expect(controller.isSelected, isTrue);
        expect(controller2.isSelected, isFalse);
        
        // Select second card
        final tapEvent2 = TapUpEvent(2, game, TapUpDetails(localPosition: Vector2(50, 75)));
        controller2.onTapUp(tapEvent2);
        
        expect(controller.isSelected, isFalse); // First should be deselected
        expect(controller2.isSelected, isTrue);
      });
    });

    group('edge cases', () {
      testWithFlameGame('tapping already selected card does not deselect', (game) async {
        await game.ensureAdd(card);
        
        final tapEvent = TapUpEvent(1, game, TapUpDetails(localPosition: Vector2(50, 75)));
        
        controller.onTapUp(tapEvent);
        expect(controller.isSelected, isTrue);
        
        // Tap again
        controller.onTapUp(tapEvent);
        expect(controller.isSelected, isTrue); // Should remain selected
      });

      testWithFlameGame('controller works with card that has no game initially', (game) async {
        // Card not added to game yet
        final tapEvent = TapUpEvent(1, game, TapUpDetails(localPosition: Vector2(50, 75)));
        expect(() => controller.onTapUp(tapEvent), returnsNormally);
      });
    });
  });
}