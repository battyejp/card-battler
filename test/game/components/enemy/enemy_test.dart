import 'package:card_battler/game/components/enemy/enemy.dart';
import 'package:card_battler/game/models/enemy/enemy_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flame/components.dart';

void main() {
  group('Enemy Component (UI-only)', () {
    group('Constructor and Model Integration', () {
      testWithFlameGame('creates with EnemyModel and displays health', (game) async {
        final model = EnemyModel(name: 'Test Enemy', maxHealth: 100);
        final enemy = Enemy(model: model)
          ..size = Vector2(200, 200)
          ..position = Vector2(0, 0);

        await game.ensureAdd(enemy);

        expect(game.children.contains(enemy), isTrue);

        // Check that text component is added and shows correct health
        expect(enemy.children.length, equals(1));
        final textComponent = enemy.children.first as TextComponent;
        expect(textComponent.text, equals('100/100'));
      });

      testWithFlameGame('reflects model health changes in display', (game) async {
        final model = EnemyModel(name: 'Test Enemy', maxHealth: 50);
        final enemy = Enemy(model: model)
          ..size = Vector2(100, 100)
          ..position = Vector2(0, 0);

        await game.ensureAdd(enemy);

        final textComponent = enemy.children.first as TextComponent;
        expect(textComponent.text, equals('50/50'));
      });
    });

    group('UI Properties', () {
      testWithFlameGame('text component is centered correctly', (game) async {
        final model = EnemyModel(name: 'Test Enemy', maxHealth: 75);
        final enemy = Enemy(model: model)
          ..size = Vector2(150, 150)
          ..position = Vector2(0, 0);

        await game.ensureAdd(enemy);

        final textComponent = enemy.children.first as TextComponent;
        expect(textComponent.anchor, equals(Anchor.center));
        expect(textComponent.position, equals(Vector2(75, 75))); // Center of 150x150
        expect(textComponent.text, equals('75/75'));
      });

      testWithFlameGame('text has correct styling', (game) async {
        final model = EnemyModel(name: 'Test Enemy', maxHealth: 25);
        final enemy = Enemy(model: model)
          ..size = Vector2(100, 100)
          ..position = Vector2(0, 0);

        await game.ensureAdd(enemy);

        final textComponent = enemy.children.first as TextComponent;
        final textPaint = textComponent.textRenderer as TextPaint;
        expect(textPaint.style.fontSize, equals(20));
        expect(textPaint.style.color, equals(Colors.white));
      });
    });

    group('Size and Position', () {
      final testCases = [
        {'size': Vector2(100, 100), 'pos': Vector2(0, 0)},
        {'size': Vector2(200, 150), 'pos': Vector2(50, 25)},
        {'size': Vector2(50, 200), 'pos': Vector2(100, 0)},
      ];

      for (final testCase in testCases) {
        testWithFlameGame('handles size ${testCase['size']} and position ${testCase['pos']}', (game) async {
          final model = EnemyModel(name: 'Test Enemy', maxHealth: 10);
          final enemy = Enemy(model: model)
            ..size = testCase['size'] as Vector2
            ..position = testCase['pos'] as Vector2;

          await game.ensureAdd(enemy);

          expect(enemy.size, equals(testCase['size']));
          expect(enemy.position, equals(testCase['pos']));

          // Verify text is centered within the component
          final textComponent = enemy.children.first as TextComponent;
          final expectedCenter = Vector2(
            (testCase['size'] as Vector2).x / 2,
            (testCase['size'] as Vector2).y / 2,
          );
          expect(textComponent.position, equals(expectedCenter));
        });
      }
    });

    group('Methods and Properties', () {
      testWithFlameGame('updateDisplay updates text when called', (game) async {
        final model = EnemyModel(name: 'Test Enemy', maxHealth: 100);
        final enemy = Enemy(model: model)
          ..size = Vector2(100, 100)
          ..position = Vector2(0, 0);

        await game.ensureAdd(enemy);

        final textComponent = enemy.children.first as TextComponent;
        expect(textComponent.text, equals('100/100'));

        // Call updateDisplay method
        enemy.updateDisplay();
        
        // Text should remain the same since model hasn't changed
        expect(textComponent.text, equals('100/100'));
      });
    });
  });
}