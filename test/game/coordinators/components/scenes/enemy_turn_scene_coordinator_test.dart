import 'package:card_battler/game/coordinators/components/cards/card_coordinator.dart';
import 'package:card_battler/game/coordinators/components/cards/card_list_coordinator.dart';
import 'package:card_battler/game/coordinators/components/scenes/enemy_turn_scene_coordinator.dart';
import 'package:card_battler/game/coordinators/components/team/players_info_coordinator.dart';
import 'package:card_battler/game/services/card/effects/effect_processor.dart';
import 'package:card_battler/game/services/game/game_phase_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCardListCoordinator extends Mock
    implements CardListCoordinator<CardCoordinator> {}

class MockPlayersInfoCoordinator extends Mock
    implements PlayersInfoCoordinator {}

class MockEffectProcessor extends Mock implements EffectProcessor {}

class MockGamePhaseManager extends Mock implements GamePhaseManager {}

void main() {
  group('EnemyTurnSceneCoordinator', () {
    late CardListCoordinator<CardCoordinator> mockPlayedCardsCoordinator;
    late CardListCoordinator<CardCoordinator> mockDeckCardsCoordinator;
    late EffectProcessor mockEffectProcessor;
    late GamePhaseManager mockGamePhaseManager;
    late EnemyTurnSceneCoordinator coordinator;

    setUp(() {
      mockPlayedCardsCoordinator = MockCardListCoordinator();
      mockDeckCardsCoordinator = MockCardListCoordinator();
      mockEffectProcessor = MockEffectProcessor();
      mockGamePhaseManager = MockGamePhaseManager();

      when(
        () => mockGamePhaseManager.currentPhase,
      ).thenReturn(GamePhase.enemyTurnWaitingToDrawCards);
      when(
        () => mockGamePhaseManager.nextPhase(),
      ).thenReturn(GamePhase.waitingToDrawPlayerCards);

      coordinator = EnemyTurnSceneCoordinator(
        playedCardsCoordinator: mockPlayedCardsCoordinator,
        deckCardsCoordinator: mockDeckCardsCoordinator,
        effectProcessor: mockEffectProcessor,
        gamePhaseManager: mockGamePhaseManager,
        numberOfCardsToDrawPerEnemyTurn: 3,
      );
    });

    group('Constructor', () {
      test('shuffles deck cards during construction', () {
        verify(() => mockDeckCardsCoordinator.shuffle()).called(1);
      });
    });

    group('Properties', () {
      test('playedCardsCoordinator getter returns correct instance', () {
        expect(
          coordinator.playedCardsCoordinator,
          isA<CardListCoordinator<CardCoordinator>>(),
        );
        expect(
          coordinator.playedCardsCoordinator,
          equals(mockPlayedCardsCoordinator),
        );
      });

      test('deckCardsCoordinator getter returns correct instance', () {
        expect(
          coordinator.deckCardsCoordinator,
          isA<CardListCoordinator<CardCoordinator>>(),
        );
        expect(
          coordinator.deckCardsCoordinator,
          equals(mockDeckCardsCoordinator),
        );
      });
    });

    group('Card Drawing', () {
      test('drawCardsFromDeck calls turn manager', () {
        when(() => mockDeckCardsCoordinator.hasCards).thenReturn(true);
        when(() => mockDeckCardsCoordinator.drawCards(any())).thenReturn([]);

        coordinator.drawCardsFromDeck();

        verify(
          () => mockDeckCardsCoordinator.drawCards(any()),
        ).called(greaterThan(0));
      });

      test('drawCardsFromDeck handles empty deck gracefully', () {
        when(() => mockDeckCardsCoordinator.hasCards).thenReturn(false);
        when(() => mockDeckCardsCoordinator.drawCards(any())).thenReturn([]);

        expect(() => coordinator.drawCardsFromDeck(), returnsNormally);
      });
    });

    group('Initialization', () {
      test('deck is shuffled exactly once during construction', () {
        reset(mockDeckCardsCoordinator);

        EnemyTurnSceneCoordinator(
          playedCardsCoordinator: mockPlayedCardsCoordinator,
          deckCardsCoordinator: mockDeckCardsCoordinator,
          effectProcessor: mockEffectProcessor,
          gamePhaseManager: mockGamePhaseManager,
          numberOfCardsToDrawPerEnemyTurn: 2,
        );

        verify(() => mockDeckCardsCoordinator.shuffle()).called(1);
      });
    });

    group('Turn Manager Integration', () {
      test('delegates card drawing to turn manager', () {
        when(() => mockDeckCardsCoordinator.hasCards).thenReturn(true);
        when(() => mockDeckCardsCoordinator.drawCards(any())).thenReturn([]);

        coordinator.drawCardsFromDeck();

        verify(
          () => mockDeckCardsCoordinator.drawCards(any()),
        ).called(greaterThan(0));
      });
    });
  });
}
