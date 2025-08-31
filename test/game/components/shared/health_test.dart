import 'package:card_battler/game/components/shared/health.dart';
import 'package:card_battler/game/models/shared/health_model.dart';
import 'package:flame/components.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flame_test/flame_test.dart';

void main() {
  group('Health', () {
    group('constructor and initialization', () {
      testWithFlameGame('creates with required parameters', (game) async {
        final model = HealthModel(maxHealth: 100);
        final health = Health(model);
        
        expect(health.model, equals(model));
      });

      testWithFlameGame('creates with custom anchor', (game) async {
        final model = HealthModel(maxHealth: 100);
        final health = Health(model, Anchor.center);
        
        await game.ensureAdd(health);
        
        expect(health.model, equals(model));
      });

      testWithFlameGame('uses default anchor when none provided', (game) async {
        final model = HealthModel(maxHealth: 100);
        final health = Health(model);
        
        await game.ensureAdd(health);
        
        // Component should be added successfully with default anchor
        expect(health.isMounted, isTrue);
      });
    });

    group('display functionality', () {
      testWithFlameGame('adds text component on display update', (game) async {
        final model = HealthModel(maxHealth: 100);
        final health = Health(model);
        
        await game.ensureAdd(health);
        
        // Should have a text component child
        final textComponents = health.children.whereType<TextComponent>();
        expect(textComponents, hasLength(1));
        
        final textComponent = textComponents.first;
        expect(textComponent.text, equals('100/100'));
        expect(textComponent.anchor, equals(Anchor.centerLeft));
      });

      testWithFlameGame('uses custom anchor for text component', (game) async {
        final model = HealthModel(maxHealth: 50);
        final health = Health(model, Anchor.topRight);
        
        await game.ensureAdd(health);
        
        final textComponents = health.children.whereType<TextComponent>();
        final textComponent = textComponents.first;
        expect(textComponent.anchor, equals(Anchor.topRight));
      });

      testWithFlameGame('updates text when model changes', (game) async {
        final model = HealthModel(maxHealth: 100);
        final health = Health(model);
        
        await game.ensureAdd(health);
        
        // Initial text
        var textComponent = health.children.whereType<TextComponent>().first;
        expect(textComponent.text, equals('100/100'));
        
        // Change health
        model.changeHealth(-25);
        await game.ready();
        
        // Text should update
        textComponent = health.children.whereType<TextComponent>().first;
        expect(textComponent.text, equals('75/100'));
      });

      testWithFlameGame('replaces text component on each update', (game) async {
        final model = HealthModel(maxHealth: 100);
        final health = Health(model);
        
        await game.ensureAdd(health);
        
        // Get initial text component
        final initialTextComponent = health.children.whereType<TextComponent>().first;
        
        // Change health to trigger update
        model.changeHealth(-10);
        await game.ready();
        
        // Should still have exactly one text component
        final textComponents = health.children.whereType<TextComponent>();
        expect(textComponents, hasLength(1));
        
        // Should be a different instance (replaced)
        final newTextComponent = textComponents.first;
        expect(newTextComponent, isNot(same(initialTextComponent)));
        expect(newTextComponent.text, equals('90/100'));
      });
    });

    group('reactive behavior', () {
      testWithFlameGame('responds to multiple health changes', (game) async {
        final model = HealthModel(maxHealth: 200);
        final health = Health(model);
        
        await game.ensureAdd(health);
        
        // Series of health changes
        final expectedTexts = ['200/200', '175/200', '150/200', '200/200', '100/200'];
        final changes = [0, -25, -25, 50, -100];
        
        for (int i = 0; i < changes.length; i++) {
          if (i > 0) {
            model.changeHealth(changes[i]);
            await game.ready();
          }
          
          final textComponent = health.children.whereType<TextComponent>().first;
          expect(textComponent.text, equals(expectedTexts[i]), 
                 reason: 'Failed at step $i with change ${changes[i]}');
        }
      });

      testWithFlameGame('handles extreme health values', (game) async {
        final model = HealthModel(maxHealth: 1000);
        final health = Health(model);
        
        await game.ensureAdd(health);
        
        // Extreme negative change (should clamp to 0)
        model.changeHealth(-2000);
        await game.ready();
        
        var textComponent = health.children.whereType<TextComponent>().first;
        expect(textComponent.text, equals('0/1000'));
        
        // Extreme positive change (should clamp to max)
        model.changeHealth(5000);
        await game.ready();
        
        textComponent = health.children.whereType<TextComponent>().first;
        expect(textComponent.text, equals('1000/1000'));
      });
    });

    group('component lifecycle', () {
      testWithFlameGame('cleans up properly when removed', (game) async {
        final model = HealthModel(maxHealth: 100);
        final health = Health(model);
        
        await game.ensureAdd(health);
        
        // Verify it's working
        model.changeHealth(-10);
        await game.ready();
        
        var textComponent = health.children.whereType<TextComponent>().first;
        expect(textComponent.text, equals('90/100'));
        
        // Remove component
        game.remove(health);
        await game.ready();
        
        // Model changes should not affect the removed component
        model.changeHealth(-20);
        await game.ready();
        
        // Component should be removed
        expect(health.isMounted, isFalse);
      });

      testWithFlameGame('handles multiple health components with same model', (game) async {
        final model = HealthModel(maxHealth: 100);
        final health1 = Health(model, Anchor.topLeft);
        final health2 = Health(model, Anchor.bottomRight);
        
        await game.ensureAdd(health1);
        await game.ensureAdd(health2);
        
        // Both should display the same text initially
        var text1 = health1.children.whereType<TextComponent>().first;
        var text2 = health2.children.whereType<TextComponent>().first;
        expect(text1.text, equals('100/100'));
        expect(text2.text, equals('100/100'));
        expect(text1.anchor, equals(Anchor.topLeft));
        expect(text2.anchor, equals(Anchor.bottomRight));
        
        // Change model - both should update
        model.changeHealth(-30);
        await game.ready();
        
        text1 = health1.children.whereType<TextComponent>().first;
        text2 = health2.children.whereType<TextComponent>().first;
        expect(text1.text, equals('70/100'));
        expect(text2.text, equals('70/100'));
      });
    });
  });
}