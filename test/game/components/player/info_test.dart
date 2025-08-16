import 'package:flutter_test/flutter_test.dart';
import 'package:card_battler/game/components/player/info.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flame/components.dart';

void main() {
  group('Info', () {
    testWithFlameGame('Info can be created and added to game', (game) async {
      final info = Info()..size = Vector2(200, 50);

      await game.ensureAdd(info);

      expect(info.size, equals(Vector2(200, 50)));
      expect(info.debugMode, isTrue);
    });

    testWithFlameGame('Info extends PositionComponent', (game) async {
      final info = Info();

      expect(info, isA<PositionComponent>());
    });

    testWithFlameGame('Info can be positioned', (game) async {
      final info = Info()
        ..size = Vector2(100, 25)
        ..position = Vector2(50, 10);

      await game.ensureAdd(info);

      expect(info.position, equals(Vector2(50, 10)));
      expect(info.size, equals(Vector2(100, 25)));
    });

    testWithFlameGame('Info has debug mode enabled', (game) async {
      final info = Info();

      expect(info.debugMode, isTrue);
    });
  });
}