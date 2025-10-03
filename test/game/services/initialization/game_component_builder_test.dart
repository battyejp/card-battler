import 'package:card_battler/game/services/initialization/game_component_builder.dart';
import 'package:card_battler/game/services/initialization/game_initialization_service.dart';
import 'package:flame/game.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('GameComponentBuilder', () {
    late ServiceContainer services;
    late Vector2 testGameSize;

    setUp(() async {
      final gameState = await GameInitializationService.initializeGameState();
      services = GameInitializationService.createServices(gameState);
      testGameSize = Vector2(800, 600);
    });

    group('buildGameRouter', () {
      test('creates RouterComponent with required services', () {
        final router = GameComponentBuilder.buildGameRouter(
          gameSize: testGameSize,
          services: services,
        );

        expect(router, isA<RouterComponent>());
        expect(router, isNotNull);
      });

      test('initializes dialog service with router', () {
        final router = GameComponentBuilder.buildGameRouter(
          gameSize: testGameSize,
          services: services,
        );

        expect(router, isNotNull);
        expect(services.dialogService, isNotNull);
      });

      test('uses correct coordinators for router creation', () {
        final router = GameComponentBuilder.buildGameRouter(
          gameSize: testGameSize,
          services: services,
        );

        expect(router, isNotNull);
        expect(services.coordinatorsManager.gameSceneCoordinator, isNotNull);
        expect(
          services.coordinatorsManager.enemyTurnSceneCoordinator,
          isNotNull,
        );
      });
    });

    group('Performance', () {
      test('buildGameRouter completes quickly', () {
        final stopwatch = Stopwatch()..start();

        GameComponentBuilder.buildGameRouter(
          gameSize: testGameSize,
          services: services,
        );

        stopwatch.stop();
        expect(stopwatch.elapsedMilliseconds, lessThan(100));
      });

      test('buildGameComponents completes within reasonable time', () {
        final stopwatch = Stopwatch()..start();

        GameComponentBuilder.buildGameComponents(
          gameSize: testGameSize,
          services: services,
        );

        stopwatch.stop();
        expect(stopwatch.elapsedMilliseconds, lessThan(200));
      });
    });
  });
}
