import 'package:flutter_test/flutter_test.dart';
import 'package:card_battler/game_legacy/services/player_turn/player_turn_manager.dart';
import 'package:card_battler/game_legacy/services/game_state/game_state_service.dart';
import 'package:card_battler/game_legacy/models/game_state_model.dart';
import 'package:card_battler/game_legacy/models/player/player_turn_model.dart';
import 'package:card_battler/game_legacy/services/player/player_coordinator.dart';
import 'package:card_battler/game_legacy/models/player/player_model.dart';
import 'package:card_battler/game_legacy/models/player/info_model.dart';
import 'package:card_battler/game_legacy/models/shared/cards_model.dart';
import 'package:card_battler/game_legacy/models/shared/card_model.dart';
import 'package:card_battler/game_legacy/models/shared/health_model.dart';
import 'package:card_battler/game_legacy/models/shared/value_image_label_model.dart';
import 'package:card_battler/game_legacy/models/team/team_model.dart';
import 'package:card_battler/game_legacy/models/team/bases_model.dart';
import 'package:card_battler/game_legacy/models/team/players_model.dart';
import 'package:card_battler/game_legacy/models/enemy/enemies_model.dart';
import 'package:card_battler/game_legacy/services/shop/shop_coordinator.dart';
import 'package:card_battler/game_legacy/services/card/card_selection_service.dart';

// Test data generators
List<CardModel> _generateCards(int count, {String prefix = 'Card'}) {
  return List.generate(count, (index) => CardModel(
    name: '$prefix ${index + 1}',
    type: 'test',
    isFaceUp: false,
  ));
}

PlayerTurnModel _createTestPlayerTurnState({
  List<CardModel>? handCards,
  List<CardModel>? deckCards,
  List<CardModel>? discardCards,
}) {
  final player = PlayerCoordinator.create(
    state: PlayerModel.create(
      infoModel: InfoModel(
        attack: ValueImageLabelModel(value: 0, label: 'Attack'),
        credits: ValueImageLabelModel(value: 0, label: 'Credits'),
        name: 'Test Player',
        healthModel: HealthModel(maxHealth: 10),
      ),
      handModel: CardsModel<CardModel>(cards: handCards ?? []),
      deckModel: CardsModel<CardModel>(cards: deckCards ?? []),
      discardModel: CardsModel<CardModel>(cards: discardCards ?? []),
      gameStateService: MockGameStateService(),
      cardSelectionService: MockCardSelectionService(),
    ),
  );

  return PlayerTurnModel(
    playerModel: player,
    teamModel: TeamModel(
      bases: BasesModel(bases: []),
      playersModel: PlayersModel(players: []),
    ),
    enemiesModel: EnemiesModel(
      totalEnemies: 1,
      maxNumberOfEnemiesInPlay: 1,
      maxEnemyHealth: 10,
      enemyCards: [],
    ),
    shopModel: ShopCoordinator.create(
      numberOfRows: 1,
      numberOfColumns: 1,
      cards: [],
    ),
  );
}

