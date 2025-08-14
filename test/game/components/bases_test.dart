import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:card_battler/game/components/bases.dart';
import 'package:card_battler/game/models/bases_model.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flame/components.dart';

void main() {
  group('Bases Component (UI-only)', () {
    group('Constructor and Model Integration', () {
      testWithFlameGame('displays correct text', (game) async {
        final model = BasesModel(totalBases: 4, baseMaxHealth: 100);
        final bases = Bases(model: model)
          ..size = Vector2(200, 200)
          ..position = Vector2(0, 0);

        await game.ensureAdd(bases);

        expect(game.children.contains(bases), isTrue);
        
        // Check that text component is added and shows correct text
        final textComponent = bases.children.firstWhere((child) => child is TextComponent) as TextComponent;
        expect(textComponent.text, equals('Base 1 of 4'));
      });

      testWithFlameGame('creates correct number of base components', (game) async {
        final model = BasesModel(totalBases: 3, baseMaxHealth: 50);
        final bases = Bases(model: model)
          ..size = Vector2(150, 150)
          ..position = Vector2(0, 0);

        await game.ensureAdd(bases);

        // Should have 3 base components + 1 text component = 4 children
        expect(bases.children.length, equals(4));
        
        // Count Base components
        final baseComponents = bases.children.where((child) => child.runtimeType.toString() == 'Base');
        expect(baseComponents.length, equals(3));
      });

      testWithFlameGame('sets correct visibility for base components', (game) async {
        final model = BasesModel(totalBases: 5, baseMaxHealth: 10);
        final bases = Bases(model: model)
          ..size = Vector2(100, 100)
          ..position = Vector2(0, 0);

        await game.ensureAdd(bases);

        final baseComponents = bases.children.where((child) => child.runtimeType.toString() == 'Base').toList();
        
        // Only the top (last) base should be visible
        for (int i = 0; i < baseComponents.length; i++) {
          final component = baseComponents[i] as HasVisibility;
          if (i == baseComponents.length - 1) {
            expect(component.isVisible, isTrue, reason: 'Top base should be visible');
          } else {
            expect(component.isVisible, isFalse, reason: 'Non-top bases should be hidden');
          }
        }
      });
    });

    group('UI Properties', () {
      testWithFlameGame('text component is positioned correctly', (game) async {
        final model = BasesModel(totalBases: 4, baseMaxHealth: 75);
        final bases = Bases(model: model)
          ..size = Vector2(200, 160)
          ..position = Vector2(0, 0);

        await game.ensureAdd(bases);

        final textComponent = bases.children.firstWhere((child) => child is TextComponent) as TextComponent;
        expect(textComponent.anchor, equals(Anchor.center));
        expect(textComponent.position, equals(Vector2(100, 20))); // Center X, reserved text area Y
      });

      testWithFlameGame('text has correct styling', (game) async {
        final model = BasesModel(totalBases: 2, baseMaxHealth: 25);
        final bases = Bases(model: model)
          ..size = Vector2(100, 100)
          ..position = Vector2(0, 0);

        await game.ensureAdd(bases);

        final textComponent = bases.children.firstWhere((child) => child is TextComponent) as TextComponent;
        final textPaint = textComponent.textRenderer as TextPaint;
        expect(textPaint.style.fontSize, equals(20));
        expect(textPaint.style.color, equals(Colors.white));
      });

      testWithFlameGame('base components are positioned correctly', (game) async {
        final model = BasesModel(totalBases: 3, baseMaxHealth: 10);
        final bases = Bases(model: model)
          ..size = Vector2(100, 160)
          ..position = Vector2(0, 0);

        await game.ensureAdd(bases);

        final baseComponents = bases.children.where((child) => child.runtimeType.toString() == 'Base').toList();
        
        // All base components should be positioned in the same place (stacked)
        for (final component in baseComponents) {
          final posComponent = component as PositionComponent;
          expect(posComponent.position, equals(Vector2(0, 40))); // Below text area
          expect(posComponent.size, equals(Vector2(100, 120))); // Remaining space after text
        }
      });
    });

    group('Size and Position', () {
      final testCases = [
        {'size': Vector2(100, 100), 'pos': Vector2(0, 0)},
        {'size': Vector2(200, 150), 'pos': Vector2(50, 25)},
        {'size': Vector2(80, 200), 'pos': Vector2(100, 0)},
      ];

      for (final testCase in testCases) {
        testWithFlameGame('handles size ${testCase['size']} and position ${testCase['pos']}', (game) async {
          final model = BasesModel(totalBases: 2, baseMaxHealth: 10);
          final bases = Bases(model: model)
            ..size = testCase['size'] as Vector2
            ..position = testCase['pos'] as Vector2;

          await game.ensureAdd(bases);

          expect(bases.size, equals(testCase['size']));
          expect(bases.position, equals(testCase['pos']));

          // Verify text is positioned correctly within the component
          final textComponent = bases.children.firstWhere((child) => child is TextComponent) as TextComponent;
          final expectedTextCenter = Vector2(
            (testCase['size'] as Vector2).x / 2,
            20, // Reserved text area
          );
          expect(textComponent.position, equals(expectedTextCenter));

          // Verify base components use remaining space
          final baseComponents = bases.children.where((child) => child.runtimeType.toString() == 'Base').toList();
          final expectedBaseSize = Vector2(
            (testCase['size'] as Vector2).x,
            (testCase['size'] as Vector2).y - 40, // Minus text area
          );
          
          for (final component in baseComponents) {
            final posComponent = component as PositionComponent;
            expect(posComponent.size, equals(expectedBaseSize));
            expect(posComponent.position, equals(Vector2(0, 40)));
          }
        });
      }
    });

    group('Dynamic Behavior', () {
      testWithFlameGame('handles different total base counts', (game) async {
        final testCounts = [1, 2, 4, 6];
        
        for (final count in testCounts) {
          final model = BasesModel(totalBases: count, baseMaxHealth: 10);
          final bases = Bases(model: model)
            ..size = Vector2(100, 100)
            ..position = Vector2(0, 0);

          await game.ensureAdd(bases);

          final textComponent = bases.children.firstWhere((child) => child is TextComponent) as TextComponent;
          expect(textComponent.text, equals('Base 1 of $count'));

          final baseComponents = bases.children.where((child) => child.runtimeType.toString() == 'Base');
          expect(baseComponents.length, equals(count));

          game.remove(bases);
        }
      });
    });
  });
}
