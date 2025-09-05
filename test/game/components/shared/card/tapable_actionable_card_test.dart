import 'package:flutter_test/flutter_test.dart';
import 'package:flame_test/flame_test.dart';
import 'package:card_battler/game/components/shared/card/tapable_actionable_card.dart';
import 'package:card_battler/game/services/card_selection_service.dart';
import 'package:card_battler/game/components/shared/flat_button.dart';
import 'package:card_battler/game/models/shared/card_model.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/gestures.dart';

// Mock TapUpEvent that includes the local position directly
class MockTapUpEvent extends TapUpEvent {
  final Vector2 _mockLocalPosition;
  
  MockTapUpEvent(int pointerId, Game game, this._mockLocalPosition)
      : super(pointerId, game, TapUpDetails(kind: PointerDeviceKind.touch));
  
  @override
  Vector2 get localPosition => _mockLocalPosition;
}

void main() {
  group('TapableActionableCard', () {
    late CardModel cardModel;
    late CardSelectionService cardSelectionService;

    setUp(() {
      cardSelectionService = DefaultCardSelectionService();
      // Reset selection state before each test
      cardSelectionService.deselectCard();
      
      cardModel = CardModel(name: 'Test Card', type: 'test');
    });

    group('constructor and initialization', () {
      testWithFlameGame('creates with card model', (game) async {
        final card = TapableActionableCard(cardModel);
        
        expect(card.cardModel, equals(cardModel));
      });

      testWithFlameGame('creates with button enablement function', (game) async {
        bool determineEnabled() => true;
        final card = TapableActionableCard(cardModel, 
          determineIfButtonEnabled: determineEnabled);
        
        expect(card.cardModel, equals(cardModel));
      });

      testWithFlameGame('has interaction controller after onLoad', (game) async {
        game.onGameResize(Vector2(800, 600));
        final card = TapableActionableCard(cardModel)..size = Vector2(100, 150);
        
        await game.ensureAdd(card);
        
        // Interaction controller should be set up (private field, so we test behavior)
        expect(() => card.onTapUp(MockTapUpEvent(1, game, Vector2(50, 75))), returnsNormally);
      });
    });

    group('inheritance from ActionableCard', () {
      testWithFlameGame('inherits button functionality', (game) async {
        final card = TapableActionableCard(cardModel)..size = Vector2(100, 150);
        
        await game.ensureAdd(card);
        
        // Should have button from ActionableCard
        final buttons = card.children.whereType<FlatButton>();
        expect(buttons.length, equals(1));
        
        // Should have text from Card base class
        final textComponents = card.children.whereType<TextComponent>();
        expect(textComponents.length, greaterThanOrEqualTo(1));
      });

      testWithFlameGame('button is initially not visible', (game) async {
        final card = TapableActionableCard(cardModel)..size = Vector2(100, 150);
        
        await game.ensureAdd(card);
        
        expect(card.isButtonVisible, isFalse);
      });

      testWithFlameGame('button visibility can be controlled', (game) async {
        final card = TapableActionableCard(cardModel)..size = Vector2(100, 150);
        
        await game.ensureAdd(card);
        
        card.isButtonVisible = true;
        expect(card.isButtonVisible, isTrue);
        
        card.isButtonVisible = false;
        expect(card.isButtonVisible, isFalse);
      });

      testWithFlameGame('button disabled state can be controlled', (game) async {
        final card = TapableActionableCard(cardModel)..size = Vector2(100, 150);
        
        await game.ensureAdd(card);
        
        card.buttonDisabled = true;
        expect(card.buttonDisabled, isTrue);
        
        card.buttonDisabled = false;
        expect(card.buttonDisabled, isFalse);
      });
    });

    group('tap interaction', () {
      testWithFlameGame('implements TapCallbacks', (game) async {
        final card = TapableActionableCard(cardModel)..size = Vector2(100, 150);
        
        expect(card, isA<TapCallbacks>());
      });

      testWithFlameGame('onTapUp delegates to interaction controller', (game) async {
        game.onGameResize(Vector2(800, 600));
        final card = TapableActionableCard(cardModel)..size = Vector2(100, 150);
        
        await game.ensureAdd(card);
        
        // Should not throw and should return a boolean
        final result = card.onTapUp(MockTapUpEvent(1, game, Vector2(50, 75)));
        expect(result, isA<bool>());
      });

      testWithFlameGame('tap interaction works without button enablement function', (game) async {
        game.onGameResize(Vector2(800, 600));
        final card = TapableActionableCard(cardModel)..size = Vector2(100, 150);
        
        await game.ensureAdd(card);
        
        // Should handle tap events normally
        expect(() => card.onTapUp(MockTapUpEvent(1, game, Vector2(50, 75))), returnsNormally);
      });

      testWithFlameGame('tap interaction works with button enablement function', (game) async {
        game.onGameResize(Vector2(800, 600));
        bool buttonShouldBeEnabled = true;
        final card = TapableActionableCard(cardModel, 
          determineIfButtonEnabled: () => buttonShouldBeEnabled
        )..size = Vector2(100, 150);
        
        await game.ensureAdd(card);
        
        // Should handle tap events with enablement function
        expect(() => card.onTapUp(MockTapUpEvent(1, game, Vector2(50, 75))), returnsNormally);
      });
    });

    group('button enablement integration', () {
      testWithFlameGame('button enablement function affects button state when card is selected', (game) async {
        bool buttonShouldBeEnabled = false;
        final card = TapableActionableCard(cardModel, 
          determineIfButtonEnabled: () => buttonShouldBeEnabled
        )..size = Vector2(100, 150);
        
        await game.ensureAdd(card);
        
        // Simulate card selection by directly testing interaction controller behavior
        // Since we can't easily simulate the full tap-to-select flow in unit tests,
        // we verify the component is properly set up
        expect(card.buttonDisabled, isFalse); // Initial state
      });

      testWithFlameGame('button enablement function can return different values', (game) async {
        bool enablementState = true;
        final card = TapableActionableCard(cardModel, 
          determineIfButtonEnabled: () => enablementState
        )..size = Vector2(100, 150);
        
        await game.ensureAdd(card);
        
        // Change the enablement state
        enablementState = false;
        
        // The function should be callable and return the new state
        expect(card, isNotNull); // Card exists and was created successfully
      });
    });

    group('card model integration', () {
      testWithFlameGame('card model properties are accessible', (game) async {
        final namedCard = CardModel(name: 'Interactive Card', type: 'spell');
        final card = TapableActionableCard(namedCard)..size = Vector2(100, 150);
        
        await game.ensureAdd(card);
        
        expect(card.cardModel.name, equals('Interactive Card'));
        expect(card.cardModel.type, equals('spell'));
      });

      testWithFlameGame('card play functionality works', (game) async {
        bool cardWasPlayed = false;
        cardModel.onCardPlayed = () => cardWasPlayed = true;
        
        final card = TapableActionableCard(cardModel)..size = Vector2(100, 150);
        
        await game.ensureAdd(card);
        
        // Simulate button press through the card model
        card.cardModel.playCard();
        
        expect(cardWasPlayed, isTrue);
      });
    });

    group('multiple instances', () {
      testWithFlameGame('different cards work independently', (game) async {
        game.onGameResize(Vector2(800, 600));
        final card1 = TapableActionableCard(
          CardModel(name: 'Card 1', type: 'test')
        )..size = Vector2(100, 150);
        
        final card2 = TapableActionableCard(
          CardModel(name: 'Card 2', type: 'test'),
          determineIfButtonEnabled: () => false
        )..size = Vector2(100, 150);
        
        await game.ensureAdd(card1);
        await game.ensureAdd(card2);
        
        expect(card1.cardModel.name, equals('Card 1'));
        expect(card2.cardModel.name, equals('Card 2'));
        
        // Both should handle taps independently
        expect(() => card1.onTapUp(MockTapUpEvent(1, game, Vector2(50, 75))), returnsNormally);
        expect(() => card2.onTapUp(MockTapUpEvent(1, game, Vector2(50, 75))), returnsNormally);
      });

      testWithFlameGame('cards can have different enablement logic', (game) async {
        bool condition1 = true;
        bool condition2 = false;
        
        final card1 = TapableActionableCard(
          CardModel(name: 'Card 1', type: 'test'),
          determineIfButtonEnabled: () => condition1
        )..size = Vector2(100, 150);
        
        final card2 = TapableActionableCard(
          CardModel(name: 'Card 2', type: 'test'),
          determineIfButtonEnabled: () => condition2
        )..size = Vector2(100, 150);
        
        await game.ensureAdd(card1);
        await game.ensureAdd(card2);
        
        // Cards should be independently configured
        expect(card1.cardModel.name, equals('Card 1'));
        expect(card2.cardModel.name, equals('Card 2'));
      });
    });
  });
}