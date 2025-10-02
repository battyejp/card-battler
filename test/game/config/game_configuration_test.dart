import 'package:card_battler/game/config/game_configuration.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GameConfiguration', () {
    group('Constructor', () {
      test('creates instance with default values when no parameters provided', () {
        const config = GameConfiguration();

        expect(config.numberOfPlayers, equals(2));
        expect(config.numberOfEnemies, equals(4));
        expect(config.numberOfBases, equals(3));
        expect(config.defaultHealth, equals(10));
        expect(config.playerStartingCredits, equals(0));
        expect(config.playerStartingAttack, equals(0));
      });

      test('creates instance with custom values', () {
        const config = GameConfiguration(
          numberOfPlayers: 3,
          numberOfEnemies: 5,
          numberOfBases: 4,
          defaultHealth: 15,
          playerStartingCredits: 10,
          playerStartingAttack: 5,
        );

        expect(config.numberOfPlayers, equals(3));
        expect(config.numberOfEnemies, equals(5));
        expect(config.numberOfBases, equals(4));
        expect(config.defaultHealth, equals(15));
        expect(config.playerStartingCredits, equals(10));
        expect(config.playerStartingAttack, equals(5));
      });

      test('allows partial custom values with defaults for others', () {
        const config = GameConfiguration(
          defaultHealth: 20,
        );

        expect(config.numberOfPlayers, equals(5));
        expect(config.defaultHealth, equals(20));
        expect(config.numberOfEnemies, equals(4)); // default
        expect(config.numberOfBases, equals(3)); // default
        expect(config.playerStartingCredits, equals(0)); // default
        expect(config.playerStartingAttack, equals(0)); // default
      });
    });

    group('defaultConfig', () {
      test('provides default configuration constant', () {
        const config = GameConfiguration.defaultConfig;

        expect(config.numberOfPlayers, equals(2));
        expect(config.numberOfEnemies, equals(4));
        expect(config.numberOfBases, equals(3));
        expect(config.defaultHealth, equals(10));
        expect(config.playerStartingCredits, equals(0));
        expect(config.playerStartingAttack, equals(0));
      });

      test('is a const value', () {
        const config1 = GameConfiguration.defaultConfig;
        const config2 = GameConfiguration.defaultConfig;

        expect(identical(config1, config2), isTrue);
      });
    });
  });
}
