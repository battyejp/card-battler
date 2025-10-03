import 'package:card_battler/game/coordinators/components/player/player_coordinator.dart';
import 'package:card_battler/game/coordinators/components/team/team_coordinator.dart';
import 'package:card_battler/game/factories/team_coordinator_factory.dart';
import 'package:card_battler/game/models/game_state_model.dart';
import 'package:card_battler/game/services/initialization/game_state_factory.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TeamCoordinatorFactory', () {
    late GameStateModel gameState;
    late List<PlayerCoordinator> playerCoordinators;

    setUp(() {
      gameState = GameStateFactory.createWithData([], [], [], []);
      playerCoordinators = [];
    });

    group('createTeamCoordinator', () {
      test('creates TeamCoordinator with correct team mates', () {
        final teamCoordinator = TeamCoordinatorFactory.createTeamCoordinator(
          playerCoordinators: playerCoordinators,
          state: gameState,
        );

        expect(teamCoordinator, isA<TeamCoordinator>());
        expect(
          teamCoordinator.teamMatesCoordinators.length,
          equals(playerCoordinators.length),
        );
      });

      test('creates TeamCoordinator with bases from game state', () {
        final teamCoordinator = TeamCoordinatorFactory.createTeamCoordinator(
          playerCoordinators: playerCoordinators,
          state: gameState,
        );

        expect(teamCoordinator.basesCoordinator, isNotNull);
        expect(
          teamCoordinator.basesCoordinator.allBaseCoordinators.length,
          equals(gameState.bases.length),
        );
      });

      test('maps player coordinators to team mate coordinators', () {
        final teamCoordinator = TeamCoordinatorFactory.createTeamCoordinator(
          playerCoordinators: playerCoordinators,
          state: gameState,
        );

        expect(
          teamCoordinator.teamMatesCoordinators.length,
          equals(playerCoordinators.length),
        );
      });

      test('handles empty player coordinators list', () {
        final teamCoordinator = TeamCoordinatorFactory.createTeamCoordinator(
          playerCoordinators: [],
          state: gameState,
        );

        expect(teamCoordinator.teamMatesCoordinators, isEmpty);
      });
    });
  });
}
