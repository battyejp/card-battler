import 'package:flutter_test/flutter_test.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:card_battler/game/components/shared/card/card_interaction_controller.dart';
import 'package:card_battler/game/components/shared/card/actionable_card.dart';
import 'package:card_battler/game/models/shared/card_model.dart';

void main() {
  group('CardInteractionController', () {
    late CardModel cardModel;
    late ActionableCard card;
    late CardInteractionController controller;

    setUp(() {
      cardModel = CardModel(name: 'Test Card', type: 'test');
      card = ActionableCard(cardModel);
      controller = CardInteractionController(card, null);
    });

    tearDown(() {
      // Reset static state between tests
      CardInteractionController.deselectAny();
    });

    group('constructor and initialization', () {
      testWithFlameGame('creates with card and no button enabled callback', (game) async {
        final testController = CardInteractionController(card, null);
        
        expect(testController.card, equals(card));
        expect(testController.isSelected, isFalse);
        expect(testController.isAnimating, isFalse);
      });

      testWithFlameGame('creates with card and button enabled callback', (game) async {
        bool buttonEnabled() => true;
        final testController = CardInteractionController(card, buttonEnabled);
        
        expect(testController.card, equals(card));
        expect(testController.isSelected, isFalse);
        expect(testController.isAnimating, isFalse);
      });
    });

    group('static state management', () {
      testWithFlameGame('selectedController is null initially', (game) async {
        expect(CardInteractionController.selectedController, isNull);
        expect(CardInteractionController.isAnyCardSelected, isFalse);
      });

      testWithFlameGame('deselectAny works when no card is selected', (game) async {
        CardInteractionController.deselectAny();
        expect(CardInteractionController.selectedController, isNull);
      });

      testWithFlameGame('isAnyCardSelected returns true when card is selected', (game) async {
        card.size = Vector2(100, 150);
        await game.ensureAdd(card);
        
        // Simulate selection by calling onTapUp
        final tapEvent = TapUpEvent(1, TapUpInfo(Vector2.zero(), Vector2.zero()));
        controller.onTapUp(tapEvent);
        
        // Wait for animation to complete
        await game.ready();
        game.update(1.0); // Complete animation
        
        expect(CardInteractionController.isAnyCardSelected, isTrue);
        expect(CardInteractionController.selectedController, equals(controller));
      });
    });

    group('selection behavior', () {
      testWithFlameGame('onTapUp selects card when no card is selected', (game) async {
        card.size = Vector2(100, 150);
        await game.ensureAdd(card);
        
        expect(controller.isSelected, isFalse);
        
        final tapEvent = TapUpEvent(1, TapUpInfo(Vector2.zero(), Vector2.zero()));
        final handled = controller.onTapUp(tapEvent);
        
        expect(handled, isTrue);
        expect(controller.isSelected, isTrue);
        expect(controller.isAnimating, isTrue);
        expect(CardInteractionController.selectedController, equals(controller));
      });

      testWithFlameGame('onTapUp works when same card is already selected', (game) async {
        card.size = Vector2(100, 150);
        await game.ensureAdd(card);
        
        // First selection
        final tapEvent1 = TapUpEvent(1, TapUpInfo(Vector2.zero(), Vector2.zero()));
        controller.onTapUp(tapEvent1);
        
        expect(controller.isSelected, isTrue);
        
        // Complete animation
        game.update(1.0);
        
        // Second tap on same card
        final tapEvent2 = TapUpEvent(1, TapUpInfo(Vector2(50, 50), Vector2(50, 50)));
        final handled = controller.onTapUp(tapEvent2);
        
        expect(handled, isTrue);
      });

      testWithFlameGame('onTapUp ignores tap when different card is selected', (game) async {
        final card2 = ActionableCard(cardModel);
        final controller2 = CardInteractionController(card2, null);
        
        card.size = Vector2(100, 150);
        card2.size = Vector2(100, 150);
        await game.ensureAdd(card);
        await game.ensureAdd(card2);
        
        // Select first card
        final tapEvent1 = TapUpEvent(1, TapUpInfo(Vector2.zero(), Vector2.zero()));
        controller.onTapUp(tapEvent1);
        
        expect(controller.isSelected, isTrue);
        expect(CardInteractionController.selectedController, equals(controller));
        
        // Try to select second card
        final tapEvent2 = TapUpEvent(1, TapUpInfo(Vector2.zero(), Vector2.zero()));
        final handled = controller2.onTapUp(tapEvent2);
        
        expect(handled, isTrue);
        expect(controller2.isSelected, isFalse); // Second card should not be selected
        expect(CardInteractionController.selectedController, equals(controller)); // First card still selected
      });

      testWithFlameGame('onTapUp ignores tap during animation', (game) async {
        card.size = Vector2(100, 150);
        await game.ensureAdd(card);
        
        // First selection
        final tapEvent1 = TapUpEvent(1, TapUpInfo(Vector2.zero(), Vector2.zero()));
        controller.onTapUp(tapEvent1);
        
        expect(controller.isAnimating, isTrue);
        
        // Try to tap again while animating
        final tapEvent2 = TapUpEvent(1, TapUpInfo(Vector2(50, 50), Vector2(50, 50)));
        final handled = controller.onTapUp(tapEvent2);
        
        expect(handled, isTrue);
        expect(controller.isAnimating, isTrue); // Still animating
      });
    });

    group('selection with different cards', () {
      testWithFlameGame('selecting new card deselects previous card', (game) async {
        final card2 = ActionableCard(cardModel);
        final controller2 = CardInteractionController(card2, null);
        
        card.size = Vector2(100, 150);
        card2.size = Vector2(100, 150);
        await game.ensureAdd(card);
        await game.ensureAdd(card2);
        
        // Select first card
        final tapEvent1 = TapUpEvent(1, TapUpInfo(Vector2.zero(), Vector2.zero()));
        controller.onTapUp(tapEvent1);
        
        // Complete first animation
        game.update(1.0);
        
        expect(controller.isSelected, isTrue);
        expect(controller.isAnimating, isFalse);
        
        // Select second card
        final tapEvent2 = TapUpEvent(1, TapUpInfo(Vector2.zero(), Vector2.zero()));
        controller2.onTapUp(tapEvent2);
        
        expect(controller.isSelected, isFalse); // First card deselected
        expect(controller2.isSelected, isTrue); // Second card selected
        expect(CardInteractionController.selectedController, equals(controller2));
      });
    });

    group('button enabled callback functionality', () {
      testWithFlameGame('button is enabled when callback returns true', (game) async {
        bool buttonEnabled() => true;
        final testController = CardInteractionController(card, buttonEnabled);
        
        card.size = Vector2(100, 150);
        await game.ensureAdd(card);
        
        final tapEvent = TapUpEvent(1, TapUpInfo(Vector2.zero(), Vector2.zero()));
        testController.onTapUp(tapEvent);
        
        // Complete animation
        game.update(1.0);
        
        expect(card.buttonDisabled, isFalse);
      });

      testWithFlameGame('button is disabled when callback returns false', (game) async {
        bool buttonEnabled() => false;
        final testController = CardInteractionController(card, buttonEnabled);
        
        card.size = Vector2(100, 150);
        await game.ensureAdd(card);
        
        final tapEvent = TapUpEvent(1, TapUpInfo(Vector2.zero(), Vector2.zero()));
        testController.onTapUp(tapEvent);
        
        // Complete animation
        game.update(1.0);
        
        expect(card.buttonDisabled, isTrue);
      });

      testWithFlameGame('button is enabled when no callback provided', (game) async {
        final testController = CardInteractionController(card, null);
        
        card.size = Vector2(100, 150);
        await game.ensureAdd(card);
        
        final tapEvent = TapUpEvent(1, TapUpInfo(Vector2.zero(), Vector2.zero()));
        testController.onTapUp(tapEvent);
        
        // Complete animation
        game.update(1.0);
        
        expect(card.buttonDisabled, isFalse);
      });
    });

    group('card state changes during selection', () {
      testWithFlameGame('card button becomes visible after selection animation', (game) async {
        card.size = Vector2(100, 150);
        await game.ensureAdd(card);
        
        expect(card.isButtonVisible, isFalse);
        
        final tapEvent = TapUpEvent(1, TapUpInfo(Vector2.zero(), Vector2.zero()));
        controller.onTapUp(tapEvent);
        
        expect(card.isButtonVisible, isFalse); // Still false during animation
        
        // Complete animation
        game.update(1.0);
        
        expect(card.isButtonVisible, isTrue); // Now visible after animation
      });

      testWithFlameGame('card priority is increased during selection', (game) async {
        card.size = Vector2(100, 150);
        card.priority = 5;
        await game.ensureAdd(card);
        
        final tapEvent = TapUpEvent(1, TapUpInfo(Vector2.zero(), Vector2.zero()));
        controller.onTapUp(tapEvent);
        
        expect(card.priority, equals(99999)); // High priority during selection
      });

      testWithFlameGame('card priority is restored after deselection', (game) async {
        card.size = Vector2(100, 150);
        card.priority = 5;
        await game.ensureAdd(card);
        
        // Select card
        final tapEvent = TapUpEvent(1, TapUpInfo(Vector2.zero(), Vector2.zero()));
        controller.onTapUp(tapEvent);
        
        // Complete selection animation
        game.update(1.0);
        
        expect(card.priority, equals(99999));
        
        // Deselect card
        CardInteractionController.deselectAny();
        
        // Complete deselection animation
        game.update(1.0);
        
        expect(card.priority, equals(5)); // Original priority restored
      });
    });

    group('deselectAny functionality', () {
      testWithFlameGame('deselectAny deselects currently selected card', (game) async {
        card.size = Vector2(100, 150);
        await game.ensureAdd(card);
        
        // Select card
        final tapEvent = TapUpEvent(1, TapUpInfo(Vector2.zero(), Vector2.zero()));
        controller.onTapUp(tapEvent);
        
        // Complete selection animation
        game.update(1.0);
        
        expect(controller.isSelected, isTrue);
        expect(card.isButtonVisible, isTrue);
        
        // Deselect
        CardInteractionController.deselectAny();
        
        expect(controller.isSelected, isFalse);
        expect(controller.isAnimating, isTrue);
        expect(card.isButtonVisible, isFalse);
        expect(CardInteractionController.selectedController, isNull);
        
        // Complete deselection animation
        game.update(1.0);
        
        expect(controller.isAnimating, isFalse);
      });
    });

    group('animation state management', () {
      testWithFlameGame('isAnimating is true during selection', (game) async {
        card.size = Vector2(100, 150);
        await game.ensureAdd(card);
        
        expect(controller.isAnimating, isFalse);
        
        final tapEvent = TapUpEvent(1, TapUpInfo(Vector2.zero(), Vector2.zero()));
        controller.onTapUp(tapEvent);
        
        expect(controller.isAnimating, isTrue);
        
        // Complete animation
        game.update(1.0);
        
        expect(controller.isAnimating, isFalse);
      });

      testWithFlameGame('isAnimating is true during deselection', (game) async {
        card.size = Vector2(100, 150);
        await game.ensureAdd(card);
        
        // Select card
        final tapEvent = TapUpEvent(1, TapUpInfo(Vector2.zero(), Vector2.zero()));
        controller.onTapUp(tapEvent);
        
        // Complete selection
        game.update(1.0);
        expect(controller.isAnimating, isFalse);
        
        // Deselect
        CardInteractionController.deselectAny();
        
        expect(controller.isAnimating, isTrue);
        
        // Complete deselection
        game.update(1.0);
        
        expect(controller.isAnimating, isFalse);
      });
    });

    group('edge cases', () {
      testWithFlameGame('multiple rapid taps during animation are handled', (game) async {
        card.size = Vector2(100, 150);
        await game.ensureAdd(card);
        
        final tapEvent = TapUpEvent(1, TapUpInfo(Vector2.zero(), Vector2.zero()));
        
        // Multiple rapid taps
        expect(controller.onTapUp(tapEvent), isTrue);
        expect(controller.onTapUp(tapEvent), isTrue);
        expect(controller.onTapUp(tapEvent), isTrue);
        
        expect(controller.isSelected, isTrue);
        expect(controller.isAnimating, isTrue);
      });

      testWithFlameGame('deselection during animation is ignored', (game) async {
        card.size = Vector2(100, 150);
        await game.ensureAdd(card);
        
        // Select card
        final tapEvent = TapUpEvent(1, TapUpInfo(Vector2.zero(), Vector2.zero()));
        controller.onTapUp(tapEvent);
        
        expect(controller.isAnimating, isTrue);
        
        // Try to deselect during animation - should be ignored
        CardInteractionController.deselectAny();
        
        expect(controller.isSelected, isTrue); // Still selected
        expect(controller.isAnimating, isTrue); // Still animating selection
      });
    });
  });
}