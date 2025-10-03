import 'package:card_battler/game/coordinators/components/cards/card_coordinator.dart';
import 'package:card_battler/game/coordinators/components/cards/card_list_coordinator.dart';
import 'package:card_battler/game/coordinators/components/player/player_info_coordinator.dart';
import 'package:card_battler/game/models/card/card_list_model.dart';
import 'package:card_battler/game/models/card/card_model.dart';
import 'package:card_battler/game/models/player/player_model.dart';
import 'package:card_battler/game/models/shared/health_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PlayerInfoCoordinator', () {
    late PlayerModel playerModel;
    late PlayerInfoCoordinator playerInfoCoordinator;

    setUp(() {
      playerModel = PlayerModel(
        name: 'Test Player',
        healthModel: HealthModel(100, 100),
        handCards: CardListModel<CardModel>(),
        deckCards: CardListModel<CardModel>(),
        discardCards: CardListModel<CardModel>(),
        isActive: true,
        credits: 50,
        attack: 10,
      );
      playerInfoCoordinator = PlayerInfoCoordinator(playerModel, CardListCoordinator<CardCoordinator>(cardCoordinators: []));
    });

    group('Basic Properties', () {
      test('name getter returns model name', () {
        expect(playerInfoCoordinator.name, equals('Test Player'));
      });

      test('health getter returns current health', () {
        expect(playerInfoCoordinator.health, equals(100));
      });

      test('healthDisplay getter returns health display', () {
        expect(playerInfoCoordinator.healthDisplay, equals('HP: 100/100'));
      });

      test('attack getter returns model attack', () {
        expect(playerInfoCoordinator.attack, equals(10));
      });

      test('credits getter returns model credits', () {
        expect(playerInfoCoordinator.credits, equals(50));
      });
    });

    group('Active Status', () {
      test('isActive getter returns model isActive', () {
        expect(playerInfoCoordinator.isActive, isTrue);
      });

      test('isActive setter updates model isActive', () {
        playerInfoCoordinator.isActive = false;
        expect(playerInfoCoordinator.isActive, isFalse);
        expect(playerModel.isActive, isFalse);
      });

      test('isActive setter can toggle status', () {
        playerInfoCoordinator.isActive = false;
        expect(playerInfoCoordinator.isActive, isFalse);

        playerInfoCoordinator.isActive = true;
        expect(playerInfoCoordinator.isActive, isTrue);
      });
    });

    group('Credits Management', () {
      test('adjustCredits increases credits correctly', () {
        playerInfoCoordinator.adjustCredits(25);
        expect(playerInfoCoordinator.credits, equals(75));
      });

      test('adjustCredits decreases credits correctly', () {
        playerInfoCoordinator.adjustCredits(-20);
        expect(playerInfoCoordinator.credits, equals(30));
      });

      test('adjustCredits prevents negative credits', () {
        playerInfoCoordinator.adjustCredits(-100);
        expect(playerInfoCoordinator.credits, equals(50));
      });

      test('adjustCredits allows exactly zero credits', () {
        playerInfoCoordinator.adjustCredits(-50);
        expect(playerInfoCoordinator.credits, equals(0));
      });

      test('adjustCredits notifies changes when successful', () async {
        var notified = false;
        playerInfoCoordinator.changes.listen((_) => notified = true);

        playerInfoCoordinator.adjustCredits(10);

        await Future.delayed(Duration.zero);
        expect(notified, isTrue);
      });

      test('adjustCredits does not notify when preventing negative', () async {
        var notified = false;
        playerInfoCoordinator.changes.listen((_) => notified = true);

        playerInfoCoordinator.adjustCredits(-100);

        await Future.delayed(Duration.zero);
        expect(notified, isFalse);
      });
    });

    group('Reset Functionality', () {
      test('resetCreditsAndAttack resets both values to zero', () {
        playerInfoCoordinator.resetCreditsAndAttack();

        expect(playerInfoCoordinator.credits, equals(0));
        expect(playerInfoCoordinator.attack, equals(0));
      });

      test('resetCreditsAndAttack notifies changes', () async {
        var notified = false;
        playerInfoCoordinator.changes.listen((_) => notified = true);

        playerInfoCoordinator.resetCreditsAndAttack();

        await Future.delayed(Duration.zero);
        expect(notified, isTrue);
      });

      test('resetCreditsAndAttack works when values already zero', () {
        playerModel.credits = 0;
        playerModel.attack = 0;

        expect(
          () => playerInfoCoordinator.resetCreditsAndAttack(),
          returnsNormally,
        );
        expect(playerInfoCoordinator.credits, equals(0));
        expect(playerInfoCoordinator.attack, equals(0));
      });
    });

    group('Health Management (Inherited)', () {
      test('adjustHealth increases health correctly', () {
        playerInfoCoordinator.adjustHealth(10);
        expect(playerInfoCoordinator.health, equals(100));
      });

      test('adjustHealth decreases health correctly', () {
        playerInfoCoordinator.adjustHealth(-30);
        expect(playerInfoCoordinator.health, equals(70));
      });

      test('adjustHealth clamps health at zero', () {
        playerInfoCoordinator.adjustHealth(-150);
        expect(playerInfoCoordinator.health, equals(0));
      });

      test('adjustHealth clamps health at maximum', () {
        playerInfoCoordinator.adjustHealth(-50);
        playerInfoCoordinator.adjustHealth(100);
        expect(playerInfoCoordinator.health, equals(100));
      });
    });

    group('Reactive Behavior', () {
      test('multiple listeners are notified on credits adjustment', () async {
        var notificationCount = 0;
        playerInfoCoordinator.changes.listen((_) => notificationCount++);
        playerInfoCoordinator.changes.listen((_) => notificationCount++);

        playerInfoCoordinator.adjustCredits(5);

        await Future.delayed(Duration.zero);
        expect(notificationCount, equals(2));
      });

      test('multiple listeners are notified on reset', () async {
        var notificationCount = 0;
        playerInfoCoordinator.changes.listen((_) => notificationCount++);
        playerInfoCoordinator.changes.listen((_) => notificationCount++);

        playerInfoCoordinator.resetCreditsAndAttack();

        await Future.delayed(Duration.zero);
        expect(notificationCount, equals(2));
      });
    });
  });
}
