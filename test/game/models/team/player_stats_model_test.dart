import 'package:flutter_test/flutter_test.dart';
import 'package:card_battler/game/models/team/player_stats_model.dart';
import 'package:card_battler/game/models/shared/health_model.dart';

void main() {
  group('PlayerStatsModel', () {
    late HealthModel testHealthModel;
    late String testPlayerName;

    setUp(() {
      testHealthModel = HealthModel(maxHealth: 100);
      testPlayerName = 'Test Player';
    });

    group('constructor and initialization', () {
      test('creates with required parameters', () {
        final playerStats = PlayerStatsModel(
          name: testPlayerName,
          health: testHealthModel,
        );

        expect(playerStats.name, equals('Test Player: 100/100'));
        expect(playerStats.health, equals(testHealthModel));
      });

      test('stores references to provided models', () {
        final playerStats = PlayerStatsModel(
          name: testPlayerName,
          health: testHealthModel,
        );

        // Verify that the same health model instance is returned
        expect(identical(playerStats.health, testHealthModel), isTrue);

        // Verify that changes to the original health model are reflected
        testHealthModel.changeHealth(-20);
        expect(playerStats.name, equals('Test Player: 80/100'));
      });

      test('works with different name values', () {
        final names = ['Alice', 'Bob_123', 'Player-X', '', '日本語', 'A Very Long Player Name'];

        for (final name in names) {
          final health = HealthModel(maxHealth: 50);
          final playerStats = PlayerStatsModel(name: name, health: health);
          expect(playerStats.name, equals('$name: 50/50'));
        }
      });

      test('works with different health model configurations', () {
        final lowHealth = HealthModel(maxHealth: 1);
        final highHealth = HealthModel(maxHealth: 999);
        final mediumHealth = HealthModel(maxHealth: 50);

        final lowHealthPlayer = PlayerStatsModel(name: 'Fragile', health: lowHealth);
        final highHealthPlayer = PlayerStatsModel(name: 'Tank', health: highHealth);
        final mediumHealthPlayer = PlayerStatsModel(name: 'Balanced', health: mediumHealth);

        expect(lowHealthPlayer.name, equals('Fragile: 1/1'));
        expect(highHealthPlayer.name, equals('Tank: 999/999'));
        expect(mediumHealthPlayer.name, equals('Balanced: 50/50'));
      });
    });

    group('display property', () {
      test('returns correct format with full health', () {
        final playerStats = PlayerStatsModel(
          name: 'Hero',
          health: HealthModel(maxHealth: 75),
        );

        expect(playerStats.name, equals('Hero: 75/75'));
      });

      test('reflects health changes correctly', () {
        final health = HealthModel(maxHealth: 100);
        final playerStats = PlayerStatsModel(
          name: 'Warrior',
          health: health,
        );

        // Initial state
        expect(playerStats.name, equals('Warrior: 100/100'));

        // After taking damage
        health.changeHealth(-25);
        expect(playerStats.name, equals('Warrior: 75/100'));

        // After healing
        health.changeHealth(10);
        expect(playerStats.name, equals('Warrior: 85/100'));

        // After more damage
        health.changeHealth(-85);
        expect(playerStats.name, equals('Warrior: 0/100'));

        // After healing beyond max
        health.changeHealth(150);
        expect(playerStats.name, equals('Warrior: 100/100'));
      });

      test('handles zero and maximum health correctly', () {
        final health = HealthModel(maxHealth: 50);
        final playerStats = PlayerStatsModel(
          name: 'TestPlayer',
          health: health,
        );

        // At maximum health
        expect(playerStats.name, equals('TestPlayer: 50/50'));

        // At zero health
        health.changeHealth(-50);
        expect(playerStats.name, equals('TestPlayer: 0/50'));

        // Back to full health
        health.changeHealth(50);
        expect(playerStats.name, equals('TestPlayer: 50/50'));
      });

      test('updates with multiple health changes', () {
        final health = HealthModel(maxHealth: 200);
        final playerStats = PlayerStatsModel(
          name: 'Survivor',
          health: health,
        );

        final healthChanges = [-50, -30, 20, -100, 80, -20];
        final expectedDisplays = [
          'Survivor: 150/200',  // -50
          'Survivor: 120/200',  // -30
          'Survivor: 140/200',  // +20
          'Survivor: 40/200',   // -100
          'Survivor: 120/200',  // +80
          'Survivor: 100/200',  // -20
        ];

        for (int i = 0; i < healthChanges.length; i++) {
          health.changeHealth(healthChanges[i]);
          expect(playerStats.name, equals(expectedDisplays[i]));
        }
      });
    });

    group('health property getter', () {
      test('returns correct HealthModel instance', () {
        final health = HealthModel(maxHealth: 80);
        final playerStats = PlayerStatsModel(
          name: 'Guardian',
          health: health,
        );

        expect(playerStats.health, isA<HealthModel>());
        expect(playerStats.health, equals(health));
        expect(playerStats.health.maxHealth, equals(80));
        expect(playerStats.health.currentHealth, equals(80));
      });

      test('provides access to health model methods', () {
        final health = HealthModel(maxHealth: 60);
        final playerStats = PlayerStatsModel(
          name: 'Mage',
          health: health,
        );

        // Can access health properties through getter
        expect(playerStats.health.maxHealth, equals(60));
        expect(playerStats.health.currentHealth, equals(60));
        expect(playerStats.health.healthDisplay, equals('60/60'));

        // Can modify health through getter
        playerStats.health.changeHealth(-15);
        expect(playerStats.health.currentHealth, equals(45));
        expect(playerStats.health.healthDisplay, equals('45/60'));
        expect(playerStats.name, equals('Mage: 45/60'));
      });

      test('maintains reference consistency', () {
        final health = HealthModel(maxHealth: 30);
        final playerStats = PlayerStatsModel(
          name: 'Scout',
          health: health,
        );

        // Getting health multiple times should return the same instance
        final health1 = playerStats.health;
        final health2 = playerStats.health;
        
        expect(identical(health1, health2), isTrue);
        expect(identical(health1, health), isTrue);
      });
    });

    group('edge cases and boundary conditions', () {
      test('handles empty player name', () {
        final health = HealthModel(maxHealth: 25);
        final playerStats = PlayerStatsModel(
          name: '',
          health: health,
        );

        expect(playerStats.name, equals(': 25/25'));
      });

      test('handles minimum health values', () {
        final health = HealthModel(maxHealth: 1);
        final playerStats = PlayerStatsModel(
          name: 'Minimal',
          health: health,
        );

        expect(playerStats.name, equals('Minimal: 1/1'));

        // Test taking damage to zero
        health.changeHealth(-1);
        expect(playerStats.name, equals('Minimal: 0/1'));
      });

      test('handles large health values', () {
        final health = HealthModel(maxHealth: 999999);
        final playerStats = PlayerStatsModel(
          name: 'Immortal',
          health: health,
        );

        expect(playerStats.name, equals('Immortal: 999999/999999'));

        // Test large damage
        health.changeHealth(-500000);
        expect(playerStats.name, equals('Immortal: 499999/999999'));
      });

      test('handles special characters in name', () {
        final specialNames = [
          'Player@123',
          'User_Name',
          'Player-X',
          'Plāyér Ñamę',
          '玩家',
          'P!@#\$%^&*()',
          'Multi Word Player Name',
        ];

        for (final name in specialNames) {
          final health = HealthModel(maxHealth: 10);
          final playerStats = PlayerStatsModel(name: name, health: health);
          expect(playerStats.name, equals('$name: 10/10'));
        }
      });

      test('maintains state consistency across operations', () {
        final health = HealthModel(maxHealth: 100);
        final playerStats = PlayerStatsModel(
          name: 'Consistent',
          health: health,
        );

        // Perform various operations
        expect(playerStats.name, equals('Consistent: 100/100'));

        health.changeHealth(-50);
        expect(playerStats.name, equals('Consistent: 50/100'));
        expect(playerStats.health.currentHealth, equals(50));

        health.changeHealth(25);
        expect(playerStats.name, equals('Consistent: 75/100'));
        expect(playerStats.health.currentHealth, equals(75));

        // Verify multiple accesses remain consistent
        final display1 = playerStats.name;
        final display2 = playerStats.name;
        final health1 = playerStats.health;
        final health2 = playerStats.health;

        expect(display1, equals(display2));
        expect(identical(health1, health2), isTrue);
      });
    });

    group('integration with health model', () {
      test('properly delegates to health model methods', () {
        final health = HealthModel(maxHealth: 120);
        final playerStats = PlayerStatsModel(
          name: 'Integrated',
          health: health,
        );

        // Test various health model operations through player stats
        expect(playerStats.health.maxHealth, equals(120));
        expect(playerStats.health.currentHealth, equals(120));

        // Test damage
        playerStats.health.changeHealth(-30);
        expect(playerStats.name, equals('Integrated: 90/120'));

        // Test healing
        playerStats.health.changeHealth(15);
        expect(playerStats.name, equals('Integrated: 105/120'));

        // Test over-healing (should cap at max)
        playerStats.health.changeHealth(50);
        expect(playerStats.name, equals('Integrated: 120/120'));

        // Test over-damage (should cap at 0)
        playerStats.health.changeHealth(-200);
        expect(playerStats.name, equals('Integrated: 0/120'));
      });

      test('reflects health model state changes immediately', () {
        final health = HealthModel(maxHealth: 80);
        final playerStats = PlayerStatsModel(
          name: 'Reactive',
          health: health,
        );

        // Changes to health model should immediately affect display
        expect(playerStats.name, equals('Reactive: 80/80'));

        health.changeHealth(-20);
        expect(playerStats.name, equals('Reactive: 60/80'));

        health.changeHealth(-60);
        expect(playerStats.name, equals('Reactive: 0/80'));

        health.changeHealth(40);
        expect(playerStats.name, equals('Reactive: 40/80'));
      });

      test('supports different health model instances', () {
        final health1 = HealthModel(maxHealth: 50);
        final health2 = HealthModel(maxHealth: 75);
        final health3 = HealthModel(maxHealth: 100);

        final player1 = PlayerStatsModel(name: 'Player1', health: health1);
        final player2 = PlayerStatsModel(name: 'Player2', health: health2);
        final player3 = PlayerStatsModel(name: 'Player3', health: health3);

        expect(player1.name, equals('Player1: 50/50'));
        expect(player2.name, equals('Player2: 75/75'));
        expect(player3.name, equals('Player3: 100/100'));

        // Modify each independently
        health1.changeHealth(-10);
        health2.changeHealth(-25);
        health3.changeHealth(-50);

        expect(player1.name, equals('Player1: 40/50'));
        expect(player2.name, equals('Player2: 50/75'));
        expect(player3.name, equals('Player3: 50/100'));

        // Verify they remain independent
        expect(player1.health, isNot(equals(player2.health)));
        expect(player2.health, isNot(equals(player3.health)));
        expect(player1.health, isNot(equals(player3.health)));
      });
    });

    group('isActive property', () {
      test('defaults to false when not specified', () {
        final health = HealthModel(maxHealth: 100);
        final playerStats = PlayerStatsModel(
          name: 'Default Player',
          health: health,
        );

        expect(playerStats.isActive, isFalse);
      });

      test('can be set to true during construction', () {
        final health = HealthModel(maxHealth: 100);
        final playerStats = PlayerStatsModel(
          name: 'Active Player',
          health: health,
          isActive: true,
        );

        expect(playerStats.isActive, isTrue);
      });

      test('can be set to false explicitly during construction', () {
        final health = HealthModel(maxHealth: 100);
        final playerStats = PlayerStatsModel(
          name: 'Inactive Player',
          health: health,
          isActive: false,
        );

        expect(playerStats.isActive, isFalse);
      });

      test('isActive property does not affect display or health functionality', () {
        final health = HealthModel(maxHealth: 50);
        
        final activePlayer = PlayerStatsModel(
          name: 'Active',
          health: health,
          isActive: true,
        );
        
        final inactivePlayer = PlayerStatsModel(
          name: 'Inactive',
          health: HealthModel(maxHealth: 50),
          isActive: false,
        );

        // Both should display the same format regardless of isActive
        expect(activePlayer.name, equals('Active: 50/50'));
        expect(inactivePlayer.name, equals('Inactive: 50/50'));
        
        // Health functionality should work the same
        activePlayer.health.changeHealth(-10);
        inactivePlayer.health.changeHealth(-10);
        
        expect(activePlayer.name, equals('Active: 40/50'));
        expect(inactivePlayer.name, equals('Inactive: 40/50'));
      });

      test('supports multiple players with different isActive states', () {
        final players = [
          PlayerStatsModel(
            name: 'Player1',
            health: HealthModel(maxHealth: 100),
            isActive: true,
          ),
          PlayerStatsModel(
            name: 'Player2',
            health: HealthModel(maxHealth: 80),
            isActive: false,
          ),
          PlayerStatsModel(
            name: 'Player3',
            health: HealthModel(maxHealth: 120),
            isActive: true,
          ),
        ];

        expect(players[0].isActive, isTrue);
        expect(players[1].isActive, isFalse);
        expect(players[2].isActive, isTrue);
        
        // Verify names and health are independent of active state
        expect(players[0].name, equals('Player1'));
        expect(players[1].name, equals('Player2'));
        expect(players[2].name, equals('Player3'));
      });

      test('isActive state is immutable after construction', () {
        final health = HealthModel(maxHealth: 100);
        final playerStats = PlayerStatsModel(
          name: 'Immutable Player',
          health: health,
          isActive: true,
        );

        // isActive should remain true - no setter should exist
        expect(playerStats.isActive, isTrue);
        
        // Verify it's a final field by checking there's no setter (this would be compile-time)
        // We can only verify the current value remains consistent
        expect(playerStats.isActive, isTrue);
      });
    });

    group('name property', () {
      test('name getter returns correct value', () {
        final health = HealthModel(maxHealth: 100);
        final playerStats = PlayerStatsModel(
          name: 'Test Name',
          health: health,
        );

        expect(playerStats.name, equals('Test Name'));
      });

      test('name property is immutable after construction', () {
        final health = HealthModel(maxHealth: 100);
        final playerStats = PlayerStatsModel(
          name: 'Original Name',
          health: health,
        );

        // Name should remain consistent - no setter should exist
        expect(playerStats.name, equals('Original Name'));
        
        // Verify it remains the same on multiple accesses
        final name1 = playerStats.name;
        final name2 = playerStats.name;
        expect(name1, equals(name2));
        expect(name1, equals('Original Name'));
      });

      test('name is used correctly in display property', () {
        final health = HealthModel(maxHealth: 75);
        final playerStats = PlayerStatsModel(
          name: 'Display Test',
          health: health,
        );

        expect(playerStats.name, contains('Display Test'));
        expect(playerStats.name, equals('Display Test: 75/75'));
      });
    });
  });
}