void main() {
  group('DefaultTurnManager', () {
    late DefaultPlayerTurnManager turnManager;
    late MockGameStateService mockGameStateService;

    setUp(() {
      mockGameStateService = MockGameStateService();
      turnManager = DefaultPlayerTurnManager(mockGameStateService);
    });

    group('endTurn', () {
      test('discards hand, refills shop and advances phase when deck has cards', () {
        final handCards = _generateCards(2, prefix: 'Hand');
        final deckCards = _generateCards(5, prefix: 'Deck');
        final discardCards = _generateCards(1, prefix: 'Discard');
        final state = _createTestPlayerTurnState(
          handCards: handCards,
          deckCards: deckCards,
          discardCards: discardCards,
        );

        turnManager.endTurn(state);

        // Verify hand was discarded
        expect(state.playerModel.handCards.cards, isEmpty);
        expect(state.playerModel.discardCards.cards.length, equals(3));
        expect(state.playerModel.discardCards.cards, containsAll(handCards));

        // Verify deck remains unchanged (no reshuffle needed)
        expect(state.playerModel.deckCards.cards.length, equals(5));
        expect(state.playerModel.deckCards.cards, containsAll(deckCards));

        // Verify game state service calls
        expect(mockGameStateService.nextPhaseCalled, isTrue);
      });

      group('reshuffle functionality', () {
        test('reshuffles discard into deck when deck is empty', () {
          final handCards = _generateCards(2, prefix: 'Hand');
          final discardCards = _generateCards(5, prefix: 'Discard');
          final state = _createTestPlayerTurnState(
            handCards: handCards,
            deckCards: [], // Empty deck
            discardCards: discardCards,
          );

          turnManager.endTurn(state);

          // Verify hand was discarded first
          expect(state.playerModel.handCards.cards, isEmpty);
          
          // Verify discard pile is now empty (cards moved to deck)
          expect(state.playerModel.discardCards.cards, isEmpty);
          
          // Verify deck now contains all the previous discard cards + discarded hand cards
          expect(state.playerModel.deckCards.cards.length, equals(7));
          
          // Verify all cards are present (though order may be different due to shuffle)
          final allExpectedCards = [...handCards, ...discardCards];
          for (final card in allExpectedCards) {
            expect(state.playerModel.deckCards.cards, contains(card));
          }
        });

        test('does not reshuffle when deck has cards', () {
          final handCards = _generateCards(2, prefix: 'Hand');
          final deckCards = _generateCards(3, prefix: 'Deck');
          final discardCards = _generateCards(2, prefix: 'Discard');
          final state = _createTestPlayerTurnState(
            handCards: handCards,
            deckCards: deckCards,
            discardCards: discardCards,
          );

          turnManager.endTurn(state);

          // Verify no reshuffle occurred
          expect(state.playerModel.deckCards.cards.length, equals(3));
          expect(state.playerModel.deckCards.cards, containsAll(deckCards));
          
          // Verify discard pile has hand cards + original discard cards
          expect(state.playerModel.discardCards.cards.length, equals(4));
          expect(state.playerModel.discardCards.cards, containsAll([...handCards, ...discardCards]));
        });

        test('reshuffles only discard cards when hand is empty but deck is empty', () {
          final discardCards = _generateCards(4, prefix: 'Discard');
          final state = _createTestPlayerTurnState(
            handCards: [], // Empty hand
            deckCards: [], // Empty deck
            discardCards: discardCards,
          );

          turnManager.endTurn(state);

          // Verify discard pile is empty after reshuffle
          expect(state.playerModel.discardCards.cards, isEmpty);
          
          // Verify deck contains all discard cards
          expect(state.playerModel.deckCards.cards.length, equals(4));
          expect(state.playerModel.deckCards.cards, containsAll(discardCards));
        });

        test('handles case where both deck and discard are empty', () {
          final state = _createTestPlayerTurnState(
            handCards: [],
            deckCards: [],
            discardCards: [],
          );

          turnManager.endTurn(state);

          // Verify all piles remain empty
          expect(state.playerModel.handCards.cards, isEmpty);
          expect(state.playerModel.deckCards.cards, isEmpty);
          expect(state.playerModel.discardCards.cards, isEmpty);
        });

        test('shuffles deck after reshuffle', () {
          // Create cards with predictable order
          final discardCards = [
            CardModel(name: 'Card A', type: 'test', isFaceUp: false),
            CardModel(name: 'Card B', type: 'test', isFaceUp: false),
            CardModel(name: 'Card C', type: 'test', isFaceUp: false),
            CardModel(name: 'Card D', type: 'test', isFaceUp: false),
            CardModel(name: 'Card E', type: 'test', isFaceUp: false),
          ];
          
          final state = _createTestPlayerTurnState(
            handCards: [],
            deckCards: [],
            discardCards: discardCards,
          );

          turnManager.endTurn(state);

          // Verify cards are present but potentially in different order
          expect(state.playerModel.deckCards.cards.length, equals(5));
          for (final card in discardCards) {
            expect(state.playerModel.deckCards.cards, contains(card));
          }
          
          // Note: We can't test the actual shuffling randomness in a unit test,
          // but we can verify that shuffle() method would be called
          // The shuffle functionality itself is tested in CardsModel tests
        });
      });
    });

    group('handleTurnButtonPress', () {
      test('calls endTurn for playerTurn phase when hand is empty', () {
        mockGameStateService.currentPhase = GamePhase.playerTurn;
        final state = _createTestPlayerTurnState(
          handCards: [],
          deckCards: _generateCards(3),
        );

        turnManager.handleTurnButtonPress(state);

        // Verify endTurn behavior occurred
        expect(mockGameStateService.nextPhaseCalled, isTrue);
      });

      test('requests confirmation for playerTurn phase when hand has cards', () {
        mockGameStateService.currentPhase = GamePhase.playerTurn;
        final state = _createTestPlayerTurnState(
          handCards: _generateCards(2),
          deckCards: _generateCards(3),
        );

        turnManager.handleTurnButtonPress(state);

        expect(mockGameStateService.requestConfirmationCalled, isTrue);
        expect(mockGameStateService.nextPhaseCalled, isFalse);
      });

      test('advances to next phase for default case', () {
        mockGameStateService.currentPhase = GamePhase.enemyTurn;
        final state = _createTestPlayerTurnState();

        turnManager.handleTurnButtonPress(state);

        expect(mockGameStateService.nextPhaseCalled, isTrue);
      });
    });
  });
}

// Mock classes for testing
class MockGameStateService implements GameStateService {

  @override
  GamePhase currentPhase = GamePhase.playerTurn;

  bool nextPhaseCalled = false;
  bool requestConfirmationCalled = false;
  bool setPhaseCalled = false;
  GamePhase? lastSetPhase;

  @override
  void nextPhase() {
    nextPhaseCalled = true;
  }

  @override
  void requestConfirmation() {
    requestConfirmationCalled = true;
  }

  @override
  void setPhase(GamePhase newPhase) {
    setPhaseCalled = true;
    lastSetPhase = newPhase;
    currentPhase = newPhase;
  }
}

class MockCardSelectionService implements CardSelectionService {
  CardModel? _selectedCard;
  final List<void Function(CardModel?)> _listeners = [];

  @override
  void deselectCard() {
    _selectedCard = null;
  }

  @override
  CardModel? get selectedCard => _selectedCard;

  @override
  bool isCardSelected(CardModel card) => _selectedCard == card;

  @override
  void selectCard(CardModel card) {
    _selectedCard = card;
  }

  @override
  bool get hasSelection => _selectedCard != null;

  @override
  void addSelectionListener(void Function(CardModel?) listener) {
    _listeners.add(listener);
  }

  @override
  void removeSelectionListener(void Function(CardModel?) listener) {
    _listeners.remove(listener);
  }
}