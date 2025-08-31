import 'package:card_battler/game/models/shared/health_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:card_battler/game/models/player/info_model.dart';
import 'package:card_battler/game/models/shared/value_image_label_model.dart';

void main() {
  group('InfoModel', () {
    group('constructor and initialization', () {
      test('creates with required parameters', () {
        final attack = ValueImageLabelModel(value: 25, label: 'Attack');
        final credits = ValueImageLabelModel(value: 50, label: 'Credits');
        final healthModel = HealthModel(maxHealth: 100);

        final infoModel = InfoModel(
          attack: attack,
          credits: credits,
          name: 'TestPlayer',
          healthModel: healthModel,
        );

        expect(infoModel.healthModel, equals(healthModel));
        expect(infoModel.attack, equals(attack));
        expect(infoModel.credits, equals(credits));
      });

      test('creates with different value combinations', () {
        final infoModel = InfoModel(
          attack: ValueImageLabelModel(value: 999, label: 'ATK'),
          credits: ValueImageLabelModel(value: -10, label: 'Gold'),
          name: 'TestPlayer',
          healthModel: HealthModel(maxHealth: 100),
        );

        expect(infoModel.attack.display, equals('ATK: 999'));
        expect(infoModel.credits.display, equals('Gold: -10'));
      });

      test('stores references to original models', () {
        final attack = ValueImageLabelModel(value: 10, label: 'Attack');
        final credits = ValueImageLabelModel(value: 75, label: 'Credits');
        
        final infoModel = InfoModel(
          attack: attack,
          credits: credits,
          name: 'TestPlayer',
          healthModel: HealthModel(maxHealth: 100),
        );

        // Modify original models
        infoModel.healthModel.changeHealth(-25);
        attack.changeValue(5);
        credits.changeValue(-25);

        // InfoModel should reflect changes since it holds references
        expect(infoModel.healthModel.healthDisplay, equals('75/100'));
        expect(infoModel.attack.display, equals('Attack: 15'));
        expect(infoModel.credits.display, equals('Credits: 50'));
      });
    });

    group('property access', () {
      test('healthModel property returns correct HealthModel', () {
        final healthModel = HealthModel(maxHealth: 100);
        final infoModel = InfoModel(
          attack: ValueImageLabelModel(value: 0, label: 'Attack'),
          credits: ValueImageLabelModel(value: 0, label: 'Credits'),
          name: 'TestPlayer',
          healthModel: healthModel,
        );

        expect(infoModel.healthModel, isA<HealthModel>());
        expect(infoModel.healthModel, equals(healthModel));
        expect(infoModel.healthModel.healthDisplay, equals('100/100'));
      });

      test('attack property returns correct ValueImageLabelModel', () {
        final attack = ValueImageLabelModel(value: 25, label: 'Attack Power');
        final infoModel = InfoModel(
          attack: attack,
          credits: ValueImageLabelModel(value: 0, label: 'Credits'),
          name: 'TestPlayer',
          healthModel: HealthModel(maxHealth: 100),
        );

        expect(infoModel.attack, isA<ValueImageLabelModel>());
        expect(infoModel.attack, equals(attack));
        expect(infoModel.attack.display, equals('Attack Power: 25'));
      });

      test('credits property returns correct ValueImageLabelModel', () {
        final credits = ValueImageLabelModel(value: 150, label: 'Gold Coins');
        final infoModel = InfoModel(
          attack: ValueImageLabelModel(value: 0, label: 'Attack'),
          credits: credits,
          name: 'TestPlayer',
          healthModel: HealthModel(maxHealth: 100),
        );

        expect(infoModel.credits, isA<ValueImageLabelModel>());
        expect(infoModel.credits, equals(credits));
        expect(infoModel.credits.display, equals('Gold Coins: 150'));
      });
    });

    group('model interactions', () {
      test('models can be modified independently', () {
        final infoModel = InfoModel(
          attack: ValueImageLabelModel(value: 20, label: 'ATK'),
          credits: ValueImageLabelModel(value: 50, label: 'Gold'),
          name: 'TestPlayer',
          healthModel: HealthModel(maxHealth: 100),
        );

        // Modify each model independently
        infoModel.healthModel.changeHealth(-30);
        infoModel.attack.changeValue(10);
        infoModel.credits.changeValue(25);

        expect(infoModel.healthModel.healthDisplay, equals('70/100'));
        expect(infoModel.attack.display, equals('ATK: 30'));
        expect(infoModel.credits.display, equals('Gold: 75'));
      });

      test('reactive capabilities are preserved', () async {
        final infoModel = InfoModel(
          attack: ValueImageLabelModel(value: 20, label: 'Attack'),
          credits: ValueImageLabelModel(value: 50, label: 'Credits'),
          name: 'TestPlayer',
          healthModel: HealthModel(maxHealth: 100),
        );

        // Test reactive streams are available
        expect(infoModel.attack.changes, isA<Stream<ValueImageLabelModel>>());
        expect(infoModel.credits.changes, isA<Stream<ValueImageLabelModel>>());
        expect(infoModel.healthModel.changes, isA<Stream<HealthModel>>());

        // Test notifications work
        final attackChanges = <ValueImageLabelModel>[];
        final subscription = infoModel.attack.changes.listen(attackChanges.add);

        infoModel.attack.notifyChange();
        await Future.delayed(Duration.zero);

        expect(attackChanges.length, equals(1));
        expect(attackChanges.first, equals(infoModel.attack));

        await subscription.cancel();
        infoModel.attack.dispose();
      });

      test('models maintain their individual state', () {
        final infoModel1 = InfoModel(
          attack: ValueImageLabelModel(value: 20, label: 'Attack'),
          credits: ValueImageLabelModel(value: 50, label: 'Credits'),
          name: 'TestPlayer1',
          healthModel: HealthModel(maxHealth: 100),
        );

        final infoModel2 = InfoModel(
          attack: ValueImageLabelModel(value: 15, label: 'Attack'),
          credits: ValueImageLabelModel(value: 30, label: 'Credits'),
          name: 'TestPlayer2',
          healthModel: HealthModel(maxHealth: 80),
        );

        // Modify first model
        infoModel1.healthModel.changeHealth(-20);
        infoModel1.attack.changeValue(5);

        // Second model should remain unchanged
        expect(infoModel1.healthModel.healthDisplay, equals('80/100'));
        expect(infoModel1.attack.display, equals('Attack: 25'));
        expect(infoModel2.healthModel.healthDisplay, equals('80/80'));
        expect(infoModel2.attack.display, equals('Attack: 15'));
      });
    });

    group('edge cases', () {
      test('handles extreme values', () {
        final infoModel = InfoModel(
          attack: ValueImageLabelModel(value: 0, label: 'Attack'),
          credits: ValueImageLabelModel(value: 999999999, label: 'Credits'),
          name: 'TestPlayer',
          healthModel: HealthModel(maxHealth: 100),
        );

        expect(infoModel.attack.display, equals('Attack: 0'));
        expect(infoModel.credits.display, equals('Credits: 999999999'));
        expect(infoModel.healthModel.healthDisplay, equals('100/100'));
      });

      test('handles empty and special character labels', () {
        final infoModel = InfoModel(
          attack: ValueImageLabelModel(value: 25, label: 'ATK/DEF'),
          credits: ValueImageLabelModel(value: 50, label: '💰'),
          name: 'TestPlayer',
          healthModel: HealthModel(maxHealth: 100),
        );

        expect(infoModel.attack.display, equals('ATK/DEF: 25'));
        expect(infoModel.credits.display, equals('💰: 50'));
        expect(infoModel.healthModel.healthDisplay, equals('100/100'));
      });

      test('models can be reused in different InfoModel instances', () {
        final sharedAttack = ValueImageLabelModel(value: 100, label: 'Shared Attack');
        
        final infoModel1 = InfoModel(
          attack: sharedAttack,
          credits: ValueImageLabelModel(value: 50, label: 'Credits1'),
          name: 'TestPlayer1',
          healthModel: HealthModel(maxHealth: 100),
        );

        final infoModel2 = InfoModel(
          attack: sharedAttack,
          credits: ValueImageLabelModel(value: 75, label: 'Credits2'),
          name: 'TestPlayer2',
          healthModel: HealthModel(maxHealth: 100),
        );

        // Modifying shared attack affects both
        sharedAttack.changeValue(-25);
        
        expect(infoModel1.attack.display, equals('Shared Attack: 75'));
        expect(infoModel2.attack.display, equals('Shared Attack: 75'));
        
        // But other properties remain independent
        expect(infoModel1.credits.display, equals('Credits1: 50'));
        expect(infoModel2.credits.display, equals('Credits2: 75'));
      });
    });
  });
}