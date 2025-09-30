import 'package:card_battler/game/services/initialization/game_component_builder.dart';
import 'package:card_battler/game/services/initialization/game_initialization_service.dart';
import 'package:card_battler/game/ui/components/shared/turn_button_component.dart';
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

    /*group('buildTurnButton', () {
      test('creates TurnButtonComponent with correct coordinator', () {
        final turnButton = GameComponentBuilder.buildTurnButton(
          gameSize: testGameSize,
          services: services,
        );

        expect(turnButton, isA<TurnButtonComponent>());
        expect(turnButton, isNotNull);
      });

      test('sets correct priority for turn button', () {
        final turnButton = GameComponentBuilder.buildTurnButton(
          gameSize: testGameSize,
          services: services,
        );

        expect(turnButton.priority, equals(10));
      });

      test('sets correct size for turn button', () {
        final turnButton = GameComponentBuilder.buildTurnButton(
          gameSize: testGameSize,
          services: services,
        );

        expect(turnButton.size.x, equals(200));
        expect(turnButton.size.y, equals(50));
      });

      test('calculates position based on game size', () {
        final turnButton = GameComponentBuilder.buildTurnButton(
          gameSize: testGameSize,
          services: services,
        );

        final expectedY = ((testGameSize.y / 2) * -1) + (testGameSize.y * 0.05);
        expect(turnButton.position.x, equals(0));
        expect(turnButton.position.y, equals(expectedY));
      });

      test('uses all required services in coordinator', () {
        final turnButton = GameComponentBuilder.buildTurnButton(
          gameSize: testGameSize,
          services: services,
        );

        expect(turnButton, isNotNull);
        expect(services.gamePhaseManager, isNotNull);
        expect(services.dialogService, isNotNull);
        expect(services.activePlayerManager, isNotNull);
        expect(services.cardsSelectionManagerService, isNotNull);
      });
    });*/

    group('buildGameComponents', () {
      test('creates RouterComponent with turn button added', () {
        final router = GameComponentBuilder.buildGameComponents(
          gameSize: testGameSize,
          services: services,
        );

        expect(router, isA<RouterComponent>());
        expect(router.children, isNotEmpty);
      });

      test('adds turn button to router children', () {
        final router = GameComponentBuilder.buildGameComponents(
          gameSize: testGameSize,
          services: services,
        );

        final hasTurnButton = router.children.any(
          (child) => child is TurnButtonComponent,
        );
        expect(hasTurnButton, isTrue);
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

      // test('buildTurnButton completes quickly', () {
      //   final stopwatch = Stopwatch()..start();

      //   GameComponentBuilder.buildTurnButton(
      //     gameSize: testGameSize,
      //     services: services,
      //   );

      //   stopwatch.stop();
      //   expect(stopwatch.elapsedMilliseconds, lessThan(50));
      // });

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
