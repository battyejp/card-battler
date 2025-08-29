import 'package:flutter_test/flutter_test.dart';
import 'package:card_battler/game/models/player/info_model.dart';
import 'package:card_battler/game/models/shared/value_image_label_model.dart';

void main() {
  group('InfoModel', () {
    group('constructor and initialization', () {
      test('creates with required parameters', () {
        final health = ValueImageLabelModel(value: 100, label: 'Health');
        final attack = ValueImageLabelModel(value: 25, label: 'Attack');
        final credits = ValueImageLabelModel(value: 50, label: 'Credits');
        
        final infoModel = InfoModel(
          health: health,
          attack: attack,
          credits: credits,
          name: 'TestPlayer',
        );

        expect(infoModel.health, equals(health));
        expect(infoModel.attack, equals(attack));
        expect(infoModel.credits, equals(credits));
      });

      test('creates with different value combinations', () {
        final infoModel = InfoModel(
          health: ValueImageLabelModel(value: 0, label: 'HP'),
          attack: ValueImageLabelModel(value: 999, label: 'ATK'),
          credits: ValueImageLabelModel(value: -10, label: 'Gold'),
          name: 'TestPlayer',
        );

        expect(infoModel.health.display, equals('HP: 0'));
        expect(infoModel.attack.display, equals('ATK: 999'));
        expect(infoModel.credits.display, equals('Gold: -10'));
      });

      test('stores references to original models', () {
        final health = ValueImageLabelModel(value: 50, label: 'Health');
        final attack = ValueImageLabelModel(value: 10, label: 'Attack');
        final credits = ValueImageLabelModel(value: 75, label: 'Credits');
        
        final infoModel = InfoModel(
          health: health,
          attack: attack,
          credits: credits,
          name: 'TestPlayer',
        );

        // Modify original models
        health.changeValue(25);
        attack.changeValue(5);
        credits.changeValue(-25);

        // InfoModel should reflect changes since it holds references
        expect(infoModel.health.display, equals('Health: 75'));
        expect(infoModel.attack.display, equals('Attack: 15'));
        expect(infoModel.credits.display, equals('Credits: 50'));
      });
    });

    group('property access', () {
      test('health property returns correct ValueImageLabelModel', () {
        final health = ValueImageLabelModel(value: 100, label: 'Health');
        final infoModel = InfoModel(
          health: health,
          attack: ValueImageLabelModel(value: 0, label: 'Attack'),
          credits: ValueImageLabelModel(value: 0, label: 'Credits'),
          name: 'TestPlayer',
        );

        expect(infoModel.health, isA<ValueImageLabelModel>());
        expect(infoModel.health, equals(health));
        expect(infoModel.health.display, equals('Health: 100'));
      });

      test('attack property returns correct ValueImageLabelModel', () {
        final attack = ValueImageLabelModel(value: 25, label: 'Attack Power');
        final infoModel = InfoModel(
          health: ValueImageLabelModel(value: 0, label: 'Health'),
          attack: attack,
          credits: ValueImageLabelModel(value: 0, label: 'Credits'),
          name: 'TestPlayer',
        );

        expect(infoModel.attack, isA<ValueImageLabelModel>());
        expect(infoModel.attack, equals(attack));
        expect(infoModel.attack.display, equals('Attack Power: 25'));
      });

      test('credits property returns correct ValueImageLabelModel', () {
        final credits = ValueImageLabelModel(value: 150, label: 'Gold Coins');
        final infoModel = InfoModel(
          health: ValueImageLabelModel(value: 0, label: 'Health'),
          attack: ValueImageLabelModel(value: 0, label: 'Attack'),
          credits: credits,
          name: 'TestPlayer',
        );

        expect(infoModel.credits, isA<ValueImageLabelModel>());
        expect(infoModel.credits, equals(credits));
        expect(infoModel.credits.display, equals('Gold Coins: 150'));
      });
    });

    group('model interactions', () {
      test('models can be modified independently', () {
        final infoModel = InfoModel(
          health: ValueImageLabelModel(value: 100, label: 'HP'),
          attack: ValueImageLabelModel(value: 20, label: 'ATK'),
          credits: ValueImageLabelModel(value: 50, label: 'Gold'),
          name: 'TestPlayer',
        );

        // Modify each model independently
        infoModel.health.changeValue(-30);
        infoModel.attack.changeValue(10);
        infoModel.credits.changeValue(25);

        expect(infoModel.health.display, equals('HP: 70'));
        expect(infoModel.attack.display, equals('ATK: 30'));
        expect(infoModel.credits.display, equals('Gold: 75'));
      });

      test('reactive capabilities are preserved', () async {
        final infoModel = InfoModel(
          health: ValueImageLabelModel(value: 100, label: 'Health'),
          attack: ValueImageLabelModel(value: 20, label: 'Attack'),
          credits: ValueImageLabelModel(value: 50, label: 'Credits'),
          name: 'TestPlayer',
        );

        // Test reactive streams are available
        expect(infoModel.health.changes, isA<Stream<ValueImageLabelModel>>());
        expect(infoModel.attack.changes, isA<Stream<ValueImageLabelModel>>());
        expect(infoModel.credits.changes, isA<Stream<ValueImageLabelModel>>());

        // Test notifications work
        final healthChanges = <ValueImageLabelModel>[];
        final subscription = infoModel.health.changes.listen(healthChanges.add);

        infoModel.health.notifyChange();
        await Future.delayed(Duration.zero);

        expect(healthChanges.length, equals(1));
        expect(healthChanges.first, equals(infoModel.health));

        await subscription.cancel();
        infoModel.health.dispose();
      });

      test('models maintain their individual state', () {
        final infoModel1 = InfoModel(
          health: ValueImageLabelModel(value: 100, label: 'Health'),
          attack: ValueImageLabelModel(value: 20, label: 'Attack'),
          credits: ValueImageLabelModel(value: 50, label: 'Credits'),
          name: 'TestPlayer1',
        );

        final infoModel2 = InfoModel(
          health: ValueImageLabelModel(value: 80, label: 'Health'),
          attack: ValueImageLabelModel(value: 15, label: 'Attack'),
          credits: ValueImageLabelModel(value: 30, label: 'Credits'),
          name: 'TestPlayer2',
        );

        // Modify first model
        infoModel1.health.changeValue(-20);
        infoModel1.attack.changeValue(5);

        // Second model should remain unchanged
        expect(infoModel1.health.display, equals('Health: 80'));
        expect(infoModel1.attack.display, equals('Attack: 25'));
        expect(infoModel2.health.display, equals('Health: 80'));
        expect(infoModel2.attack.display, equals('Attack: 15'));
      });
    });

    group('edge cases', () {
      test('handles extreme values', () {
        final infoModel = InfoModel(
          health: ValueImageLabelModel(value: -999999, label: 'Health'),
          attack: ValueImageLabelModel(value: 0, label: 'Attack'),
          credits: ValueImageLabelModel(value: 999999999, label: 'Credits'),
          name: 'TestPlayer',
        );

        expect(infoModel.health.display, equals('Health: -999999'));
        expect(infoModel.attack.display, equals('Attack: 0'));
        expect(infoModel.credits.display, equals('Credits: 999999999'));
      });

      test('handles empty and special character labels', () {
        final infoModel = InfoModel(
          health: ValueImageLabelModel(value: 100, label: ''),
          attack: ValueImageLabelModel(value: 25, label: 'ATK/DEF'),
          credits: ValueImageLabelModel(value: 50, label: '💰'),
          name: 'TestPlayer',
        );

        expect(infoModel.health.display, equals(': 100'));
        expect(infoModel.attack.display, equals('ATK/DEF: 25'));
        expect(infoModel.credits.display, equals('💰: 50'));
      });

      test('models can be reused in different InfoModel instances', () {
        final sharedHealth = ValueImageLabelModel(value: 100, label: 'Shared Health');
        
        final infoModel1 = InfoModel(
          health: sharedHealth,
          attack: ValueImageLabelModel(value: 20, label: 'Attack1'),
          credits: ValueImageLabelModel(value: 50, label: 'Credits1'),
          name: 'TestPlayer1',
        );

        final infoModel2 = InfoModel(
          health: sharedHealth,
          attack: ValueImageLabelModel(value: 30, label: 'Attack2'),
          credits: ValueImageLabelModel(value: 75, label: 'Credits2'),
          name: 'TestPlayer2',
        );

        // Modifying shared health affects both
        sharedHealth.changeValue(-25);
        
        expect(infoModel1.health.display, equals('Shared Health: 75'));
        expect(infoModel2.health.display, equals('Shared Health: 75'));
        
        // But other properties remain independent
        expect(infoModel1.attack.display, equals('Attack1: 20'));
        expect(infoModel2.attack.display, equals('Attack2: 30'));
      });
    });
  });
}