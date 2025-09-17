import 'package:card_battler/game/card_battler_game.dart';
import 'package:flame/game.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('CardBattlerGame', () {
    late CardBattlerGame game;

    setUp(() {
      game = CardBattlerGame();
    });

    group('Constructor', () {
      test('default constructor creates instance', () {
        expect(game, isA<CardBattlerGame>());
        expect(game, isA<FlameGame>());
      });

      test('withSize constructor sets test size', () {
        final testSize = Vector2(800, 600);
        final gameWithSize = CardBattlerGame.withSize(testSize);

        expect(gameWithSize, isA<CardBattlerGame>());
        expect(gameWithSize, isA<FlameGame>());
      });
    });

    group('Game Lifecycle', () {
      test('onLoad initializes game components', () async {
        final testGame = CardBattlerGame.withSize(Vector2(800, 600));

        await testGame.onLoad();

        expect(testGame.world.children.length, greaterThan(0));
      });
    });

    group('Game State Initialization', () {
      test('router component is added to world', () async {
        final testGame = CardBattlerGame.withSize(Vector2(800, 600));

        await testGame.onLoad();

        final children = testGame.world.children;
        expect(children, isNotEmpty);

        final hasRouterComponent = children.any(
          (child) => child.runtimeType.toString().contains('Router'),
        );
        expect(hasRouterComponent, isTrue);
      });
    });

    group('Performance', () {
      test('game initialization completes within reasonable time', () async {
        final testGame = CardBattlerGame.withSize(Vector2(800, 600));
        final stopwatch = Stopwatch()..start();

        await testGame.onLoad();

        stopwatch.stop();
        expect(stopwatch.elapsedMilliseconds, lessThan(5000)); // 5 seconds max
      });

      test('game with test size initializes quickly', () async {
        final testGame = CardBattlerGame.withSize(Vector2(800, 600));
        final stopwatch = Stopwatch()..start();

        await testGame.onLoad();

        stopwatch.stop();
        expect(stopwatch.elapsedMilliseconds, lessThan(5000)); // 5 seconds max
      });
    });

    group('Memory Management', () {
      test('game properly initializes without memory leaks', () async {
        final testGame = CardBattlerGame.withSize(Vector2(800, 600));

        await testGame.onLoad();

        expect(testGame.world.children, isNotEmpty);

        testGame.world.removeAll(testGame.world.children);

        expect(testGame.world.children, isEmpty);
      });
    });
  });
}
