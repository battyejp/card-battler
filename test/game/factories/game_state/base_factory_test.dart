import 'package:card_battler/game/config/game_configuration.dart';
import 'package:card_battler/game/factories/game_state/base_factory.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BaseFactory', () {
    late GameConfiguration testConfig;

    setUp(() {
      testConfig = const GameConfiguration(
        numberOfBases: 4,
        defaultHealth: 20,
      );
    });

    group('createBases', () {
      test('creates the specified number of bases', () {
        final bases = BaseFactory.createBases(
          count: 4,
          config: testConfig,
        );

        expect(bases.length, equals(4));
      });

      test('creates bases with correct names', () {
        final bases = BaseFactory.createBases(
          count: 3,
          config: testConfig,
        );

        expect(bases[0].name, equals('Base 1'));
        expect(bases[1].name, equals('Base 2'));
        expect(bases[2].name, equals('Base 3'));
      });

      test('creates bases with correct health values', () {
        final bases = BaseFactory.createBases(
          count: 2,
          config: testConfig,
        );

        for (final base in bases) {
          expect(base.healthModel.currentHealth, equals(testConfig.defaultHealth));
          expect(base.healthModel.maxHealth, equals(testConfig.defaultHealth));
        }
      });

      test('creates empty list when count is 0', () {
        final bases = BaseFactory.createBases(
          count: 0,
          config: testConfig,
        );

        expect(bases, isEmpty);
      });
    });

    group('createBase', () {
      test('creates base with correct index-based name', () {
        final base = BaseFactory.createBase(
          index: 5,
          config: testConfig,
        );

        expect(base.name, equals('Base 6'));
      });

      test('creates base with correct health', () {
        final base = BaseFactory.createBase(
          index: 0,
          config: testConfig,
        );

        expect(base.healthModel.currentHealth, equals(testConfig.defaultHealth));
        expect(base.healthModel.maxHealth, equals(testConfig.defaultHealth));
      });

      test('creates base with health from custom config', () {
        final customConfig = const GameConfiguration(defaultHealth: 50);
        final base = BaseFactory.createBase(
          index: 0,
          config: customConfig,
        );

        expect(base.healthModel.currentHealth, equals(50));
        expect(base.healthModel.maxHealth, equals(50));
      });
    });
  });
}
