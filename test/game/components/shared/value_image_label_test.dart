import 'package:flutter_test/flutter_test.dart';
import 'package:card_battler/game/components/shared/value_image_label.dart';
import 'package:card_battler/game/components/shared/reactive_position_component.dart';
import 'package:card_battler/game/models/shared/value_image_label_model.dart';
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
        expect(label.debugMode, isTrue);
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

    group('text component creation', () {
      testWithFlameGame('creates text component on load', (game) async {
        final model = ValueImageLabelModel(value: 42, label: 'Answer');
        final label = ValueImageLabel(model);

        await game.ensureAdd(label);

        // Should have a text component child
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

      testWithFlameGame('handles negative values in display', (game) async {
        final model = ValueImageLabelModel(value: 10, label: 'Temperature');
        final label = ValueImageLabel(model);

        await game.ensureAdd(label);

        model.changeValue(-30);
        label.updateDisplay();

        final textComponent = label.children.whereType<TextComponent>().first;
        expect(textComponent.text, equals('Temperature: -20'));
      });

      testWithFlameGame('handles zero values in display', (game) async {
        final model = ValueImageLabelModel(value: 100, label: 'Lives');
        final label = ValueImageLabel(model);

        await game.ensureAdd(label);

        model.changeValue(-100);
        label.updateDisplay();

        final textComponent = label.children.whereType<TextComponent>().first;
        expect(textComponent.text, equals('Lives: 0'));
      });

      testWithFlameGame('handles large values in display', (game) async {
        final model = ValueImageLabelModel(value: 1000000, label: 'Gold');
        final label = ValueImageLabel(model);

        await game.ensureAdd(label);

        final textComponent = label.children.whereType<TextComponent>().first;
        expect(textComponent.text, equals('Gold: 1000000'));
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

      testWithFlameGame('can be used with different models', (game) async {
        final model1 = ValueImageLabelModel(value: 100, label: 'HP');
        final model2 = ValueImageLabelModel(value: 50, label: 'MP');
        
        final label1 = ValueImageLabel(model1);
        final label2 = ValueImageLabel(model2);

        await game.ensureAdd(label1);
        await game.ensureAdd(label2);

        final text1 = label1.children.whereType<TextComponent>().first;
        final text2 = label2.children.whereType<TextComponent>().first;

        expect(text1.text, equals('HP: 100'));
        expect(text2.text, equals('MP: 50'));

        // Modify one model
        model1.changeValue(-25);
        label1.updateDisplay();

        expect(text1.text, equals('HP: 75'));
        expect(text2.text, equals('MP: 50')); // Should remain unchanged
      });
    });

    group('component properties', () {
      testWithFlameGame('has debug mode enabled', (game) async {
        final model = ValueImageLabelModel(value: 15, label: 'Debug');
        final label = ValueImageLabel(model);

        expect(label.debugMode, isTrue);
      });

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