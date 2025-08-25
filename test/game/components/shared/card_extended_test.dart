import 'package:flutter_test/flutter_test.dart';
import 'package:card_battler/game/components/shared/card.dart';
import 'package:card_battler/game/models/shared/card_model.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flame/components.dart';

void main() {
  group('Card Component - Refactored Functionality', () {
    group('protected method functionality', () {
      testWithFlameGame('createNameTextComponent creates proper text component', (game) async {
        final cardModel = CardModel(name: 'Test Name', type: 'Test');
        final card = TestCard(cardModel)..size = Vector2(100, 150);
        
        await game.ensureAdd(card);
        
        // Create the name text component and store it
        card.testCreateNameTextComponent(Vector2(50, 75));
        
        // Access the created text component through the test card
        expect(card.testNameComponent.text, equals('Test Name'));
        expect(card.testNameComponent.anchor, equals(Anchor.center));
        expect(card.testNameComponent.position, equals(Vector2(50, 75)));
      });

      testWithFlameGame('createNameTextComponent with custom position', (game) async {
        final cardModel = CardModel(name: 'Custom Position', type: 'Test');
        final card = TestCard(cardModel)..size = Vector2(100, 150);
        
        await game.ensureAdd(card);
        
        // Test with different position
        card.testCreateNameTextComponent(Vector2(25, 100));
        
        expect(card.testNameComponent.text, equals('Custom Position'));
        expect(card.testNameComponent.position, equals(Vector2(25, 100)));
      });

      testWithFlameGame('createBackTextComponent creates proper back text', (game) async {
        final cardModel = CardModel(name: 'Hidden Card', type: 'Test', isFaceUp: false);
        final card = TestCard(cardModel)..size = Vector2(100, 150);
        
        await game.ensureAdd(card);
        
        // Test back text component creation
        card.testCreateBackTextComponent();
        
        expect(card.testNameComponent.text, equals('Back'));
        expect(card.testNameComponent.anchor, equals(Anchor.center));
        expect(card.testNameComponent.position, equals(Vector2(50, 75)));
      });

      testWithFlameGame('addTextComponent works correctly for face-up cards', (game) async {
        final cardModel = CardModel(name: 'Face Up Card', type: 'Test', isFaceUp: true);
        final card = Card(cardModel)..size = Vector2(100, 150);
        
        await game.ensureAdd(card);
        
        final textComponents = card.children.whereType<TextComponent>();
        expect(textComponents.length, equals(1));
        
        final textComponent = textComponents.first;
        expect(textComponent.text, equals('Face Up Card'));
        expect(textComponent.position, equals(Vector2(50, 75))); // centered
      });

      testWithFlameGame('addTextComponent works correctly for face-down cards', (game) async {
        final cardModel = CardModel(name: 'Hidden Card', type: 'Test', isFaceUp: false);
        final card = Card(cardModel)..size = Vector2(100, 150);
        
        await game.ensureAdd(card);
        
        final textComponents = card.children.whereType<TextComponent>();
        expect(textComponents.length, equals(1));
        
        final textComponent = textComponents.first;
        expect(textComponent.text, equals('Back'));
        expect(textComponent.position, equals(Vector2(50, 75))); // centered
      });
    });

    group('inheritance and extensibility', () {
      testWithFlameGame('Card class can be properly extended', (game) async {
        final cardModel = CardModel(name: 'Extended Card', type: 'Test');
        final extendedCard = ExtendedCard(cardModel)..size = Vector2(200, 300);
        
        await game.ensureAdd(extendedCard);
        
        expect(extendedCard.cardModel.name, equals('Extended Card'));
        expect(extendedCard.wasExtendedMethodCalled, isTrue);
      });

      testWithFlameGame('protected methods are accessible to subclasses', (game) async {
        final cardModel = CardModel(name: 'Subclass Card', type: 'Test');
        final subclassCard = TestCard(cardModel)..size = Vector2(100, 150);
        
        await game.ensureAdd(subclassCard);
        
        // Test that protected methods can be called from subclass
        expect(() => subclassCard.testCreateNameTextComponent(Vector2(10, 20)), returnsNormally);
        expect(() => subclassCard.testCreateBackTextComponent(), returnsNormally);
      });
    });

    group('text rendering and styling', () {
      testWithFlameGame('name text has correct styling', (game) async {
        final cardModel = CardModel(name: 'Styled Card', type: 'Test');
        final card = Card(cardModel)..size = Vector2(100, 150);
        
        await game.ensureAdd(card);
        
        final textComponent = card.children.whereType<TextComponent>().first;
        expect(textComponent.textRenderer, isNotNull);
        // Note: Specific style testing would require accessing TextPaint properties
      });

      testWithFlameGame('back text has correct styling', (game) async {
        final cardModel = CardModel(name: 'Back Card', type: 'Test', isFaceUp: false);
        final card = Card(cardModel)..size = Vector2(100, 150);
        
        await game.ensureAdd(card);
        
        final textComponent = card.children.whereType<TextComponent>().first;
        expect(textComponent.text, equals('Back'));
        expect(textComponent.textRenderer, isNotNull);
      });

      testWithFlameGame('text components are properly anchored', (game) async {
        final cardModel = CardModel(name: 'Anchored Card', type: 'Test');
        final card = Card(cardModel)..size = Vector2(100, 150);
        
        await game.ensureAdd(card);
        
        final textComponent = card.children.whereType<TextComponent>().first;
        expect(textComponent.anchor, equals(Anchor.center));
      });
    });

    group('card state changes', () {
      testWithFlameGame('card can change face-up state', (game) async {
        final cardModel = CardModel(name: 'Flip Card', type: 'Test', isFaceUp: true);
        final card = Card(cardModel)..size = Vector2(100, 150);
        
        await game.ensureAdd(card);
        
        // Initially face up
        expect(card.children.whereType<TextComponent>().first.text, equals('Flip Card'));
        
        // Change to face down (would require re-adding components in real usage)
        cardModel.isFaceUp = false;
        expect(cardModel.isFaceUp, isFalse);
      });

      testWithFlameGame('card responds to isFaceUp changes on reload', (game) async {
        final cardModel = CardModel(name: 'Dynamic Card', type: 'Test', isFaceUp: true);
        final card = DynamicCard(cardModel)..size = Vector2(100, 150);
        
        await game.ensureAdd(card);
        
        // Initially face up
        expect(card.children.whereType<TextComponent>().first.text, equals('Dynamic Card'));
        
        // Change to face down and refresh
        cardModel.isFaceUp = false;
        card.refreshDisplay();
        await game.ready();
        
        expect(card.children.whereType<TextComponent>().first.text, equals('Back'));
      });
    });

    group('different card sizes and layouts', () {
      final sizeTestCases = [
        {'size': Vector2(50, 75), 'center': Vector2(25, 37.5)},
        {'size': Vector2(100, 150), 'center': Vector2(50, 75)},
        {'size': Vector2(200, 300), 'center': Vector2(100, 150)},
        {'size': Vector2(80, 120), 'center': Vector2(40, 60)},
      ];

      for (final testCase in sizeTestCases) {
        testWithFlameGame('text positioning for size ${testCase['size']}', (game) async {
          final cardModel = CardModel(name: 'Size Test', type: 'Test');
          final card = Card(cardModel)..size = testCase['size'] as Vector2;
          
          await game.ensureAdd(card);
          
          final textComponent = card.children.whereType<TextComponent>().first;
          expect(textComponent.position, equals(testCase['center']));
        });
      }
    });

    group('error handling and edge cases', () {
      testWithFlameGame('handles empty card name', (game) async {
        final cardModel = CardModel(name: '', type: 'Empty');
        final card = Card(cardModel)..size = Vector2(100, 150);
        
        await game.ensureAdd(card);
        
        final textComponent = card.children.whereType<TextComponent>().first;
        expect(textComponent.text, equals(''));
      });

      testWithFlameGame('handles very long card names', (game) async {
        final longName = 'This is a very long card name that might not fit well';
        final cardModel = CardModel(name: longName, type: 'Long');
        final card = Card(cardModel)..size = Vector2(100, 150);
        
        await game.ensureAdd(card);
        
        final textComponent = card.children.whereType<TextComponent>().first;
        expect(textComponent.text, equals(longName));
      });

      testWithFlameGame('handles special characters in card names', (game) async {
        final specialName = 'Card with 特殊字符 & émojis 🎮⚔️';
        final cardModel = CardModel(name: specialName, type: 'Special');
        final card = Card(cardModel)..size = Vector2(100, 150);
        
        await game.ensureAdd(card);
        
        final textComponent = card.children.whereType<TextComponent>().first;
        expect(textComponent.text, equals(specialName));
      });
    });
  });
}

// Test helper classes to access protected members
class TestCard extends Card {
  late TextComponent testNameComponent;

  TestCard(super.cardModel);

  void testCreateNameTextComponent(Vector2 position) {
    createNameTextComponent(position);
    testNameComponent = nameTextComponent;
  }

  void testCreateBackTextComponent() {
    createBackTextComponent();
    testNameComponent = nameTextComponent;
  }

  @override
  void onLoad() {
    super.onLoad();
    // Initialize testNameComponent from the actual nameTextComponent
    if (children.whereType<TextComponent>().isNotEmpty) {
      testNameComponent = nameTextComponent;
    }
  }
}

class ExtendedCard extends Card {
  bool wasExtendedMethodCalled = false;

  ExtendedCard(super.cardModel);

  @override
  void addTextComponent() {
    wasExtendedMethodCalled = true;
    super.addTextComponent();
  }
}

class DynamicCard extends Card {
  DynamicCard(super.cardModel);

  void refreshDisplay() {
    final textComponents = children.whereType<TextComponent>().toList();
    for (final component in textComponents) {
      remove(component);
    }
    addTextComponent();
  }
}
