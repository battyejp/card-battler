import 'package:card_battler/game/components/shared/card_focus_overlay.dart';
import 'package:card_battler/game/models/shared/card_model.dart';
import 'package:flame/events.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flame/components.dart';

void main() {
  group('CardFocusOverlay', () {
    group('initialization', () {
      testWithFlameGame('creates with required card model and callback', (game) async {
        bool dismissed = false;
        final cardModel = CardModel(name: 'Test Card', type: 'Test');
        
        final overlay = CardFocusOverlay(
          cardModel: cardModel,
          onDismiss: () => dismissed = true,
        )..size = Vector2(800, 600);

        await game.ensureAdd(overlay);

        expect(overlay.cardModel, equals(cardModel));
        expect(dismissed, isFalse); // Should not be dismissed initially
      });

      testWithFlameGame('creates enlarged card component in center', (game) async {
        final cardModel = CardModel(name: 'Centered Card', type: 'Test');
        final overlay = CardFocusOverlay(
          cardModel: cardModel,
          onDismiss: () {},
        )..size = Vector2(800, 600);

        await game.ensureAdd(overlay);

        // Wait for components to be added
        await game.ready();

        // Should have the enlarged card component
        expect(overlay.enlargedCard.cardModel, equals(cardModel));
        
        // Card should be centered (allowing for slight differences due to positioning)
        final expectedCenterX = (800 - 120) / 2; // overlay width - card width
        final expectedCenterY = (600 - 180) / 2; // overlay height - card height
        
        expect(overlay.enlargedCard.position.x, closeTo(expectedCenterX, 1));
        expect(overlay.enlargedCard.position.y, closeTo(expectedCenterY, 1));
      });
    });

    group('tap interaction', () {
      testWithFlameGame('implements TapCallbacks', (game) async {
        final cardModel = CardModel(name: 'Tappable Card', type: 'Test');
        final overlay = CardFocusOverlay(
          cardModel: cardModel,
          onDismiss: () {},
        );

        expect(overlay, isA<TapCallbacks>());
      });

      testWithFlameGame('has dismiss functionality', (game) async {
        bool dismissed = false;
        final cardModel = CardModel(name: 'Dismissible Card', type: 'Test');
        final overlay = CardFocusOverlay(
          cardModel: cardModel,
          onDismiss: () => dismissed = true,
        )..size = Vector2(800, 600);

        await game.ensureAdd(overlay);
        await game.ready();

        // Test internal dismiss method by calling it directly
        overlay.dismiss();

        // onDismiss should be called (but after animation, so we check the component is being removed)
        expect(dismissed, isFalse); // Not immediate due to animation
        
        // Check that scaling animation was started (card should have scale effects)
        expect(overlay.enlargedCard.children.any((child) => child.toString().contains('ScaleEffect')), isTrue);
      });
    });

    group('card display', () {
      testWithFlameGame('displays correct card information', (game) async {
        final cardModel = CardModel(
          name: 'Magic Spell', 
          type: 'Spell',
          isFaceUp: true,
        );
        final overlay = CardFocusOverlay(
          cardModel: cardModel,
          onDismiss: () {},
        )..size = Vector2(800, 600);

        await game.ensureAdd(overlay);
        await game.ready();

        // Card should show the correct name when face up
        final textComponents = overlay.enlargedCard.children.whereType<TextComponent>().toList();
        expect(textComponents.isNotEmpty, isTrue);
        expect(textComponents.first.text, equals('Magic Spell'));
      });

      testWithFlameGame('handles face down cards', (game) async {
        final cardModel = CardModel(
          name: 'Hidden Card', 
          type: 'Secret',
          isFaceUp: false,
        );
        final overlay = CardFocusOverlay(
          cardModel: cardModel,
          onDismiss: () {},
        )..size = Vector2(800, 600);

        await game.ensureAdd(overlay);
        await game.ready();

        // Card should show "Back" when face down
        final textComponents = overlay.enlargedCard.children.whereType<TextComponent>().toList();
        expect(textComponents.isNotEmpty, isTrue);
        expect(textComponents.first.text, equals('Back'));
      });
    });
  });
}