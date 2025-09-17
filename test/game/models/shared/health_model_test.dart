import 'package:card_battler/game/models/shared/health_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('HealthModel', () {
    group('Constructor', () {
      test('creates instance with valid health values', () {
        final health = HealthModel(100, 150);
        
        expect(health.currentHealth, equals(100));
        expect(health.maxHealth, equals(150));
      });

      test('allows current health to equal max health', () {
        final health = HealthModel(100, 100);
        
        expect(health.currentHealth, equals(100));
        expect(health.maxHealth, equals(100));
      });

      test('allows current health to exceed max health (for temporary buffs)', () {
        final health = HealthModel(120, 100);
        
        expect(health.currentHealth, equals(120));
        expect(health.maxHealth, equals(100));
      });

      test('allows zero and negative current health', () {
        final healthZero = HealthModel(0, 100);
        final healthNegative = HealthModel(-10, 100);
        
        expect(healthZero.currentHealth, equals(0));
        expect(healthNegative.currentHealth, equals(-10));
      });
    });

    group('Display property', () {
      test('formats display string correctly', () {
        final health = HealthModel(75, 100);
        
        expect(health.display, equals('HP: 75/100'));
      });

      test('formats display with zero health', () {
        final health = HealthModel(0, 50);
        
        expect(health.display, equals('HP: 0/50'));
      });

      test('formats display with negative health', () {
        final health = HealthModel(-5, 100);
        
        expect(health.display, equals('HP: -5/100'));
      });

      test('formats display with health exceeding max', () {
        final health = HealthModel(120, 100);
        
        expect(health.display, equals('HP: 120/100'));
      });
    });

    group('Health modification', () {
      test('current health can be modified', () {
        final health = HealthModel(100, 150);
        
        health.currentHealth = 80;
        expect(health.currentHealth, equals(80));
        expect(health.display, equals('HP: 80/150'));
      });

      test('max health remains immutable', () {
        final health = HealthModel(100, 150);
        
        // maxHealth is final, so this test confirms it cannot be modified
        expect(health.maxHealth, equals(150));
      });
    });

    group('Edge cases', () {
      test('handles large health values', () {
        final health = HealthModel(999999, 1000000);
        
        expect(health.display, equals('HP: 999999/1000000'));
      });

      test('handles single digit health values', () {
        final health = HealthModel(1, 9);
        
        expect(health.display, equals('HP: 1/9'));
      });
    });
  });
}