import 'package:flutter_test/flutter_test.dart';
import 'package:card_battler/game_legacy/components/shared/value_image_label.dart';
import 'package:card_battler/game_legacy/components/shared/reactive_position_component.dart';
import 'package:card_battler/game_legacy/models/shared/value_image_label_model.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flame/components.dart';

void main() {
  group('ValueImageLabel', () {
    group('constructor and initialization', () {
      testWithFlameGame('creates with ValueImageLabelModel parameter', (game) async {
        final model = ValueImageLabelModel(value: 10, label: 'Health');
        final label = ValueImageLabel(model);

        await game.ensureAdd(label);

        expect(label.model, equals(model));
      });

      testWithFlameGame('extends ReactivePositionComponent', (game) async {
        final model = ValueImageLabelModel(value: 5, label: 'Test');
        final label = ValueImageLabel(model);

        expect(label, isA<ReactivePositionComponent<ValueImageLabelModel>>());
      });

      testWithFlameGame('creates with different model values', (game) async {
        final models = [
          ValueImageLabelModel(value: 0, label: 'Zero'),
          ValueImageLabelModel(value: -50, label: 'Negative'),
          ValueImageLabelModel(value: 999, label: 'Large'),
        ];

        for (final model in models) {
          final label = ValueImageLabel(model);
          await game.ensureAdd(label);
          expect(label.model, equals(model));
          game.remove(label);
        }
      });
    });

    group('text component creation and display', () {
      testWithFlameGame('creates text component on load', (game) async {
        final model = ValueImageLabelModel(value: 42, label: 'Answer');
        final label = ValueImageLabel(model);

        await game.ensureAdd(label);

        final textComponents = label.children.whereType<TextComponent>().toList();
        expect(textComponents.length, equals(1));
      });

      testWithFlameGame('text component displays model display text', (game) async {
        final model = ValueImageLabelModel(value: 100, label: 'Health');
        final label = ValueImageLabel(model);

        await game.ensureAdd(label);

        final textComponent = label.children.whereType<TextComponent>().first;
        expect(textComponent.text, equals('Health: 100'));
      });

      testWithFlameGame('text component has correct styling', (game) async {
        final model = ValueImageLabelModel(value: 25, label: 'Mana');
        final label = ValueImageLabel(model);

        await game.ensureAdd(label);

        final textComponent = label.children.whereType<TextComponent>().first;
        expect(textComponent.anchor, equals(Anchor.topLeft));
        expect(textComponent.textRenderer, isNotNull);
      });

      testWithFlameGame('only creates one text component', (game) async {
        final model = ValueImageLabelModel(value: 50, label: 'Score');
        final label = ValueImageLabel(model);

        await game.ensureAdd(label);

        // Trigger updateDisplay multiple times
        label.updateDisplay();
        label.updateDisplay();
        label.updateDisplay();

        final textComponents = label.children.whereType<TextComponent>().toList();
        expect(textComponents.length, equals(1));
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
        await game.ready(); // Wait for reactive update
        
        final updatedTextComponent = component.children.whereType<TextComponent>().first;
        expect(updatedTextComponent.anchor, equals(Anchor.topLeft));
        expect(updatedTextComponent.position.x, equals(100.0));
        expect(updatedTextComponent.position.y, equals(50.0));
        expect(updatedTextComponent.text, equals('Answer: 50'));
      });
    });

    group('display updates', () {
      testWithFlameGame('updates text when model changes', (game) async {
        final model = ValueImageLabelModel(value: 50, label: 'Energy');
        final label = ValueImageLabel(model);

        await game.ensureAdd(label);

        final textComponent = label.children.whereType<TextComponent>().first;
        expect(textComponent.text, equals('Energy: 50'));

        // Change model value
        model.changeValue(25);
        label.updateDisplay();

        expect(textComponent.text, equals('Energy: 75'));
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
        await game.ready(); // Wait for reactive update
        textComponent = component.children.whereType<TextComponent>().first;
        expect(textComponent.text, equals('Gold: 50'));
        
        // Another change
        model.changeValue(25);
        await game.ready(); // Wait for reactive update
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
        await game.ready(); // Wait for reactive update
        textComponent = component.children.whereType<TextComponent>().first;
        expect(textComponent.text, equals('Balance: -10'));
        
        // Back to positive
        model.changeValue(20);
        await game.ready(); // Wait for reactive update
        textComponent = component.children.whereType<TextComponent>().first;
        expect(textComponent.text, equals('Balance: 10'));
      });

      testWithFlameGame('handles large values in display', (game) async {
        final model = ValueImageLabelModel(value: 1000000, label: 'Gold');
        final label = ValueImageLabel(model);

        await game.ensureAdd(label);

        final textComponent = label.children.whereType<TextComponent>().first;
        expect(textComponent.text, equals('Gold: 1000000'));
      });

      testWithFlameGame('does not add multiple text components on updates', (game) async {
        final model = ValueImageLabelModel(value: 5, label: 'Lives');
        final component = ValueImageLabel(model)..size = Vector2(100, 50);
        
        await game.ensureAdd(component);
        
        // Initial state - should have one text component
        expect(component.children.whereType<TextComponent>().length, equals(1));
        
        // Trigger multiple updates
        model.changeValue(1);
        model.changeValue(2);
        model.changeValue(3);
        await game.ready(); // Wait for reactive update
        
        // Should still have only one text component
        expect(component.children.whereType<TextComponent>().length, equals(1));
        expect(component.children.whereType<TextComponent>().first.text, equals('Lives: 11'));
      });
    });

    group('reactive behavior', () {
      testWithFlameGame('inherits reactive capabilities from ReactivePositionComponent', (game) async {
        final model = ValueImageLabelModel(value: 30, label: 'Power');
        final label = ValueImageLabel(model);

        await game.ensureAdd(label);

        // Should have access to reactive methods
        expect(() => label.updateDisplay(), returnsNormally);
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
        await game.ready(); // Wait for reactive update
        
        expect(component1.children.whereType<TextComponent>().first.text, equals('HP: 15'));
        expect(component2.children.whereType<TextComponent>().first.text, equals('MP: 20')); // Unchanged
        
        // Update second component only
        model2.changeValue(-5);
        await game.ready(); // Wait for reactive update
        
        expect(component1.children.whereType<TextComponent>().first.text, equals('HP: 15')); // Unchanged
        expect(component2.children.whereType<TextComponent>().first.text, equals('MP: 15'));
      });
    });

    group('component properties', () {
      testWithFlameGame('can be positioned and sized', (game) async {
        final model = ValueImageLabelModel(value: 20, label: 'Position');
        final label = ValueImageLabel(model)
          ..size = Vector2(150, 30)
          ..position = Vector2(10, 5);

        await game.ensureAdd(label);

        expect(label.size, equals(Vector2(150, 30)));
        expect(label.position, equals(Vector2(10, 5)));
      });

      testWithFlameGame('can be anchored', (game) async {
        final model = ValueImageLabelModel(value: 35, label: 'Anchor');
        final label = ValueImageLabel(model)
          ..anchor = Anchor.center;

        await game.ensureAdd(label);

        expect(label.anchor, equals(Anchor.center));
      });

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
        await game.ready(); // Wait for reactive update
        expect(component.children.whereType<TextComponent>().first.text, equals('Reload Test: 25'));
      });
    });

    group('edge cases', () {
      testWithFlameGame('handles empty label text', (game) async {
        final model = ValueImageLabelModel(value: 42, label: '');
        final label = ValueImageLabel(model);

        await game.ensureAdd(label);

        final textComponent = label.children.whereType<TextComponent>().first;
        expect(textComponent.text, equals(': 42'));
      });

      testWithFlameGame('handles special characters in label', (game) async {
        final model = ValueImageLabelModel(value: 10, label: 'HP/MP@#');
        final label = ValueImageLabel(model);

        await game.ensureAdd(label);

        final textComponent = label.children.whereType<TextComponent>().first;
        expect(textComponent.text, equals('HP/MP@#: 10'));
      });

      testWithFlameGame('handles very long label text', (game) async {
        final longLabel = 'This is a very long label that might cause display issues';
        final model = ValueImageLabelModel(value: 5, label: longLabel);
        final label = ValueImageLabel(model);

        await game.ensureAdd(label);

        final textComponent = label.children.whereType<TextComponent>().first;
        expect(textComponent.text, equals('$longLabel: 5'));
      });

      testWithFlameGame('handles extreme value changes', (game) async {
        final model = ValueImageLabelModel(value: 0, label: 'Extreme');
        final label = ValueImageLabel(model);

        await game.ensureAdd(label);

        // Make extreme changes
        model.changeValue(999999);
        label.updateDisplay();
        
        final textComponent = label.children.whereType<TextComponent>().first;
        expect(textComponent.text, equals('Extreme: 999999'));

        model.changeValue(-1999999);
        label.updateDisplay();
        
        expect(textComponent.text, equals('Extreme: -1000000'));
      });
    });

    group('multiple instances', () {
      testWithFlameGame('multiple labels work independently', (game) async {
        final models = [
          ValueImageLabelModel(value: 100, label: 'Health'),
          ValueImageLabelModel(value: 50, label: 'Mana'),
          ValueImageLabelModel(value: 25, label: 'Stamina'),
        ];

        final labels = models.map((m) => ValueImageLabel(m)).toList();

        for (final label in labels) {
          await game.ensureAdd(label);
        }

        // Verify each label displays correctly
        for (int i = 0; i < labels.length; i++) {
          final textComponent = labels[i].children.whereType<TextComponent>().first;
          expect(textComponent.text, equals(models[i].display));
        }

        // Modify one model and verify others are unaffected
        models[0].changeValue(-30);
        labels[0].updateDisplay();

        final texts = labels.map((l) => l.children.whereType<TextComponent>().first.text).toList();
        expect(texts[0], equals('Health: 70'));
        expect(texts[1], equals('Mana: 50'));
        expect(texts[2], equals('Stamina: 25'));
      });
    });
  });
}