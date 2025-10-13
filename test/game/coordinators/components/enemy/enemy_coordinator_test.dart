import 'package:card_battler/game/coordinators/components/enemy/enemy_coordinator.dart';
import 'package:card_battler/game/models/enemy/enemy_model.dart';
import 'package:card_battler/game/models/shared/health_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EnemyCoordinator', () {
    late EnemyModel enemyModel;
    late EnemyCoordinator enemyCoordinator;

    setUp(() {
      enemyModel = EnemyModel(
        name: 'Test Enemy',
        healthModel: HealthModel(100, 100),
      );
      enemyCoordinator = EnemyCoordinator(model: enemyModel);
    });

    group('Properties', () {
      test('name getter returns model name', () {
        expect(enemyCoordinator.name, equals('Test Enemy'));
      });

      test('health getter returns current health', () {
        expect(enemyCoordinator.health, equals(100));
      });

      test('healthDisplay getter returns health display', () {
        expect(enemyCoordinator.healthDisplay, equals('100/100'));
      });
    });

    group('Health Management', () {
      test('adjustHealth increases health correctly', () {
        enemyCoordinator.adjustHealth(10);
        expect(enemyCoordinator.health, equals(100));
      });

      test('adjustHealth decreases health correctly', () {
        enemyCoordinator.adjustHealth(-20);
        expect(enemyCoordinator.health, equals(80));
      });

      test('adjustHealth clamps health at zero', () {
        enemyCoordinator.adjustHealth(-150);
        expect(enemyCoordinator.health, equals(0));
      });

      test('adjustHealth clamps health at maximum', () {
        enemyCoordinator.adjustHealth(-50);
        enemyCoordinator.adjustHealth(100);
        expect(enemyCoordinator.health, equals(100));
      });

      test('adjustHealth updates health display', () {
        enemyCoordinator.adjustHealth(-30);
        expect(enemyCoordinator.healthDisplay, equals('70/100'));
      });
    });

    group('Reactive Behavior', () {
      test('notifies changes when health is adjusted', () async {
        var notified = false;
        enemyCoordinator.changes.listen((_) => notified = true);

        enemyCoordinator.adjustHealth(-10);

        await Future.delayed(Duration.zero);
        expect(notified, isTrue);
      });
    });
  });
}
