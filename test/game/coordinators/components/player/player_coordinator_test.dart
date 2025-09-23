import 'package:card_battler/game/coordinators/components/cards/card_coordinator.dart';
import 'package:card_battler/game/coordinators/components/cards/card_list_coordinator.dart';
import 'package:card_battler/game/coordinators/components/player/player_coordinator.dart';
import 'package:card_battler/game/coordinators/components/player/player_info_coordinator.dart';
import 'package:card_battler/game/services/card/effects/effect_processor.dart';
import 'package:card_battler/game/services/game/game_phase_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCardListCoordinator extends Mock
    implements CardListCoordinator<CardCoordinator> {}

class MockPlayerInfoCoordinator extends Mock implements PlayerInfoCoordinator {}

class MockGamePhaseManager extends Mock implements GamePhaseManager {}

class MockEffectProcessor extends Mock implements EffectProcessor {}

void main() {
  group('PlayerCoordinator', () {
    late CardListCoordinator<CardCoordinator> mockHandCardsCoordinator;
    late CardListCoordinator<CardCoordinator> mockDeckCardsCoordinator;
    late CardListCoordinator<CardCoordinator> mockDiscardCardsCoordinator;
    late PlayerInfoCoordinator mockPlayerInfoCoordinator;
    late GamePhaseManager mockGamePhaseManager;
    late EffectProcessor mockEffectProcessor;
    late PlayerCoordinator playerCoordinator;

    setUp(() {
      mockHandCardsCoordinator = MockCardListCoordinator();
      mockDeckCardsCoordinator = MockCardListCoordinator();
      mockDiscardCardsCoordinator = MockCardListCoordinator();
      mockPlayerInfoCoordinator = MockPlayerInfoCoordinator();
      mockGamePhaseManager = MockGamePhaseManager();
      mockEffectProcessor = MockEffectProcessor();

      // Set up default mock behaviors
      when(() => mockHandCardsCoordinator.hasCards).thenReturn(false);
      when(() => mockDeckCardsCoordinator.hasCards).thenReturn(true);
      when(() => mockDiscardCardsCoordinator.hasCards).thenReturn(false);
      when(
        () => mockGamePhaseManager.nextPhase(),
      ).thenReturn(GamePhase.waitingToDrawPlayerCards);

      // Mock the draw and add operations
      when(() => mockDeckCardsCoordinator.drawCards(any())).thenReturn([]);
      when(
        () => mockDiscardCardsCoordinator.drawCards(
          any(),
          refreshUi: any(named: 'refreshUi'),
        ),
      ).thenReturn([]);
      when(() => mockDiscardCardsCoordinator.removeAllCards()).thenReturn([]);
      when(() => mockHandCardsCoordinator.addCards(any())).thenReturn(null);
      when(() => mockDeckCardsCoordinator.addCards(any())).thenReturn(null);
      when(() => mockDiscardCardsCoordinator.shuffle()).thenReturn(null);

      playerCoordinator = PlayerCoordinator(
        handCardsCoordinator: mockHandCardsCoordinator,
        deckCardsCoordinator: mockDeckCardsCoordinator,
        discardCardsCoordinator: mockDiscardCardsCoordinator,
        playerInfoCoordinator: mockPlayerInfoCoordinator,
        gamePhaseManager: mockGamePhaseManager,
        effectProcessor: mockEffectProcessor,
      );
    });

    group('Constructor', () {
      test('shuffles deck cards during construction', () {
        verify(() => mockDeckCardsCoordinator.shuffle()).called(1);
      });
    });

    group('Properties', () {
      test('handCardsCoordinator getter returns correct instance', () {
        expect(
          playerCoordinator.handCardsCoordinator,
          isA<CardListCoordinator<CardCoordinator>>(),
        );
        expect(
          playerCoordinator.handCardsCoordinator,
          equals(mockHandCardsCoordinator),
        );
      });

      test('deckCardsCoordinator getter returns correct instance', () {
        expect(
          playerCoordinator.deckCardsCoordinator,
          isA<CardListCoordinator<CardCoordinator>>(),
        );
        expect(
          playerCoordinator.deckCardsCoordinator,
          equals(mockDeckCardsCoordinator),
        );
      });

      test('discardCardsCoordinator getter returns correct instance', () {
        expect(
          playerCoordinator.discardCardsCoordinator,
          isA<CardListCoordinator<CardCoordinator>>(),
        );
        expect(
          playerCoordinator.discardCardsCoordinator,
          equals(mockDiscardCardsCoordinator),
        );
      });

      test('playerInfoCoordinator getter returns correct instance', () {
        expect(
          playerCoordinator.playerInfoCoordinator,
          isA<PlayerInfoCoordinator>(),
        );
        expect(
          playerCoordinator.playerInfoCoordinator,
          equals(mockPlayerInfoCoordinator),
        );
      });

      test('gamePhaseManager getter returns correct instance', () {
        expect(playerCoordinator.gamePhaseManager, isA<GamePhaseManager>());
        expect(
          playerCoordinator.gamePhaseManager,
          equals(mockGamePhaseManager),
        );
      });
    });

    group('Card Management', () {
      test('drawCardsFromDeck calls underlying card manager', () {
        when(() => mockDeckCardsCoordinator.drawCards(any())).thenReturn([]);

        playerCoordinator.drawCardsFromDeck(3);

        verify(() => mockDeckCardsCoordinator.drawCards(3)).called(1);
      });

      test('drawCardsFromDeck with zero cards still calls manager', () {
        when(() => mockDeckCardsCoordinator.drawCards(any())).thenReturn([]);

        playerCoordinator.drawCardsFromDeck(0);

        verify(() => mockDeckCardsCoordinator.drawCards(0)).called(1);
      });

      test('drawCardsFromDeck with multiple calls works correctly', () {
        when(() => mockDeckCardsCoordinator.drawCards(any())).thenReturn([]);

        playerCoordinator.drawCardsFromDeck(2);
        playerCoordinator.drawCardsFromDeck(1);

        verify(() => mockDeckCardsCoordinator.drawCards(2)).called(1);
        verify(() => mockDeckCardsCoordinator.drawCards(1)).called(1);
      });
    });
  });
}
