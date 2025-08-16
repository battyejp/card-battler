import 'package:flutter_test/flutter_test.dart';
import 'package:card_battler/game/components/ui/game_announcement.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flame/components.dart';

void main() {
  group('GameAnnouncement', () {
    group('constructor and initialization', () {
      testWithFlameGame('creates with required title parameter', (game) async {
        final announcement = GameAnnouncement(title: 'Enemies Go');

        await game.ensureAdd(announcement);

        expect(announcement.title, equals('Enemies Go'));
        expect(announcement.displayDuration, equals(const Duration(seconds: 5)));
        expect(announcement.priority, equals(1000));
      });

      testWithFlameGame('creates with custom duration', (game) async {
        final announcement = GameAnnouncement(
          title: 'Custom Message',
          displayDuration: const Duration(seconds: 3),
        );

        await game.ensureAdd(announcement);

        expect(announcement.displayDuration, equals(const Duration(seconds: 3)));
      });

      testWithFlameGame('creates with completion callback', (game) async {
        var callbackCalled = false;
        final announcement = GameAnnouncement(
          title: 'Test',
          onComplete: () => callbackCalled = true,
        );

        await game.ensureAdd(announcement);

        expect(announcement.onComplete, isNotNull);
      });
    });

    group('component structure', () {
      testWithFlameGame('fills entire game screen', (game) async {
        final announcement = GameAnnouncement(title: 'Test')
          ..size = Vector2(800, 600);

        await game.ensureAdd(announcement);

        expect(announcement.size, equals(Vector2(800, 600)));
      });

      testWithFlameGame('contains backdrop component', (game) async {
        final announcement = GameAnnouncement(title: 'Test');

        await game.ensureAdd(announcement);

        final backdrops = announcement.children.whereType<RectangleComponent>().toList();
        expect(backdrops.length, greaterThan(0));
        
        // Backdrop should cover entire announcement area
        final backdrop = backdrops.first;
        expect(backdrop.size, equals(announcement.size));
      });

      testWithFlameGame('contains announcement card', (game) async {
        final announcement = GameAnnouncement(title: 'Test');

        await game.ensureAdd(announcement);

        final rectangles = announcement.children.whereType<RectangleComponent>().toList();
        expect(rectangles.length, greaterThan(1)); // Backdrop + announcement card
      });

      testWithFlameGame('contains title text component', (game) async {
        final announcement = GameAnnouncement(title: 'Enemies Go');

        await game.ensureAdd(announcement);

        // Find the announcement card and check for text component
        final rectangles = announcement.children.whereType<RectangleComponent>().toList();
        bool hasTextComponent = false;
        
        for (final rect in rectangles) {
          final textComponents = rect.children.whereType<TextComponent>().toList();
          if (textComponents.isNotEmpty) {
            hasTextComponent = true;
            expect(textComponents.first.text, equals('Enemies Go'));
            break;
          }
        }
        
        expect(hasTextComponent, isTrue);
      });
    });

    group('positioning and sizing', () {
      testWithFlameGame('announcement card is centered', (game) async {
        final announcement = GameAnnouncement(title: 'Center Test');

        await game.ensureAdd(announcement);

        // Find the announcement card (not the backdrop)
        final rectangles = announcement.children.whereType<RectangleComponent>().toList();
        final announcementCard = rectangles.firstWhere(
          (rect) => rect.size.x == 400.0 && rect.size.y == 150.0,
        );
        
        // Check that card is positioned in center area
        expect(announcementCard.position.x, greaterThan(100));
        expect(announcementCard.position.y, greaterThan(50));
        expect(announcementCard.anchor, equals(Anchor.center));
      });

      testWithFlameGame('announcement card has correct size', (game) async {
        final announcement = GameAnnouncement(title: 'Size Test');

        await game.ensureAdd(announcement);

        final rectangles = announcement.children.whereType<RectangleComponent>().toList();
        final announcementCard = rectangles.firstWhere(
          (rect) => rect.size.x == 400.0 && rect.size.y == 150.0,
        );
        
        expect(announcementCard.size, equals(Vector2(400, 150)));
      });
    });

    group('text content', () {
      testWithFlameGame('displays correct title text', (game) async {
        final announcement = GameAnnouncement(title: 'Custom Title');

        await game.ensureAdd(announcement);

        // Search for text component in all children
        bool foundCorrectText = false;
        void searchForText(Component component) {
          if (component is TextComponent && component.text == 'Custom Title') {
            foundCorrectText = true;
          }
          for (final child in component.children) {
            searchForText(child);
          }
        }
        
        searchForText(announcement);
        expect(foundCorrectText, isTrue);
      });

      testWithFlameGame('handles different title texts', (game) async {
        final titles = ['Enemies Go', 'Player Turn', 'Game Over', 'Round 1'];
        
        for (final title in titles) {
          final announcement = GameAnnouncement(title: title);
          await game.ensureAdd(announcement);
          
          bool foundTitle = false;
          void searchForText(Component component) {
            if (component is TextComponent && component.text == title) {
              foundTitle = true;
            }
            for (final child in component.children) {
              searchForText(child);
            }
          }
          
          searchForText(announcement);
          expect(foundTitle, isTrue, reason: 'Title "$title" not found');
          
          game.remove(announcement);
        }
      });

      testWithFlameGame('handles empty title', (game) async {
        final announcement = GameAnnouncement(title: '');

        await game.ensureAdd(announcement);

        bool foundEmptyText = false;
        void searchForText(Component component) {
          if (component is TextComponent && component.text == '') {
            foundEmptyText = true;
          }
          for (final child in component.children) {
            searchForText(child);
          }
        }
        
        searchForText(announcement);
        expect(foundEmptyText, isTrue);
      });
    });

    group('priority and layering', () {
      testWithFlameGame('has high priority for overlay', (game) async {
        final announcement = GameAnnouncement(title: 'Priority Test');

        expect(announcement.priority, equals(1000));
      });

      testWithFlameGame('appears on top of other components', (game) async {
        // Add a regular component first
        final background = RectangleComponent(
          size: Vector2(100, 100),
          priority: 1,
        );
        await game.ensureAdd(background);

        // Add announcement
        final announcement = GameAnnouncement(title: 'On Top');
        await game.ensureAdd(announcement);

        expect(announcement.priority, greaterThan(background.priority));
      });
    });

    group('dismiss functionality', () {
      testWithFlameGame('can be dismissed early', (game) async {
        final announcement = GameAnnouncement(
          title: 'Dismissible',
          displayDuration: const Duration(seconds: 10), // Long duration
        );

        await game.ensureAdd(announcement);

        // Dismiss immediately
        announcement.dismiss();

        // Component should still exist but start fade out
        expect(game.children.contains(announcement), isTrue);
      });
    });

    group('edge cases', () {
      testWithFlameGame('handles very long titles', (game) async {
        final longTitle = 'This is a very long title that might not fit properly in the announcement card';
        final announcement = GameAnnouncement(title: longTitle);

        await game.ensureAdd(announcement);

        bool foundLongTitle = false;
        void searchForText(Component component) {
          if (component is TextComponent && component.text == longTitle) {
            foundLongTitle = true;
          }
          for (final child in component.children) {
            searchForText(child);
          }
        }
        
        searchForText(announcement);
        expect(foundLongTitle, isTrue);
      });

      testWithFlameGame('handles special characters in title', (game) async {
        final specialTitle = 'Enemies Go! @#\$%^&*()';
        final announcement = GameAnnouncement(title: specialTitle);

        await game.ensureAdd(announcement);

        bool foundSpecialTitle = false;
        void searchForText(Component component) {
          if (component is TextComponent && component.text == specialTitle) {
            foundSpecialTitle = true;
          }
          for (final child in component.children) {
            searchForText(child);
          }
        }
        
        searchForText(announcement);
        expect(foundSpecialTitle, isTrue);
      });

      testWithFlameGame('handles zero duration', (game) async {
        final announcement = GameAnnouncement(
          title: 'Instant',
          displayDuration: Duration.zero,
        );

        expect(() => game.ensureAdd(announcement), returnsNormally);
      });
    });
  });

  group('StyledGameAnnouncement', () {
    testWithFlameGame('creates with custom styling', (game) async {
      final announcement = StyledGameAnnouncement(
        title: 'Styled Test',
        fontSize: 48,
      );

      await game.ensureAdd(announcement);

      expect(announcement.title, equals('Styled Test'));
      expect(announcement.fontSize, equals(48));
    });

    testWithFlameGame('inherits from GameAnnouncement', (game) async {
      final announcement = StyledGameAnnouncement(title: 'Inheritance Test');

      expect(announcement, isA<GameAnnouncement>());
      expect(announcement.priority, equals(1000));
    });
  });
}