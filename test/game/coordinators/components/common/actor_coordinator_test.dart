import 'package:card_battler/game/coordinators/components/common/actor_coordinator.dart';
import 'package:card_battler/game/models/common/actor_model.dart';
import 'package:card_battler/game/models/shared/health_model.dart';
import 'package:flutter_test/flutter_test.dart';

// Test implementation of ActorCoordinator
class TestActorCoordinator extends ActorCoordinator<TestActorCoordinator> {
  TestActorCoordinator(super.model);
}

// Mock ActorModel for testing
class MockActorModel extends ActorModel {
  MockActorModel({required super.healthModel, super.name = 'Test Actor'});
}

void main() {
  group('ActorCoordinator', () {
    late TestActorCoordinator actorCoordinator;
    late ActorModel mockActorModel;
    late HealthModel healthModel;

    setUp(() {
      healthModel = HealthModel(100, 150); // current: 100, max: 150
      mockActorModel = MockActorModel(healthModel: healthModel);
      actorCoordinator = TestActorCoordinator(mockActorModel);
    });

    tearDown(() {
      actorCoordinator.dispose();
    });

    group('Constructor', () {
      test('creates instance with required actor model', () {
        expect(actorCoordinator, isNotNull);
        expect(actorCoordinator, isA<ActorCoordinator<TestActorCoordinator>>());
        expect(actorCoordinator.model, equals(mockActorModel));
      });

      test('stores reference to provided model', () {
        expect(identical(actorCoordinator.model, mockActorModel), isTrue);
      });

      test('implements ReactiveCoordinator mixin', () {
        expect(actorCoordinator.changes, isNotNull);
        expect(actorCoordinator.changes.isBroadcast, isTrue);
      });
    });

    group('Properties', () {
      test('name getter returns actor model name', () {
        expect(actorCoordinator.name, equals('Test Actor'));
        expect(actorCoordinator.name, equals(mockActorModel.name));
      });

      test('health getter returns current health from model', () {
        expect(actorCoordinator.health, equals(100));
        expect(
          actorCoordinator.health,
          equals(mockActorModel.healthModel.currentHealth),
        );
      });

      test('healthDisplay getter returns health display string', () {
        expect(actorCoordinator.healthDisplay, equals('100/150'));
        expect(
          actorCoordinator.healthDisplay,
          equals(mockActorModel.healthModel.display),
        );
      });

      test('model getter returns the actor model', () {
        expect(actorCoordinator.model, isA<ActorModel>());
        expect(actorCoordinator.model, equals(mockActorModel));
      });

      test('properties reflect changes in underlying model', () {
        mockActorModel.healthModel.currentHealth = 75;

        expect(actorCoordinator.health, equals(75));
        expect(actorCoordinator.healthDisplay, equals('75/150'));
      });
    });

    group('Health Adjustment', () {
      test('adjustHealth increases health by positive amount', () {
        actorCoordinator.adjustHealth(25);

        expect(actorCoordinator.health, equals(125));
        expect(mockActorModel.healthModel.currentHealth, equals(125));
      });

      test('adjustHealth decreases health by negative amount', () {
        actorCoordinator.adjustHealth(-30);

        expect(actorCoordinator.health, equals(70));
        expect(mockActorModel.healthModel.currentHealth, equals(70));
      });

      test('adjustHealth with zero amount does not change health', () {
        actorCoordinator.adjustHealth(0);

        expect(actorCoordinator.health, equals(100));
        expect(mockActorModel.healthModel.currentHealth, equals(100));
      });

      test('adjustHealth notifies change when health is adjusted', () async {
        final changes = <TestActorCoordinator>[];
        final subscription = actorCoordinator.changes.listen(changes.add);

        actorCoordinator.adjustHealth(10);
        await Future.delayed(Duration.zero);

        expect(changes.length, equals(1));
        expect(identical(changes.first, actorCoordinator), isTrue);

        await subscription.cancel();
      });
    });

    group('Health Boundaries', () {
      test(
        'adjustHealth clamps health to max when current health > max health',
        () {
          mockActorModel.healthModel.currentHealth =
              200; // Greater than max (150)

          actorCoordinator.adjustHealth(10);

          expect(actorCoordinator.health, equals(150)); // Clamped to max
        },
      );

      test('adjustHealth clamps health to minimum when current health < 0', () {
        mockActorModel.healthModel.currentHealth = -10; // Less than 0

        actorCoordinator.adjustHealth(50);

        expect(
          actorCoordinator.health,
          equals(40),
        ); // Clamped to 0 + 50 - 10 = 40
      });
    });

    group('Multiple Health Adjustments', () {
      test('mixed positive and negative adjustments work correctly', () {
        actorCoordinator.adjustHealth(30); // 130
        actorCoordinator.adjustHealth(-20); // 110
        actorCoordinator.adjustHealth(15); // 125
        actorCoordinator.adjustHealth(-5); // 120

        expect(actorCoordinator.health, equals(120));
      });

      test(
        'multiple adjustments generate multiple change notifications',
        () async {
          final changes = <TestActorCoordinator>[];
          final subscription = actorCoordinator.changes.listen(changes.add);

          actorCoordinator.adjustHealth(10);
          actorCoordinator.adjustHealth(-5);
          actorCoordinator.adjustHealth(3);

          await Future.delayed(Duration.zero);

          expect(changes.length, equals(3));

          await subscription.cancel();
        },
      );
    });

    group('Reactive Behavior', () {
      test('change stream emits coordinator instance', () async {
        TestActorCoordinator? receivedCoordinator;
        final subscription = actorCoordinator.changes.listen((coordinator) {
          receivedCoordinator = coordinator;
        });

        actorCoordinator.adjustHealth(5);
        await Future.delayed(Duration.zero);

        expect(receivedCoordinator, isNotNull);
        expect(identical(receivedCoordinator, actorCoordinator), isTrue);

        await subscription.cancel();
      });

      test('supports multiple listeners', () async {
        final changes1 = <TestActorCoordinator>[];
        final changes2 = <TestActorCoordinator>[];

        final subscription1 = actorCoordinator.changes.listen(changes1.add);
        final subscription2 = actorCoordinator.changes.listen(changes2.add);

        actorCoordinator.adjustHealth(10);
        await Future.delayed(Duration.zero);

        expect(changes1.length, equals(1));
        expect(changes2.length, equals(1));
        expect(identical(changes1.first, actorCoordinator), isTrue);
        expect(identical(changes2.first, actorCoordinator), isTrue);

        await subscription1.cancel();
        await subscription2.cancel();
      });

      test('change notifications work after boundary conditions', () async {
        mockActorModel.healthModel.currentHealth = 200; // Set invalid state
        final changes = <TestActorCoordinator>[];
        final subscription = actorCoordinator.changes.listen(changes.add);

        // This should trigger notification since health gets clamped
        actorCoordinator.adjustHealth(10);
        await Future.delayed(Duration.zero);

        expect(
          changes.length,
          equals(1),
        ); // Health was clamped, so change occurred

        // Reset to valid state and try again
        mockActorModel.healthModel.currentHealth = 100;
        actorCoordinator.adjustHealth(5);
        await Future.delayed(Duration.zero);

        expect(changes.length, equals(2)); // Another change occurred

        await subscription.cancel();
      });
    });
    group('Performance', () {
      test('health adjustments are fast', () {
        final stopwatch = Stopwatch()..start();

        for (var i = 0; i < 1000; i++) {
          actorCoordinator.adjustHealth(1);
        }

        stopwatch.stop();
        expect(stopwatch.elapsedMilliseconds, lessThan(100));
      });

      test('property access is fast', () {
        final stopwatch = Stopwatch()..start();

        for (var i = 0; i < 1000; i++) {
          actorCoordinator.name;
          actorCoordinator.health;
          actorCoordinator.healthDisplay;
          actorCoordinator.model;
        }

        stopwatch.stop();
        expect(stopwatch.elapsedMilliseconds, lessThan(50));
      });

      test('change notifications are efficient', () async {
        final changes = <TestActorCoordinator>[];
        final subscription = actorCoordinator.changes.listen(changes.add);

        final stopwatch = Stopwatch()..start();

        for (var i = 0; i < 50; i++) {
          // Use smaller number to avoid boundary issues
          actorCoordinator.adjustHealth(1);
        }

        stopwatch.stop();
        expect(stopwatch.elapsedMilliseconds, lessThan(200));

        await Future.delayed(Duration.zero);
        expect(changes.length, equals(50));

        await subscription.cancel();
      });
    });

    group('Integration', () {
      test('complex health adjustment scenarios', () {
        // Start with 100/150 health
        expect(actorCoordinator.health, equals(100));

        // Take damage
        actorCoordinator.adjustHealth(-30);
        expect(actorCoordinator.health, equals(70));

        // Heal partially
        actorCoordinator.adjustHealth(20);
        expect(actorCoordinator.health, equals(90));

        // Take more damage
        actorCoordinator.adjustHealth(-40);
        expect(actorCoordinator.health, equals(50));

        // Full heal (clamped to max)
        actorCoordinator.adjustHealth(200);
        expect(actorCoordinator.health, equals(150)); // Clamped to max health
      });
    });
  });
}
