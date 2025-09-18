import 'package:card_battler/game/coordinators/components/cards/card_coordinator.dart';
import 'package:card_battler/game/coordinators/components/cards/card_list_coordinator.dart';
import 'package:card_battler/game/coordinators/components/enemy/enemies_coordinator.dart';
import 'package:card_battler/game/coordinators/components/enemy/enemy_coordinator.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockEnemyCoordinator extends Mock implements EnemyCoordinator {}

class MockCardListCoordinator extends Mock
    implements CardListCoordinator<CardCoordinator> {}

void main() {
  group('EnemiesCoordinator', () {
    late List<EnemyCoordinator> mockEnemyCoordinators;
    late CardListCoordinator<CardCoordinator> mockDeckCardsCoordinator;
    late CardListCoordinator<CardCoordinator> mockPlayedCardsCoordinator;
    late EnemiesCoordinator enemiesCoordinator;

    setUp(() {
      mockEnemyCoordinators = [
        MockEnemyCoordinator(),
        MockEnemyCoordinator(),
        MockEnemyCoordinator(),
      ];
      mockDeckCardsCoordinator = MockCardListCoordinator();
      mockPlayedCardsCoordinator = MockCardListCoordinator();

      enemiesCoordinator = EnemiesCoordinator(
        enemyCoordinators: mockEnemyCoordinators,
        deckCardsCoordinator: mockDeckCardsCoordinator,
        playedCardsCoordinator: mockPlayedCardsCoordinator,
      );
    });

    group('Properties', () {
      test('allEnemyCoordinators getter returns all enemy coordinators', () {
        expect(enemiesCoordinator.allEnemyCoordinators, hasLength(3));
        expect(
          enemiesCoordinator.allEnemyCoordinators,
          equals(mockEnemyCoordinators),
        );
      });

      test('numberOfEnemies getter returns correct count', () {
        expect(enemiesCoordinator.numberOfEnemies, equals(3));
      });

      test('maxNumberOfEnemiesInPlay getter returns 3', () {
        expect(enemiesCoordinator.maxNumberOfEnemiesInPlay, equals(3));
      });

      test(
        'numberOfEnemiesNotInPlay calculates correctly when equal to max',
        () {
          expect(enemiesCoordinator.numberOfEnemiesNotInPlay, equals(0));
        },
      );

      test('numberOfEnemiesNotInPlay calculates correctly when below max', () {
        final fewerEnemies = [MockEnemyCoordinator()];
        final coordinatorWithFewerEnemies = EnemiesCoordinator(
          enemyCoordinators: fewerEnemies,
          deckCardsCoordinator: mockDeckCardsCoordinator,
          playedCardsCoordinator: mockPlayedCardsCoordinator,
        );

        expect(
          coordinatorWithFewerEnemies.numberOfEnemiesNotInPlay,
          equals(-2),
        );
      });

      test('numberOfEnemiesNotInPlay calculates correctly when above max', () {
        final moreEnemies = [
          MockEnemyCoordinator(),
          MockEnemyCoordinator(),
          MockEnemyCoordinator(),
          MockEnemyCoordinator(),
          MockEnemyCoordinator(),
        ];
        final coordinatorWithMoreEnemies = EnemiesCoordinator(
          enemyCoordinators: moreEnemies,
          deckCardsCoordinator: mockDeckCardsCoordinator,
          playedCardsCoordinator: mockPlayedCardsCoordinator,
        );

        expect(coordinatorWithMoreEnemies.numberOfEnemiesNotInPlay, equals(2));
      });
    });

    group('Card Coordinators', () {
      test('deckCardsCoordinator getter returns correct instance', () {
        expect(
          enemiesCoordinator.deckCardsCoordinator,
          isA<CardListCoordinator<CardCoordinator>>(),
        );
        expect(
          enemiesCoordinator.deckCardsCoordinator,
          equals(mockDeckCardsCoordinator),
        );
      });
    });
  });
}
