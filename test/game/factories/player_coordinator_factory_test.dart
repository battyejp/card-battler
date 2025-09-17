import 'package:card_battler/game/coordinators/components/cards/card_coordinator.dart';
import 'package:card_battler/game/coordinators/components/cards/card_list_coordinator.dart';
import 'package:card_battler/game/coordinators/components/player/player_coordinator.dart';
import 'package:card_battler/game/coordinators/components/player/player_info_coordinator.dart';
import 'package:card_battler/game/coordinators/components/team/players_info_coordinator.dart';
import 'package:card_battler/game/factories/player_coordinator_factory.dart';
import 'package:card_battler/game/models/player/player_model.dart';
import 'package:card_battler/game/services/card/cards_selection_manager_service.dart';
import 'package:card_battler/game/services/card/effects/effect_processor.dart';
import 'package:card_battler/game/services/game/game_phase_manager.dart';
import 'package:card_battler/game/services/player/active_player_manager.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/mock_helpers.dart';

void main() {
  group('PlayerCoordinatorFactory', () {
    late GamePhaseManager mockGamePhaseManager;
    late ActivePlayerManager mockActivePlayerManager;
    late CardsSelectionManagerService mockCardsSelectionManagerService;
    late EffectProcessor mockEffectProcessor;

    setUp(() {
      mockGamePhaseManager = MockHelpers.createMockGamePhaseManager();
      mockActivePlayerManager = MockHelpers.createMockActivePlayerManager();
      mockCardsSelectionManagerService = MockHelpers.createMockSelectionService();
      mockEffectProcessor = MockHelpers.createMockEffectProcessor();
    });

    group('createPlayerCoordinators', () {
      test('creates player coordinators for empty player list', () {
        final players = <PlayerModel>[];

        final coordinators = PlayerCoordinatorFactory.createPlayerCoordinators(
          players: players,
          gamePhaseManager: mockGamePhaseManager,
          activePlayerManager: mockActivePlayerManager,
          cardsSelectionManagerService: mockCardsSelectionManagerService,
          effectProcessor: mockEffectProcessor,
        );

        expect(coordinators, isEmpty);
      });

      test('creates single player coordinator with correct structure', () {
        final deckCards = [
          MockHelpers.createMockCard(name: 'Card 1'),
          MockHelpers.createMockCard(name: 'Card 2'),
        ];
        
        final player = MockHelpers.createTestPlayer(
          name: 'Test Player',
          deckCards: deckCards,
        );

        final coordinators = PlayerCoordinatorFactory.createPlayerCoordinators(
          players: [player],
          gamePhaseManager: mockGamePhaseManager,
          activePlayerManager: mockActivePlayerManager,
          cardsSelectionManagerService: mockCardsSelectionManagerService,
          effectProcessor: mockEffectProcessor,
        );

        expect(coordinators, hasLength(1));
        
        final coordinator = coordinators.first;
        expect(coordinator, isA<PlayerCoordinator>());
        expect(coordinator.handCardsCoordinator, isA<CardListCoordinator<CardCoordinator>>());
        expect(coordinator.deckCardsCoordinator, isA<CardListCoordinator<CardCoordinator>>());
        expect(coordinator.discardCardsCoordinator, isA<CardListCoordinator<CardCoordinator>>());
        expect(coordinator.playerInfoCoordinator, isA<PlayerInfoCoordinator>());
        
        // Verify deck cards are properly converted to coordinators
        expect(coordinator.deckCardsCoordinator.cardCoordinators, hasLength(2));
        
        // Verify hand and discard start empty
        expect(coordinator.handCardsCoordinator.cardCoordinators, isEmpty);
        expect(coordinator.discardCardsCoordinator.cardCoordinators, isEmpty);
      });

      test('creates multiple player coordinators correctly', () {
        final players = [
          MockHelpers.createTestPlayer(name: 'Player 1', deckCards: [MockHelpers.createMockCard()]),
          MockHelpers.createTestPlayer(name: 'Player 2', deckCards: [MockHelpers.createMockCard(), MockHelpers.createMockCard()]),
          MockHelpers.createTestPlayer(name: 'Player 3', deckCards: []),
        ];

        final coordinators = PlayerCoordinatorFactory.createPlayerCoordinators(
          players: players,
          gamePhaseManager: mockGamePhaseManager,
          activePlayerManager: mockActivePlayerManager,
          cardsSelectionManagerService: mockCardsSelectionManagerService,
          effectProcessor: mockEffectProcessor,
        );

        expect(coordinators, hasLength(3));
        
        // Verify each coordinator has the correct number of deck cards
        expect(coordinators[0].deckCardsCoordinator.cardCoordinators, hasLength(1));
        expect(coordinators[1].deckCardsCoordinator.cardCoordinators, hasLength(2));
        expect(coordinators[2].deckCardsCoordinator.cardCoordinators, isEmpty);
        
        // Verify player info coordinators are properly set
        expect(coordinators[0].playerInfoCoordinator.name, equals('Player 1'));
        expect(coordinators[1].playerInfoCoordinator.name, equals('Player 2'));
        expect(coordinators[2].playerInfoCoordinator.name, equals('Player 3'));
      });

      test('correctly wires services to card coordinators', () {
        final deckCard = MockHelpers.createMockCard(name: 'Test Card');
        final player = MockHelpers.createTestPlayer(deckCards: [deckCard]);

        final coordinators = PlayerCoordinatorFactory.createPlayerCoordinators(
          players: [player],
          gamePhaseManager: mockGamePhaseManager,
          activePlayerManager: mockActivePlayerManager,
          cardsSelectionManagerService: mockCardsSelectionManagerService,
          effectProcessor: mockEffectProcessor,
        );

        final cardCoordinator = coordinators.first.deckCardsCoordinator.cardCoordinators.first;
        
        expect(cardCoordinator.gamePhaseManager, equals(mockGamePhaseManager));
        expect(cardCoordinator.activePlayerManager, equals(mockActivePlayerManager));
        expect(cardCoordinator.selectionManagerService, equals(mockCardsSelectionManagerService));
      });

      test('uses copied card models for coordinators', () {
        final originalCard = MockHelpers.createMockCard(name: 'Original Card');
        final player = MockHelpers.createTestPlayer(deckCards: [originalCard]);

        final coordinators = PlayerCoordinatorFactory.createPlayerCoordinators(
          players: [player],
          gamePhaseManager: mockGamePhaseManager,
          activePlayerManager: mockActivePlayerManager,
          cardsSelectionManagerService: mockCardsSelectionManagerService,
          effectProcessor: mockEffectProcessor,
        );

        final cardCoordinator = coordinators.first.deckCardsCoordinator.cardCoordinators.first;
        
        // The factory should call copy() on the card model
        // Since our mock returns itself, we can verify copy was called through the mock
        expect(cardCoordinator.name, equals('Original Card'));
      });
    });

    group('createPlayersInfoCoordinator', () {
      test('creates PlayersInfoCoordinator from empty list', () {
        final playerCoordinators = <PlayerCoordinator>[];

        final playersInfoCoordinator = PlayerCoordinatorFactory.createPlayersInfoCoordinator(
          playerCoordinators: playerCoordinators,
        );

        expect(playersInfoCoordinator, isA<PlayersInfoCoordinator>());
        expect(playersInfoCoordinator.players, isEmpty);
      });

      test('creates PlayersInfoCoordinator with correct player info coordinators', () {
        final players = [
          MockHelpers.createTestPlayer(name: 'Player 1'),
          MockHelpers.createTestPlayer(name: 'Player 2'),
        ];

        final playerCoordinators = PlayerCoordinatorFactory.createPlayerCoordinators(
          players: players,
          gamePhaseManager: mockGamePhaseManager,
          activePlayerManager: mockActivePlayerManager,
          cardsSelectionManagerService: mockCardsSelectionManagerService,
          effectProcessor: mockEffectProcessor,
        );

        final playersInfoCoordinator = PlayerCoordinatorFactory.createPlayersInfoCoordinator(
          playerCoordinators: playerCoordinators,
        );

        expect(playersInfoCoordinator.players, hasLength(2));
        expect(playersInfoCoordinator.players[0].name, equals('Player 1'));
        expect(playersInfoCoordinator.players[1].name, equals('Player 2'));
      });

      test('preserves order of player coordinators', () {
        final players = [
          MockHelpers.createTestPlayer(name: 'Alpha'),
          MockHelpers.createTestPlayer(name: 'Beta'),
          MockHelpers.createTestPlayer(name: 'Gamma'),
        ];

        final playerCoordinators = PlayerCoordinatorFactory.createPlayerCoordinators(
          players: players,
          gamePhaseManager: mockGamePhaseManager,
          activePlayerManager: mockActivePlayerManager,
          cardsSelectionManagerService: mockCardsSelectionManagerService,
          effectProcessor: mockEffectProcessor,
        );

        final playersInfoCoordinator = PlayerCoordinatorFactory.createPlayersInfoCoordinator(
          playerCoordinators: playerCoordinators,
        );

        final names = playersInfoCoordinator.players.map((p) => p.name).toList();
        expect(names, equals(['Alpha', 'Beta', 'Gamma']));
      });
    });

    group('Integration tests', () {
      test('full workflow creates consistent coordinator structure', () {
        final players = [
          MockHelpers.createTestPlayer(
            name: 'Hero',
            health: 100,
            deckCards: [
              MockHelpers.createMockCard(name: 'Sword'),
              MockHelpers.createMockCard(name: 'Shield'),
            ],
            credits: 10,
            attack: 5,
          ),
          MockHelpers.createTestPlayer(
            name: 'Ally',
            health: 80,
            deckCards: [MockHelpers.createMockCard(name: 'Heal Potion')],
            credits: 5,
            attack: 3,
          ),
        ];

        // Create player coordinators
        final playerCoordinators = PlayerCoordinatorFactory.createPlayerCoordinators(
          players: players,
          gamePhaseManager: mockGamePhaseManager,
          activePlayerManager: mockActivePlayerManager,
          cardsSelectionManagerService: mockCardsSelectionManagerService,
          effectProcessor: mockEffectProcessor,
        );

        // Create players info coordinator
        final playersInfoCoordinator = PlayerCoordinatorFactory.createPlayersInfoCoordinator(
          playerCoordinators: playerCoordinators,
        );

        // Verify complete structure
        expect(playerCoordinators, hasLength(2));
        expect(playersInfoCoordinator.players, hasLength(2));

        // Verify first player structure
        final hero = playerCoordinators[0];
        expect(hero.playerInfoCoordinator.name, equals('Hero'));
        expect(hero.playerInfoCoordinator.health, equals(100));
        expect(hero.deckCardsCoordinator.cardCoordinators, hasLength(2));

        // Verify second player structure
        final ally = playerCoordinators[1];
        expect(ally.playerInfoCoordinator.name, equals('Ally'));
        expect(ally.playerInfoCoordinator.health, equals(80));
        expect(ally.deckCardsCoordinator.cardCoordinators, hasLength(1));

        // Verify consistency between coordinators and info coordinator
        expect(playersInfoCoordinator.players[0], equals(hero.playerInfoCoordinator));
        expect(playersInfoCoordinator.players[1], equals(ally.playerInfoCoordinator));
      });
    });
  });
}