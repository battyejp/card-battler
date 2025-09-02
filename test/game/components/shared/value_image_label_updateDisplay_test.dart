import 'package:flutter_test/flutter_test.dart';
import 'package:flame_test/flame_test.dart';
import 'package:card_battler/game/components/shared/value_image_label.dart';
import 'package:card_battler/game/models/shared/value_image_label_model.dart';
import 'package:flame/components.dart';

void main() {
  group('ValueImageLabel updateDisplay fix', () {

    group('updateDisplay behavior', () {
      testWithFlameGame('creates text component on first updateDisplay call', (game) async {
        final model = ValueImageLabelModel(value: 10, label: 'Health');
        final component = ValueImageLabel(model)..size = Vector2(100, 50);
        
        await game.ensureAdd(component);
        
        // Component should have text component after updateDisplay
        final textComponents = component.children.whereType<TextComponent>();
        expect(textComponents.length, equals(1));
        expect(textComponents.first.text, equals('Health: 10'));
      });

      testWithFlameGame('updates existing text component on subsequent calls', (game) async {
        final model = ValueImageLabelModel(value: 10, label: 'Score');
        final component = ValueImageLabel(model)..size = Vector2(100, 50);
        
        await game.ensureAdd(component);
        
        // Initial state
        final initialTextComponent = component.children.whereType<TextComponent>().first;
        expect(initialTextComponent.text, equals('Score: 10'));
        
        // Update the model value
        model.changeValue(15);
        
        // Text should be updated to new value
        final updatedTextComponent = component.children.whereType<TextComponent>().first;
        expect(updatedTextComponent.text, equals('Score: 25'));
        expect(identical(initialTextComponent, updatedTextComponent), isTrue); // Same component instance
      });

      testWithFlameGame('does not add multiple text components', (game) async {
        final model = ValueImageLabelModel(value: 5, label: 'Lives');
        final component = ValueImageLabel(model)..size = Vector2(100, 50);
        
        await game.ensureAdd(component);
        
        // Initial state - should have one text component
        expect(component.children.whereType<TextComponent>().length, equals(1));
        
        // Trigger multiple updates
        model.changeValue(1);
        model.changeValue(2);
        model.changeValue(3);
        
        // Should still have only one text component
        expect(component.children.whereType<TextComponent>().length, equals(1));
        expect(component.children.whereType<TextComponent>().first.text, equals('Lives: 11'));
      });

      testWithFlameGame('text component reflects model changes immediately', (game) async {
        final model = ValueImageLabelModel(value: 100, label: 'Gold');
        final component = ValueImageLabel(model)..size = Vector2(100, 50);
        
        await game.ensureAdd(component);
        
        // Verify initial text
        var textComponent = component.children.whereType<TextComponent>().first;
        expect(textComponent.text, equals('Gold: 100'));
        
        // Change value and verify update
        model.changeValue(-50);
        textComponent = component.children.whereType<TextComponent>().first;
        expect(textComponent.text, equals('Gold: 50'));
        
        // Another change
        model.changeValue(25);
        textComponent = component.children.whereType<TextComponent>().first;
        expect(textComponent.text, equals('Gold: 75'));
      });

      testWithFlameGame('handles zero and negative values correctly', (game) async {
        final model = ValueImageLabelModel(value: 0, label: 'Balance');
        final component = ValueImageLabel(model)..size = Vector2(100, 50);
        
        await game.ensureAdd(component);
        
        // Initial zero value
        var textComponent = component.children.whereType<TextComponent>().first;
        expect(textComponent.text, equals('Balance: 0'));
        
        // Negative value
        model.changeValue(-10);
        textComponent = component.children.whereType<TextComponent>().first;
        expect(textComponent.text, equals('Balance: -10'));
        
        // Back to positive
        model.changeValue(20);
        textComponent = component.children.whereType<TextComponent>().first;
        expect(textComponent.text, equals('Balance: 10'));
      });

      testWithFlameGame('preserves text component positioning and styling', (game) async {
        final model = ValueImageLabelModel(value: 42, label: 'Answer');
        final component = ValueImageLabel(model)..size = Vector2(200, 100);
        
        await game.ensureAdd(component);
        
        final textComponent = component.children.whereType<TextComponent>().first;
        
        // Verify positioning (should be centered)
        expect(textComponent.anchor, equals(Anchor.topLeft));
        expect(textComponent.position.x, equals(100.0)); // size.x / 2
        expect(textComponent.position.y, equals(50.0));  // size.y / 2
        
        // Update value and verify positioning is preserved
        model.changeValue(8);
        
        final updatedTextComponent = component.children.whereType<TextComponent>().first;
        expect(updatedTextComponent.anchor, equals(Anchor.topLeft));
        expect(updatedTextComponent.position.x, equals(100.0));
        expect(updatedTextComponent.position.y, equals(50.0));
        expect(updatedTextComponent.text, equals('Answer: 50'));
      });
    });

    group('component lifecycle integration', () {
      testWithFlameGame('updateDisplay works correctly after component reload', (game) async {
        final model = ValueImageLabelModel(value: 20, label: 'Reload Test');
        final component = ValueImageLabel(model)..size = Vector2(100, 50);
        
        await game.ensureAdd(component);
        
        // Initial state
        expect(component.children.whereType<TextComponent>().first.text, equals('Reload Test: 20'));
        
        // Remove and re-add component
        game.remove(component);
        await game.ensureAdd(component);
        
        // Should still work correctly
        expect(component.children.whereType<TextComponent>().first.text, equals('Reload Test: 20'));
        
        // Updates should still work
        model.changeValue(5);
        expect(component.children.whereType<TextComponent>().first.text, equals('Reload Test: 25'));
      });

      testWithFlameGame('multiple ValueImageLabel instances work independently', (game) async {
        final model1 = ValueImageLabelModel(value: 10, label: 'HP');
        final model2 = ValueImageLabelModel(value: 20, label: 'MP');
        
        final component1 = ValueImageLabel(model1)..size = Vector2(100, 50);
        final component2 = ValueImageLabel(model2)..size = Vector2(100, 50);
        
        await game.ensureAdd(component1);
        await game.ensureAdd(component2);
        
        // Verify initial states
        expect(component1.children.whereType<TextComponent>().first.text, equals('HP: 10'));
        expect(component2.children.whereType<TextComponent>().first.text, equals('MP: 20'));
        
        // Update first component only
        model1.changeValue(5);
        
        expect(component1.children.whereType<TextComponent>().first.text, equals('HP: 15'));
        expect(component2.children.whereType<TextComponent>().first.text, equals('MP: 20')); // Unchanged
        
        // Update second component only
        model2.changeValue(-5);
        
        expect(component1.children.whereType<TextComponent>().first.text, equals('HP: 15')); // Unchanged
        expect(component2.children.whereType<TextComponent>().first.text, equals('MP: 15'));
      });
    });

    group('edge cases and error handling', () {
      testWithFlameGame('handles empty label correctly', (game) async {
        final model = ValueImageLabelModel(value: 100, label: '');
        final component = ValueImageLabel(model)..size = Vector2(100, 50);
        
        await game.ensureAdd(component);
        
        final textComponent = component.children.whereType<TextComponent>().first;
        expect(textComponent.text, equals(': 100'));
        
        model.changeValue(50);
        expect(textComponent.text, equals(': 150'));
      });

      testWithFlameGame('handles very large values correctly', (game) async {
        final model = ValueImageLabelModel(value: 999999, label: 'Big Number');
        final component = ValueImageLabel(model)..size = Vector2(100, 50);
        
        await game.ensureAdd(component);
        
        final textComponent = component.children.whereType<TextComponent>().first;
        expect(textComponent.text, equals('Big Number: 999999'));
        
        model.changeValue(1);
        expect(textComponent.text, equals('Big Number: 1000000'));
      });

      testWithFlameGame('handles special characters in labels', (game) async {
        final model = ValueImageLabelModel(value: 50, label: 'HP/MP Ratio');
        final component = ValueImageLabel(model)..size = Vector2(100, 50);
        
        await game.ensureAdd(component);
        
        final textComponent = component.children.whereType<TextComponent>().first;
        expect(textComponent.text, equals('HP/MP Ratio: 50'));
        
        model.changeValue(-25);
        expect(textComponent.text, equals('HP/MP Ratio: 25'));
      });
    });
  });
}