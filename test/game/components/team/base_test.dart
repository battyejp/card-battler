import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:card_battler/game_legacy/components/team/base.dart';
import 'package:card_battler/game_legacy/models/team/base_model.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flame/components.dart';

void main() {
  group('Base Component (UI-only)', () {
    group('Constructor and Model Integration', () {
      testWithFlameGame('creates with BaseModel and displays health', (game) async {
        final model = BaseModel(name: 'Test Base', maxHealth: 100);
        final base = Base(model: model)
          ..size = Vector2(200, 200)
          ..position = Vector2(0, 0);

        await game.ensureAdd(base);

        expect(game.children.contains(base), isTrue);
        
        // Check that text component is added and shows correct health
        expect(base.children.length, equals(1));
        final textComponent = base.children.first as TextComponent;
        expect(textComponent.text, equals('100/100'));
      });

      testWithFlameGame('reflects model health changes in display', (game) async {
        final model = BaseModel(name: 'Test Base', maxHealth: 50);
        final base = Base(model: model)
          ..size = Vector2(100, 100)
          ..position = Vector2(0, 0);

        await game.ensureAdd(base);

        final textComponent = base.children.first as TextComponent;
        expect(textComponent.text, equals('50/50'));
      });
    });

    group('UI Properties', () {
      testWithFlameGame('text component is centered correctly', (game) async {
        final model = BaseModel(name: 'Test Base', maxHealth: 75);
        final base = Base(model: model)
          ..size = Vector2(150, 150)
          ..position = Vector2(0, 0);

        await game.ensureAdd(base);

        final textComponent = base.children.first as TextComponent;
        expect(textComponent.anchor, equals(Anchor.center));
        expect(textComponent.position, equals(Vector2(75, 75))); // Center of 150x150
        expect(textComponent.text, equals('75/75'));
      });

      testWithFlameGame('text has correct styling', (game) async {
        final model = BaseModel(name: 'Test Base', maxHealth: 25);
        final base = Base(model: model)
          ..size = Vector2(100, 100)
          ..position = Vector2(0, 0);

        await game.ensureAdd(base);

        final textComponent = base.children.first as TextComponent;
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
          final model = BaseModel(name: 'Test Base', maxHealth: 10);
          final base = Base(model: model)
            ..size = testCase['size'] as Vector2
            ..position = testCase['pos'] as Vector2;

          await game.ensureAdd(base);

          expect(base.size, equals(testCase['size']));
          expect(base.position, equals(testCase['pos']));

          // Verify text is centered within the component
          final textComponent = base.children.first as TextComponent;
          final expectedCenter = Vector2(
            (testCase['size'] as Vector2).x / 2,
            (testCase['size'] as Vector2).y / 2,
          );
          expect(textComponent.position, equals(expectedCenter));
        });
      }
    });

    group('Visibility', () {
      testWithFlameGame('supports visibility changes', (game) async {
        final model = BaseModel(name: 'Test Base', maxHealth: 50);
        final base = Base(model: model)
          ..size = Vector2(100, 100)
          ..position = Vector2(0, 0);

        await game.ensureAdd(base);

        expect(base.isVisible, isTrue);

        base.isVisible = false;
        expect(base.isVisible, isFalse);

        base.isVisible = true;
        expect(base.isVisible, isTrue);
      });
    });
  });
}