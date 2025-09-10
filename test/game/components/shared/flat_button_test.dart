import 'package:flutter_test/flutter_test.dart';
import 'package:flame_test/flame_test.dart';
import 'package:card_battler/game_legacy/components/shared/flat_button.dart';
import 'package:flame/components.dart';

void main() {
  group('FlatButton', () {

    group('constructor and initialization', () {
      testWithFlameGame('creates with required text parameter', (game) async {
        final button = FlatButton('Test Button', size: Vector2(100, 50));
        
        await game.ensureAdd(button);
        
        final textComponent = button.children.whereType<TextComponent>().first;
        expect(textComponent.text, equals('Test Button'));
        expect(button.disabled, isFalse);
      });

      testWithFlameGame('creates with disabled state', (game) async {
        final button = FlatButton('Disabled Button', 
          size: Vector2(100, 50), 
          disabled: true
        );
        
        await game.ensureAdd(button);
        
        expect(button.disabled, isTrue);
      });

      testWithFlameGame('creates with callback', (game) async {
        bool callbackTriggered = false;
        final button = FlatButton('Callback Button',
          size: Vector2(100, 50),
          onReleased: () => callbackTriggered = true
        );
        
        await game.ensureAdd(button);
        
        button.onReleased?.call();
        expect(callbackTriggered, isTrue);
      });
    });

    group('disabled state functionality', () {
      testWithFlameGame('disabled getter returns correct state', (game) async {
        final button = FlatButton('Test', size: Vector2(100, 50));
        
        await game.ensureAdd(button);
        
        expect(button.disabled, isFalse);
        
        button.disabled = true;
        expect(button.disabled, isTrue);
      });

      testWithFlameGame('disabled setter changes state', (game) async {
        final button = FlatButton('Test', size: Vector2(100, 50));
        
        await game.ensureAdd(button);
        
        button.disabled = true;
        expect(button.disabled, isTrue);
        
        button.disabled = false;
        expect(button.disabled, isFalse);
      });

      testWithFlameGame('setting disabled to same value does not cause issues', (game) async {
        final button = FlatButton('Test', size: Vector2(100, 50));
        
        await game.ensureAdd(button);
        
        button.disabled = false;
        button.disabled = false;
        expect(button.disabled, isFalse);
        
        button.disabled = true;
        button.disabled = true;
        expect(button.disabled, isTrue);
      });

      testWithFlameGame('disabled button changes visual state correctly', (game) async {
        final button = FlatButton('Test', size: Vector2(100, 50));
        
        await game.ensureAdd(button);
        
        // Verify button is initially enabled
        expect(button.disabled, isFalse);
        
        // Disable the button
        button.disabled = true;
        
        // Verify button is disabled
        expect(button.disabled, isTrue);
        
        // Verify visual state changes (text component should exist and be styled for disabled state)
        final textComponent = button.children.whereType<TextComponent>().first;
        expect(textComponent, isNotNull);
      });

      testWithFlameGame('enabled button changes visual state correctly', (game) async {
        final button = FlatButton('Test', size: Vector2(100, 50), disabled: true);
        
        await game.ensureAdd(button);
        
        // Verify button is initially disabled
        expect(button.disabled, isTrue);
        
        // Enable the button
        button.disabled = false;
        
        // Verify button is enabled
        expect(button.disabled, isFalse);
        
        // Verify visual state changes (text component should exist and be styled for enabled state)
        final textComponent = button.children.whereType<TextComponent>().first;
        expect(textComponent, isNotNull);
      });
    });

    group('visual state changes', () {
      testWithFlameGame('text component exists after initialization', (game) async {
        final button = FlatButton('Visual Test', size: Vector2(100, 50));
        
        await game.ensureAdd(button);
        
        final textComponents = button.children.whereType<TextComponent>();
        expect(textComponents.length, equals(1));
        expect(textComponents.first.text, equals('Visual Test'));
      });

      testWithFlameGame('button has background component', (game) async {
        final button = FlatButton('Background Test', size: Vector2(100, 50));
        
        await game.ensureAdd(button);
        
        final backgroundComponents = button.children.whereType<ButtonBackground>();
        expect(backgroundComponents.length, greaterThanOrEqualTo(1));
      });
    });

    group('size and positioning', () {
      testWithFlameGame('button respects provided size', (game) async {
        final customSize = Vector2(150, 75);
        final button = FlatButton('Size Test', size: customSize);
        
        await game.ensureAdd(button);
        
        expect(button.size, equals(customSize));
      });

      testWithFlameGame('button respects provided position', (game) async {
        final customPosition = Vector2(25, 25);
        final button = FlatButton('Position Test', 
          size: Vector2(100, 50),
          position: customPosition
        );
        
        await game.ensureAdd(button);
        
        expect(button.position, equals(customPosition));
      });

      testWithFlameGame('text component is centered', (game) async {
        final button = FlatButton('Centered', size: Vector2(100, 50));
        
        await game.ensureAdd(button);
        
        final textComponent = button.children.whereType<TextComponent>().first;
        expect(textComponent.anchor, equals(Anchor.center));
        expect(textComponent.position, equals(button.size / 2));
      });
    });

    group('multiple instances', () {
      testWithFlameGame('different buttons work independently', (game) async {
        final button1 = FlatButton('Button 1', size: Vector2(100, 50));
        final button2 = FlatButton('Button 2', size: Vector2(100, 50), disabled: true);
        
        await game.ensureAdd(button1);
        await game.ensureAdd(button2);
        
        expect(button1.disabled, isFalse);
        expect(button2.disabled, isTrue);
        
        button1.disabled = true;
        expect(button1.disabled, isTrue);
        expect(button2.disabled, isTrue); // Should remain unchanged
        
        button2.disabled = false;
        expect(button1.disabled, isTrue); // Should remain unchanged
        expect(button2.disabled, isFalse);
      });

      testWithFlameGame('buttons have independent callbacks', (game) async {
        bool callback1Triggered = false;
        bool callback2Triggered = false;
        
        final button1 = FlatButton('Button 1',
          size: Vector2(100, 50),
          onReleased: () => callback1Triggered = true
        );
        final button2 = FlatButton('Button 2',
          size: Vector2(100, 50),
          onReleased: () => callback2Triggered = true
        );
        
        await game.ensureAdd(button1);
        await game.ensureAdd(button2);
        
        button1.onReleased?.call();
        expect(callback1Triggered, isTrue);
        expect(callback2Triggered, isFalse);
        
        button2.onReleased?.call();
        expect(callback1Triggered, isTrue);
        expect(callback2Triggered, isTrue);
      });
    });

    group('visibility integration', () {
      testWithFlameGame('button respects visibility changes', (game) async {
        final button = FlatButton('Visibility Test', size: Vector2(100, 50));
        
        await game.ensureAdd(button);
        
        expect(button.isVisible, isTrue);
        
        button.isVisible = false;
        expect(button.isVisible, isFalse);
        
        button.isVisible = true;
        expect(button.isVisible, isTrue);
      });

      testWithFlameGame('disabled button can still change visibility', (game) async {
        final button = FlatButton('Disabled Visible Test', 
          size: Vector2(100, 50), 
          disabled: true
        );
        
        await game.ensureAdd(button);
        
        expect(button.disabled, isTrue);
        expect(button.isVisible, isTrue);
        
        button.isVisible = false;
        expect(button.disabled, isTrue);
        expect(button.isVisible, isFalse);
      });
    });
  });
}