import 'package:flutter_test/flutter_test.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flame/components.dart';
import 'package:card_battler/game/components/shared/take_enemy_turn_button.dart';

void main() {
  group('TakeEnemyTurnButton', () {
    testWithFlameGame('renders correctly', (game) async {
      final button = TakeEnemyTurnButton()
        ..size = Vector2(200, 60);
      
      await game.ensureAdd(button);
      
      expect(button.isMounted, isTrue);
      expect(button.children.length, equals(2)); // Background + text components
    });

    testWithFlameGame('calls onTap callback when tapped', (game) async {
      bool tapped = false;
      
      final button = TakeEnemyTurnButton(
        onTap: () => tapped = true,
      )..size = Vector2(200, 60);
      
      await game.ensureAdd(button);
      
      // Call the callback directly
      button.onTap?.call();
      
      expect(tapped, isTrue);
    });

    testWithFlameGame('does not crash when onTap is null', (game) async {
      final button = TakeEnemyTurnButton()
        ..size = Vector2(200, 60);
      
      await game.ensureAdd(button);
      
      // Should not throw when tapped with null callback
      expect(() => button.onTap?.call(), returnsNormally);
    });
  });
}