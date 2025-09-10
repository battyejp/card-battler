import 'package:flutter_test/flutter_test.dart';
import 'package:card_battler/game_legacy/models/shared/value_image_label_model.dart';
import 'package:card_battler/game_legacy/models/shared/reactive_model.dart';

void main() {
  group('ValueImageLabelModel', () {
    group('constructor and initialization', () {
      test('creates with required value and label parameters', () {
        final model = ValueImageLabelModel(value: 10, label: 'Health');
        expect(model.display, equals('Health: 10'));
      });

      test('creates with zero value', () {
        final model = ValueImageLabelModel(value: 0, label: 'Score');
        expect(model.display, equals('Score: 0'));
      });

      test('creates with negative value', () {
        final model = ValueImageLabelModel(value: -5, label: 'Delta');
        expect(model.display, equals('Delta: -5'));
      });

      test('creates with large positive value', () {
        final model = ValueImageLabelModel(value: 999, label: 'Points');
        expect(model.display, equals('Points: 999'));
      });

      test('creates with empty label', () {
        final model = ValueImageLabelModel(value: 42, label: '');
        expect(model.display, equals(': 42'));
      });

      test('creates with special characters in label', () {
        final model = ValueImageLabelModel(value: 10, label: 'HP/MP');
        expect(model.display, equals('HP/MP: 10'));
      });
    });

    group('display property', () {
      test('returns correct string representation with label and value', () {
        final model = ValueImageLabelModel(value: 42, label: 'Mana');
        expect(model.display, equals('Mana: 42'));
      });

      test('updates when value changes but label stays constant', () {
        final model = ValueImageLabelModel(value: 10, label: 'Health');
        expect(model.display, equals('Health: 10'));
        
        model.changeValue(5);
        expect(model.display, equals('Health: 15'));
      });

      test('handles negative display values with label', () {
        final model = ValueImageLabelModel(value: 5, label: 'Temperature');
        model.changeValue(-10);
        expect(model.display, equals('Temperature: -5'));
      });

      test('format is consistent across different labels', () {
        final models = [
          ValueImageLabelModel(value: 100, label: 'HP'),
          ValueImageLabelModel(value: 50, label: 'MP'),
          ValueImageLabelModel(value: 25, label: 'XP'),
        ];
        
        expect(models[0].display, equals('HP: 100'));
        expect(models[1].display, equals('MP: 50'));
        expect(models[2].display, equals('XP: 25'));
      });
    });

    group('changeValue method', () {
      test('increases value with positive delta', () {
        final model = ValueImageLabelModel(value: 10, label: 'Health');
        model.changeValue(5);
        expect(model.display, equals('Health: 15'));
        expect(model.value, equals(15));
      });

      test('decreases value with negative delta', () {
        final model = ValueImageLabelModel(value: 10, label: 'Mana');
        model.changeValue(-3);
        expect(model.display, equals('Mana: 7'));
        expect(model.value, equals(7));
      });

      test('handles zero delta without changing value', () {
        final model = ValueImageLabelModel(value: 10, label: 'Score');
        model.changeValue(0);
        expect(model.display, equals('Score: 10'));
      });

      test('allows multiple consecutive changes', () {
        final model = ValueImageLabelModel(value: 0, label: 'Points');
        model.changeValue(5);
        expect(model.display, equals('Points: 5'));
        
        model.changeValue(3);
        expect(model.display, equals('Points: 8'));
        
        model.changeValue(-2);
        expect(model.display, equals('Points: 6'));
      });

      test('handles large value changes', () {
        final model = ValueImageLabelModel(value: 100, label: 'Gold');
        model.changeValue(900);
        expect(model.display, equals('Gold: 1000'));
        
        model.changeValue(-2000);
        expect(model.display, equals('Gold: -1000'));
      });

      test('label remains unchanged during value changes', () {
        final model = ValueImageLabelModel(value: 50, label: 'Energy');
        final originalLabel = 'Energy';
        
        model.changeValue(25);
        expect(model.display, contains('$originalLabel:'));
        
        model.changeValue(-100);
        expect(model.display, contains('$originalLabel:'));
      });

      test('changeValue triggers notifyChange', () async {
        final model = ValueImageLabelModel(value: 10, label: 'Test');
        
        final changes = <ValueImageLabelModel>[];
        final subscription = model.changes.listen(changes.add);
        
        model.changeValue(5);
        await Future.delayed(Duration.zero);
        
        expect(changes.length, equals(1));
        expect(changes.first, equals(model));
        expect(changes.first.value, equals(15));
        
        await subscription.cancel();
        model.dispose();
      });

      test('multiple changeValue calls trigger multiple notifications', () async {
        final model = ValueImageLabelModel(value: 0, label: 'Counter');
        
        final changes = <ValueImageLabelModel>[];
        final subscription = model.changes.listen(changes.add);
        
        model.changeValue(1);
        model.changeValue(2);
        model.changeValue(3);
        await Future.delayed(Duration.zero);
        
        expect(changes.length, equals(3));
        // All changes reference the same model instance, so they all have the final value
        expect(changes.every((change) => change.value == 6), isTrue);
        expect(changes.every((change) => change == model), isTrue);
        
        await subscription.cancel();
        model.dispose();
      });
    });

    group('value getter', () {
      test('returns current value correctly', () {
        final model = ValueImageLabelModel(value: 42, label: 'Test');
        expect(model.value, equals(42));
      });

      test('value updates when changeValue is called', () {
        final model = ValueImageLabelModel(value: 0, label: 'Counter');
        
        model.changeValue(10);
        expect(model.value, equals(10));
        
        model.changeValue(-5);
        expect(model.value, equals(5));
        
        model.changeValue(20);
        expect(model.value, equals(25));
      });

      test('value and display stay synchronized', () {
        final model = ValueImageLabelModel(value: 100, label: 'Sync Test');
        
        expect(model.value, equals(100));
        expect(model.display, equals('Sync Test: 100'));
        
        model.changeValue(50);
        expect(model.value, equals(150));
        expect(model.display, equals('Sync Test: 150'));
        
        model.changeValue(-200);
        expect(model.value, equals(-50));
        expect(model.display, equals('Sync Test: -50'));
      });
    });

    group('ReactiveModel integration', () {
      test('implements ReactiveModel mixin', () {
        final model = ValueImageLabelModel(value: 10, label: 'Test');
        expect(model, isA<ReactiveModel<ValueImageLabelModel>>());
      });

      test('has changes stream available', () {
        final model = ValueImageLabelModel(value: 10, label: 'Test');
        expect(model.changes, isA<Stream<ValueImageLabelModel>>());
      });

      test('notifyChange method is available', () {
        final model = ValueImageLabelModel(value: 10, label: 'Test');
        expect(() => model.notifyChange(), returnsNormally);
      });

      test('changes stream emits model when notifyChange is called', () async {
        final model = ValueImageLabelModel(value: 10, label: 'Test');
        
        final changes = <ValueImageLabelModel>[];
        final subscription = model.changes.listen(changes.add);
        
        model.notifyChange();
        await Future.delayed(Duration.zero); // Allow stream to emit
        
        expect(changes.length, equals(1));
        expect(changes.first, equals(model));
        
        await subscription.cancel();
        model.dispose();
      });

      test('multiple notifyChange calls emit multiple events', () async {
        final model = ValueImageLabelModel(value: 10, label: 'Test');
        
        final changes = <ValueImageLabelModel>[];
        final subscription = model.changes.listen(changes.add);
        
        model.notifyChange();
        model.notifyChange();
        model.notifyChange();
        await Future.delayed(Duration.zero);
        
        expect(changes.length, equals(3));
        expect(changes.every((change) => change == model), isTrue);
        
        await subscription.cancel();
        model.dispose();
      });

      test('dispose method cleans up resources', () {
        final model = ValueImageLabelModel(value: 10, label: 'Test');
        
        // Access the stream to initialize the controller
        model.changes.listen((_) {});
        
        expect(() => model.dispose(), returnsNormally);
      });

      test('can be used after dispose without errors', () {
        final model = ValueImageLabelModel(value: 10, label: 'Health');
        model.dispose();
        
        expect(() => model.changeValue(5), returnsNormally);
        expect(model.display, equals('Health: 15'));
      });
    });

    group('multiple instances', () {
      test('different instances have independent values and labels', () {
        final model1 = ValueImageLabelModel(value: 10, label: 'HP');
        final model2 = ValueImageLabelModel(value: 20, label: 'MP');
        
        expect(model1.display, equals('HP: 10'));
        expect(model2.display, equals('MP: 20'));
        
        model1.changeValue(5);
        expect(model1.display, equals('HP: 15'));
        expect(model2.display, equals('MP: 20')); // Should remain unchanged
      });

      test('modifications to one instance do not affect another', () {
        final model1 = ValueImageLabelModel(value: 0, label: 'Score');
        final model2 = ValueImageLabelModel(value: 0, label: 'Lives');
        
        model1.changeValue(100);
        model2.changeValue(-50);
        
        expect(model1.display, equals('Score: 100'));
        expect(model2.display, equals('Lives: -50'));
      });

      test('multiple instances can be used independently', () {
        final labels = ['HP', 'MP', 'XP', 'Gold', 'Level'];
        final models = List.generate(5, (i) => ValueImageLabelModel(value: i * 10, label: labels[i]));
        
        for (int i = 0; i < models.length; i++) {
          expect(models[i].display, equals('${labels[i]}: ${i * 10}'));
          models[i].changeValue(i);
          expect(models[i].display, equals('${labels[i]}: ${i * 10 + i}'));
        }
      });

      test('instances with same label but different values work independently', () {
        final model1 = ValueImageLabelModel(value: 100, label: 'Health');
        final model2 = ValueImageLabelModel(value: 50, label: 'Health');
        
        expect(model1.display, equals('Health: 100'));
        expect(model2.display, equals('Health: 50'));
        
        model1.changeValue(-25);
        expect(model1.display, equals('Health: 75'));
        expect(model2.display, equals('Health: 50')); // Unchanged
      });
    });

    group('edge cases', () {
      test('handles maximum integer values', () {
        const maxInt = 9223372036854775807; // Max int64 value
        final model = ValueImageLabelModel(value: maxInt, label: 'Max');
        expect(model.display, equals('Max: $maxInt'));
      });

      test('handles minimum integer values', () {
        const minInt = -9223372036854775808; // Min int64 value  
        final model = ValueImageLabelModel(value: minInt, label: 'Min');
        expect(model.display, equals('Min: $minInt'));
      });

      test('value changes preserve type consistency', () {
        final model = ValueImageLabelModel(value: 10, label: 'Test');
        model.changeValue(5);
        
        // Verify that the display is still a string and contains the expected format
        expect(model.display, isA<String>());
        expect(model.display, contains('Test: '));
        final valueStr = model.display.split(': ')[1];
        expect(int.tryParse(valueStr), isNotNull);
      });

      test('handles very long labels', () {
        final longLabel = 'This is a very long label that might cause issues';
        final model = ValueImageLabelModel(value: 42, label: longLabel);
        expect(model.display, equals('$longLabel: 42'));
      });

      test('handles labels with colons', () {
        final model = ValueImageLabelModel(value: 10, label: 'Ratio 1:2');
        expect(model.display, equals('Ratio 1:2: 10'));
      });
    });
  });
}