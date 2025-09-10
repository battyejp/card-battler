import 'package:flutter_test/flutter_test.dart';
import 'package:card_battler/game_legacy/models/team/player_stats_model.dart';
import 'package:card_battler/game_legacy/models/shared/health_model.dart';

void main() {
  group('PlayerStatsModel', () {
    group('constructor and initialization', () {
      test('creates with required parameters', () {
        final health = HealthModel(maxHealth: 100);
        final model = PlayerStatsModel(name: 'Player1', health: health, isActive: false);
        
        expect(model.name, equals('Player1'));
        expect(model.health, equals(health));
        expect(model.isActive, equals(false));
      });

      test('creates with optional isActive parameter', () {
        final health = HealthModel(maxHealth: 100);
        final model = PlayerStatsModel(name: 'Player1', health: health, isActive: true);
        
        expect(model.name, equals('Player1'));
        expect(model.health, equals(health));
        expect(model.isActive, equals(true));
      });

      test('defaults isActive to false', () {
        final health = HealthModel(maxHealth: 50);
        final model = PlayerStatsModel(name: 'TestPlayer', health: health, isActive: false);
        
        expect(model.isActive, equals(false));
      });
    });

    group('property access', () {
      test('name getter returns correct value', () {
        final health = HealthModel(maxHealth: 75);
        final model = PlayerStatsModel(name: 'PlayerName', health: health, isActive: false);
        
        expect(model.name, equals('PlayerName'));
      });

      test('health getter returns correct HealthModel instance', () {
        final health = HealthModel(maxHealth: 120);
        final model = PlayerStatsModel(name: 'Player', health: health, isActive: false);
        
        expect(model.health, equals(health));
        expect(model.health.maxHealth, equals(120));
        expect(model.health.currentHealth, equals(120));
      });

      test('isActive reflects constructor parameter', () {
        final health = HealthModel(maxHealth: 100);
        
        final inactiveModel = PlayerStatsModel(name: 'Player1', health: health, isActive: false);
        expect(inactiveModel.isActive, equals(false));
        
        final activeModel = PlayerStatsModel(name: 'Player2', health: health, isActive: true);
        expect(activeModel.isActive, equals(true));
      });
    });

    group('health interaction', () {
      test('health changes are reflected through health getter', () {
        final health = HealthModel(maxHealth: 100);
        final model = PlayerStatsModel(name: 'Player', health: health, isActive: false);

        expect(model.health.currentHealth, equals(100));
        
        model.health.changeHealth(-25);
        expect(model.health.currentHealth, equals(75));
        
        model.health.changeHealth(10);
        expect(model.health.currentHealth, equals(85));
      });

      test('health display is accessible through health getter', () {
        final health = HealthModel(maxHealth: 80);
        final model = PlayerStatsModel(name: 'Player', health: health, isActive: false);

        expect(model.health.healthDisplay, equals('80/80'));
        
        model.health.changeHealth(-30);
        expect(model.health.healthDisplay, equals('50/80'));
      });
    });

    group('edge cases', () {
      test('handles empty name string', () {
        final health = HealthModel(maxHealth: 100);
        final model = PlayerStatsModel(name: '', health: health, isActive: false);

        expect(model.name, equals(''));
      });

      test('handles very long name string', () {
        final health = HealthModel(maxHealth: 100);
        final longName = 'A' * 1000;
        final model = PlayerStatsModel(name: longName, health: health, isActive: false);

        expect(model.name, equals(longName));
        expect(model.name.length, equals(1000));
      });

      test('handles health with zero max health', () {
        final health = HealthModel(maxHealth: 0);
        final model = PlayerStatsModel(name: 'Player', health: health, isActive: false);

        expect(model.health.maxHealth, equals(0));
        expect(model.health.currentHealth, equals(0));
      });

      test('multiple instances have independent state', () {
        final health1 = HealthModel(maxHealth: 100);
        final health2 = HealthModel(maxHealth: 50);
        
        final model1 = PlayerStatsModel(name: 'Player1', health: health1, isActive: true);
        final model2 = PlayerStatsModel(name: 'Player2', health: health2, isActive: false);
        
        expect(model1.name, equals('Player1'));
        expect(model2.name, equals('Player2'));
        expect(model1.isActive, equals(true));
        expect(model2.isActive, equals(false));
        expect(model1.health.maxHealth, equals(100));
        expect(model2.health.maxHealth, equals(50));
        
        model1.health.changeHealth(-20);
        expect(model1.health.currentHealth, equals(80));
        expect(model2.health.currentHealth, equals(50));
      });
    });
  });
}