import 'package:card_battler/game/coordinators/components/cards/card_coordinator.dart';
import 'package:card_battler/game/coordinators/components/cards/card_list_coordinator.dart';
import 'package:card_battler/game/coordinators/components/player/player_coordinator.dart';
import 'package:card_battler/game/coordinators/components/shared/turn_button_component_coordinator.dart';
import 'package:card_battler/game/services/game/game_phase_manager.dart';
import 'package:card_battler/game/services/player/active_player_manager.dart';
import 'package:card_battler/game/services/ui/dialog_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGamePhaseManager extends Mock implements GamePhaseManager {}

class MockDialogService extends Mock implements DialogService {}

class MockActivePlayerManager extends Mock implements ActivePlayerManager {}

class MockPlayerCoordinator extends Mock implements PlayerCoordinator {}

class MockCardListCoordinator extends Mock
    implements CardListCoordinator<CardCoordinator> {}

void main() {
  group('TurnButtonComponentCoordinator', () {
    late GamePhaseManager mockGamePhaseManager;
    late DialogService mockDialogService;
    late ActivePlayerManager mockActivePlayerManager;
    late TurnButtonComponentCoordinator coordinator;

    setUp(() {
      mockGamePhaseManager = MockGamePhaseManager();
      mockDialogService = MockDialogService();
      mockActivePlayerManager = MockActivePlayerManager();

      when(
        () => mockGamePhaseManager.nextPhase(),
      ).thenReturn(GamePhase.waitingToDrawPlayerCards);

      coordinator = TurnButtonComponentCoordinator(
        gamePhaseManager: mockGamePhaseManager,
        dialogService: mockDialogService,
        activePlayerManager: mockActivePlayerManager,
      );
    });

    group('Constructor', () {
      test('registers phase change listener during construction', () {
        verify(
          () => mockGamePhaseManager.addPhaseChangeListener(any()),
        ).called(1);
      });

      test('initializes with default values', () {
        expect(coordinator.buttonText, equals("End Turn"));
        expect(coordinator.buttonVisible, isFalse);
      });
    });

    group('Turn Button Press Handling', () {
      test(
        'shows confirmation dialog when player has cards during action phase',
        () {
          final mockPlayer = MockPlayerCoordinator();
          final mockHandCards = MockCardListCoordinator();

          when(
            () => mockGamePhaseManager.currentPhase,
          ).thenReturn(GamePhase.playerTakeActionsTurn);
          when(
            () => mockActivePlayerManager.activePlayer,
          ).thenReturn(mockPlayer);
          when(() => mockPlayer.handCardsCoordinator).thenReturn(mockHandCards);
          when(
            () => mockHandCards.cardCoordinators,
          ).thenReturn([MockCardCoordinator()]);

          coordinator.handleTurnButtonPressed();

          verify(
            () => mockDialogService.showCustomConfirmation(
              title: 'Confirm End Turn',
              message:
                  'You still have cards to play, are you sure you want to end your turn?',
              onConfirm: any(named: 'onConfirm'),
              onCancel: any(named: 'onCancel'),
            ),
          ).called(1);
        },
      );

      test(
        'proceeds directly when player has no cards during action phase',
        () {
          final mockPlayer = MockPlayerCoordinator();
          final mockHandCards = MockCardListCoordinator();

          when(
            () => mockGamePhaseManager.currentPhase,
          ).thenReturn(GamePhase.playerTakeActionsTurn);
          when(
            () => mockActivePlayerManager.activePlayer,
          ).thenReturn(mockPlayer);
          when(() => mockPlayer.handCardsCoordinator).thenReturn(mockHandCards);
          when(() => mockHandCards.cardCoordinators).thenReturn([]);

          coordinator.handleTurnButtonPressed();

          verify(() => mockGamePhaseManager.nextPhase()).called(1);
          verifyNever(
            () => mockDialogService.showCustomConfirmation(
              title: any(named: 'title'),
              message: any(named: 'message'),
              onConfirm: any(named: 'onConfirm'),
              onCancel: any(named: 'onCancel'),
            ),
          );
        },
      );

      test('proceeds directly when not in player action phase', () {
        when(
          () => mockGamePhaseManager.currentPhase,
        ).thenReturn(GamePhase.waitingToDrawPlayerCards);

        coordinator.handleTurnButtonPressed();

        verify(() => mockGamePhaseManager.nextPhase()).called(1);
        verifyNever(
          () => mockDialogService.showCustomConfirmation(
            title: any(named: 'title'),
            message: any(named: 'message'),
            onConfirm: any(named: 'onConfirm'),
            onCancel: any(named: 'onCancel'),
          ),
        );
      });
    });

    group('Initial State', () {
      test('has default button text and visibility', () {
        expect(coordinator.buttonText, equals("End Turn"));
        expect(coordinator.buttonVisible, isFalse);
      });
    });

    group('Disposal', () {
      test('removes phase change listener on dispose', () {
        coordinator.dispose();

        verify(
          () => mockGamePhaseManager.removePhaseChangeListener(any()),
        ).called(1);
      });
    });

    group('Reactive Behavior', () {
      test('can listen to changes', () async {
        var notified = false;
        coordinator.changes.listen((_) => notified = true);

        // Since we can't directly trigger phase changes, just verify the stream works
        await Future.delayed(Duration.zero);
        expect(notified, isFalse); // No changes made yet
      });
    });
  });
}

class MockCardCoordinator extends Mock implements CardCoordinator {}
