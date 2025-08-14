import 'package:card_battler/game/game_constants.dart';
import 'package:flame/game.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:card_battler/game/components/enemies.dart';
import 'package:card_battler/game/components/enemy.dart';
import 'package:card_battler/game/models/enemies_model.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

void main() {
  group('Enemies Component', () {
    group('Children Sizes and Positions', () {
      final testCases = [
        {
          'enemiesSize': Vector2(300, 200),
          'cardSize': Vector2(60, 120),
          'positions': [
            Vector2(30, 40),
            Vector2(120, 40),
            Vector2(210, 40),
          ],
        },
        {
          'enemiesSize': Vector2(600, 400),
          'cardSize': Vector2(120, 240),
          'positions': [
            Vector2(60, 80),
            Vector2(240, 80),
            Vector2(420, 80),
          ],
        },
      ];
      for (final testCase in testCases) {
        testWithFlameGame('Enemies children sizes and positions for enemies size ${testCase['enemiesSize']}', (game) async {
          final model = EnemiesModel(totalEnemies: 3);
          final enemies = Enemies(model: model)..size = testCase['enemiesSize'] as Vector2;

          await game.ensureAdd(enemies);

          final enemyComponents = enemies.children.whereType<Enemy>().toList();
          expect(enemyComponents.length, 3);
          final cardSize = testCase['cardSize'] as Vector2;
          final positions = testCase['positions'] as List<Vector2>;
          for (int i = 0; i < 3; i++) {
            expect(enemyComponents[i].size, cardSize);
            expect(enemyComponents[i].position, positions[i]);
          }
        });
      }
    });

    group('Model Integration', () {
      testWithFlameGame('displays text from model', (game) async {
        final model = EnemiesModel(totalEnemies: 5);
        final enemies = Enemies(model: model)..size = Vector2(400, 300);

        await game.ensureAdd(enemies);

        final textComponents = enemies.children.whereType<TextComponent>().toList();
        expect(textComponents.length, 1);
        expect(textComponents.first.text, equals(model.displayText));
      });

      testWithFlameGame('creates correct number of enemy components based on model', (game) async {
        final model = EnemiesModel(totalEnemies: 4);
        final enemies = Enemies(model: model)..size = Vector2(500, 400);

        await game.ensureAdd(enemies);

        final enemyComponents = enemies.children.whereType<Enemy>().toList();
        expect(enemyComponents.length, GameConstants.maxEnemiesInPlay);
      });
    });

    group('UI Properties', () {
      testWithFlameGame('text component is positioned correctly', (game) async {
        final model = EnemiesModel(totalEnemies: 3);
        final enemies = Enemies(model: model)..size = Vector2(300, 200);

        await game.ensureAdd(enemies);

        final textComponent = enemies.children.whereType<TextComponent>().first;
        expect(textComponent.position, equals(Vector2(150, 20))); // x: size.x / 2, y: 20
        expect(textComponent.anchor, equals(Anchor.center));
      });
    });
  });
}
