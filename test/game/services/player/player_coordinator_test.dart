import 'package:card_battler/game/models/shared/health_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:card_battler/game/services/player/player_coordinator.dart';
import 'package:card_battler/game/models/player/player_model.dart';
import 'package:card_battler/game/models/player/info_model.dart';
import 'package:card_battler/game/models/shared/cards_model.dart';
import 'package:card_battler/game/models/shared/value_image_label_model.dart';
import 'package:card_battler/game/models/shared/card_model.dart';
import 'package:card_battler/game/services/game_state/game_state_manager.dart';
import 'package:card_battler/game/models/game_state_model.dart';
import 'package:card_battler/game/services/game_state/game_state_service.dart';
import 'package:card_battler/game/services/card/card_selection_service.dart';

List<CardModel> _generateCards(int count) {
  return List.generate(count, (index) => CardModel(
    name: 'Card ${index + 1}',
    type: 'test',
    isFaceUp: false,
  ));
}

void main() {
  group('PlayerCoordinator', () {
    late InfoModel testInfoModel;
    late CardsModel<CardModel> testHandModel;
    late CardsModel<CardModel> testDeckModel;
    late CardsModel<CardModel> testDiscardModel;
    late GameStateService gameStateService;
    late CardSelectionService cardSelectionService;

    setUp(() {
      testInfoModel = InfoModel(
        attack: ValueImageLabelModel(value: 50, label: 'Attack'),
        credits: ValueImageLabelModel(value: 25, label: 'Credits'),
        healthModel: HealthModel(maxHealth: 100),
        name: 'TestPlayer',
      );
      testHandModel = CardsModel<CardModel>();
      testDeckModel = CardsModel<CardModel>(cards: _generateCards(20));
      testDiscardModel = CardsModel<CardModel>.empty();
      
      // Create service instances for testing
      final gameStateManager = GameStateManager();
      gameStateManager.reset(); // Start in a known state
      gameStateService = DefaultGameStateService(gameStateManager);
      cardSelectionService = DefaultCardSelectionService();
    });

    group('constructor and initialization', () {
      test('creates with required parameters', () {
        final playerModel = PlayerCoordinator.create(
          state: PlayerModel.create(
            infoModel: testInfoModel,
            handModel: testHandModel,
            deckModel: testDeckModel,
            discardModel: testDiscardModel,
            gameStateService: gameStateService,
            cardSelectionService: cardSelectionService,
          ),
        );

        expect(playerModel.infoModel, equals(testInfoModel));
        expect(playerModel.handCards, equals(testHandModel));
        expect(playerModel.deckCards, equals(testDeckModel));
        expect(playerModel.discardCards, equals(testDiscardModel));
      });
    });

    group('property getters', () {
      test('infoModel getter returns correct InfoModel', () {
        final playerModel = PlayerCoordinator.create(
          state: PlayerModel.create(
            infoModel: testInfoModel,
            handModel: testHandModel,
            deckModel: testDeckModel,
            discardModel: testDiscardModel,
            gameStateService: gameStateService,
            cardSelectionService: cardSelectionService,
          ),
        );

        expect(playerModel.infoModel, isA<InfoModel>());
        expect(playerModel.infoModel, equals(testInfoModel));
        expect(playerModel.infoModel.healthModel.healthDisplay, equals('100/100'));
        expect(playerModel.infoModel.attack.display, equals('Attack: 50'));
        expect(playerModel.infoModel.credits.display, equals('Credits: 25'));
      });

      test('handModel getter returns correct CardsModel<CardModel>', () {
        final playerModel = PlayerCoordinator.create(
          state: PlayerModel.create(
            infoModel: testInfoModel,
            handModel: testHandModel,
            deckModel: testDeckModel,
            discardModel: testDiscardModel,
            gameStateService: gameStateService,
            cardSelectionService: cardSelectionService,
          ),
        );

        expect(playerModel.handCards, isA<CardsModel<CardModel>>());
        expect(playerModel.handCards, equals(testHandModel));
        expect(playerModel.handCards.cards.isEmpty, isTrue);
      });

      test('deckModel getter returns correct CardsModel<CardModel>', () {
        final playerModel = PlayerCoordinator.create(
          state: PlayerModel.create(
            infoModel: testInfoModel,
            handModel: testHandModel,
            deckModel: testDeckModel,
            discardModel: testDiscardModel,
            gameStateService: gameStateService,
            cardSelectionService: cardSelectionService,
          ),
        );

        expect(playerModel.deckCards, isA<CardsModel<CardModel>>());
        expect(playerModel.deckCards, equals(testDeckModel));
        expect(playerModel.deckCards.allCards.length, equals(20));
        expect(playerModel.deckCards.hasNoCards, isFalse);
      });

      test('discardModel getter returns correct CardsModel<CardModel>', () {
        final playerModel = PlayerCoordinator.create(
          state: PlayerModel.create(
            infoModel: testInfoModel,
            handModel: testHandModel,
            deckModel: testDeckModel,
            discardModel: testDiscardModel,
            gameStateService: gameStateService,
            cardSelectionService: cardSelectionService,
          ),
        );

        expect(playerModel.discardCards, isA<CardsModel<CardModel>>());
        expect(playerModel.discardCards, equals(testDiscardModel));
        expect(playerModel.discardCards.allCards.isEmpty, isTrue);
        expect(playerModel.discardCards.hasNoCards, isTrue);
      });
    });

    group('drawCardsFromDeck functionality', () {
      test('draws 5 cards from deck when enough cards available', () {
        final playerModel = PlayerCoordinator.create(
          state: PlayerModel.create(
            infoModel: testInfoModel,
            handModel: testHandModel,
            deckModel: testDeckModel,
            discardModel: testDiscardModel,
            gameStateService: gameStateService,
            cardSelectionService: cardSelectionService,
          ),
        );

        expect(playerModel.handCards.cards.length, equals(0));
        expect(playerModel.deckCards.allCards.length, equals(20));

        playerModel.drawCardsFromDeck(5);

        expect(playerModel.handCards.cards.length, equals(5));
        expect(playerModel.deckCards.allCards.length, equals(15));
      });

      test('reshuffles discard pile when deck has insufficient cards', () {
        // Create a deck with only 3 cards
        final smallDeckModel = CardsModel<CardModel>(cards: _generateCards(3));
        // Add some cards to discard pile
        final discardCards = _generateCards(5);
        testDiscardModel.addCards(discardCards);

        final playerModel = PlayerCoordinator.create(
          state: PlayerModel.create(
            infoModel: testInfoModel,
            handModel: testHandModel,
            deckModel: smallDeckModel,
            discardModel: testDiscardModel,
            gameStateService: gameStateService,
            cardSelectionService: cardSelectionService,
          ),
        );

        expect(playerModel.deckCards.allCards.length, equals(3));
        expect(playerModel.discardCards.allCards.length, equals(5));
        expect(playerModel.handCards.cards.length, equals(0));

        playerModel.drawCardsFromDeck(5);

        // Should still draw 5 cards total
        expect(playerModel.handCards.cards.length, equals(5));
        // Discard pile should be empty (moved to deck)
        expect(playerModel.discardCards.allCards.length, equals(0));
        // Remaining cards in deck should be 3 (original 3 + 5 from discard - 5 drawn)
        expect(playerModel.deckCards.allCards.length, equals(3));
      });

      test('does not draw cards when card selection service has selection', () {
        final playerModel = PlayerCoordinator.create(
          state: PlayerModel.create(
            infoModel: testInfoModel,
            handModel: testHandModel,
            deckModel: testDeckModel,
            discardModel: testDiscardModel,
            gameStateService: gameStateService,
            cardSelectionService: cardSelectionService,
          ),
        );

        // Simulate card selection service having a selection
        cardSelectionService.selectCard(CardModel(name: 'Selected Card', type: 'test'));
        expect(cardSelectionService.hasSelection, isTrue);

        playerModel.drawCardsFromDeck(5);

        // No cards should be drawn
        expect(playerModel.handCards.cards.length, equals(0));
      });

      test('does not draw cards when hand is not empty', () {
        final playerModel = PlayerCoordinator.create(
          state: PlayerModel.create(
            infoModel: testInfoModel,
            handModel: testHandModel,
            deckModel: testDeckModel,
            discardModel: testDiscardModel,
            gameStateService: gameStateService,
            cardSelectionService: cardSelectionService,
          ),
        );

        // Add a card to hand first
        testHandModel.addCards([CardModel(name: 'Existing Card', type: 'test')]);
        expect(playerModel.handCards.cards.length, equals(1));

        playerModel.drawCardsFromDeck(5);

        // Should still have only 1 card (no additional cards drawn)
        expect(playerModel.handCards.cards.length, equals(1));
      });

      test('sets onCardPlayed callback on drawn cards', () {
        final playerModel = PlayerCoordinator.create(
          state: PlayerModel.create(
            infoModel: testInfoModel,
            handModel: testHandModel,
            deckModel: testDeckModel,
            discardModel: testDiscardModel,
            gameStateService: gameStateService,
            cardSelectionService: cardSelectionService,
          ),
        );

        playerModel.drawCardsFromDeck(5);

        for (final card in playerModel.handCards.cards) {
          expect(card.onCardPlayed, isNotNull);
        }
      });

      test('calls GameStateService.nextPhase() after drawing cards', () {
        final playerModel = PlayerCoordinator.create(
          state: PlayerModel.create(
            infoModel: testInfoModel,
            handModel: testHandModel,
            deckModel: testDeckModel,
            discardModel: testDiscardModel,
            gameStateService: gameStateService,
            cardSelectionService: cardSelectionService,
          ),
        );

        // Verify initial state
        expect(gameStateService.currentPhase, equals(GamePhase.waitingToDrawCards));

        // Draw cards should trigger phase advancement
        playerModel.drawCardsFromDeck(5);

        // Should now be in cardsDrawn phase
        expect(gameStateService.currentPhase, equals(GamePhase.cardsDrawnWaitingForEnemyTurn));
      });

      test('does not call GameStateService.nextPhase() when drawing is prevented', () {
        final playerModel = PlayerCoordinator.create(
          state: PlayerModel.create(
            infoModel: testInfoModel,
            handModel: testHandModel,
            deckModel: testDeckModel,
            discardModel: testDiscardModel,
            gameStateService: gameStateService,
            cardSelectionService: cardSelectionService,
          ),
        );

        // Add a card to hand to prevent drawing
        testHandModel.addCards([CardModel(name: 'Existing Card', type: 'test')]);

        // Verify initial state
        expect(gameStateService.currentPhase, equals(GamePhase.waitingToDrawCards));

        playerModel.drawCardsFromDeck(5);

        // Phase should not advance when drawing is prevented by existing cards
        expect(gameStateService.currentPhase, equals(GamePhase.waitingToDrawCards));
      });

      test('drawn cards trigger cardPlayed callback when played', () {
        final playerModel = PlayerCoordinator.create(
          state: PlayerModel.create(
            infoModel: testInfoModel,
            handModel: testHandModel,
            deckModel: testDeckModel,
            discardModel: testDiscardModel,
            gameStateService: gameStateService,
            cardSelectionService: cardSelectionService,
          ),
        );

        CardModel? playedCard;
        playerModel.cardPlayed = (card) => playedCard = card;

        playerModel.drawCardsFromDeck(5);
        
        final drawnCard = playerModel.handCards.cards.first;
        drawnCard.onCardPlayed?.call();

        expect(playedCard, equals(drawnCard));
      });

      test('onCardPlayed callback is cleared after card is played', () {
        final playerModel = PlayerCoordinator.create(
          state: PlayerModel.create(
            infoModel: testInfoModel,
            handModel: testHandModel,
            deckModel: testDeckModel,
            discardModel: testDiscardModel,
            gameStateService: gameStateService,
            cardSelectionService: cardSelectionService,
          ),
        );

        playerModel.drawCardsFromDeck(5);
        
        final drawnCard = playerModel.handCards.cards.first;
        expect(drawnCard.onCardPlayed, isNotNull);

        playerModel.cardPlayed = (card) {};
        drawnCard.onCardPlayed?.call();

        expect(drawnCard.onCardPlayed, isNull);
      });
    });

    group('discardHand functionality', () {
      test('moves all hand cards to discard pile and clears hand', () {
        final playerModel = PlayerCoordinator.create(
          state: PlayerModel.create(
            infoModel: testInfoModel,
            handModel: testHandModel,
            deckModel: testDeckModel,
            discardModel: testDiscardModel,
            gameStateService: gameStateService,
            cardSelectionService: cardSelectionService,
          ),
        );

        // Add some cards to hand
        final handCards = _generateCards(3);
        testHandModel.addCards(handCards);
        expect(playerModel.handCards.cards.length, equals(3));
        expect(playerModel.discardCards.allCards.length, equals(0));

        // Discard hand
        playerModel.discardHand();

        // Hand should be empty, discard should have the cards
        expect(playerModel.handCards.cards.length, equals(0));
        expect(playerModel.discardCards.allCards.length, equals(3));
      });

      test('sets all hand cards to face down before discarding', () {
        final playerModel = PlayerCoordinator.create(
          state: PlayerModel.create(
            infoModel: testInfoModel,
            handModel: testHandModel,
            deckModel: testDeckModel,
            discardModel: testDiscardModel,
            gameStateService: gameStateService,
            cardSelectionService: cardSelectionService,
          ),
        );

        // Add face-up cards to hand
        final handCards = _generateCards(3);
        for (final card in handCards) {
          card.isFaceUp = true;
        }
        testHandModel.addCards(handCards);

        // Discard hand
        playerModel.discardHand();

        // All cards in discard should be face down
        for (final card in playerModel.discardCards.allCards) {
          expect(card.isFaceUp, isFalse);
        }
      });

      test('handles empty hand gracefully', () {
        final playerModel = PlayerCoordinator.create(
          state: PlayerModel.create(
            infoModel: testInfoModel,
            handModel: testHandModel,
            deckModel: testDeckModel,
            discardModel: testDiscardModel,
            gameStateService: gameStateService,
            cardSelectionService: cardSelectionService,
          ),
        );

        // Initially empty hand
        expect(playerModel.handCards.cards.length, equals(0));
        expect(playerModel.discardCards.allCards.length, equals(0));

        // Should not throw
        expect(() => playerModel.discardHand(), returnsNormally);

        // Both should still be empty
        expect(playerModel.handCards.cards.length, equals(0));
        expect(playerModel.discardCards.allCards.length, equals(0));
      });
    });

    group('moveDiscardCardsToDeck functionality', () {
      test('moves all discard cards to deck and shuffles', () {
        final playerModel = PlayerCoordinator.create(
          state: PlayerModel.create(
            infoModel: testInfoModel,
            handModel: testHandModel,
            deckModel: testDeckModel,
            discardModel: testDiscardModel,
            gameStateService: gameStateService,
            cardSelectionService: cardSelectionService,
          ),
        );

        // Add cards to discard pile
        final discardCards = _generateCards(5);
        testDiscardModel.addCards(discardCards);
        final originalDeckSize = playerModel.deckCards.allCards.length;
        
        expect(playerModel.discardCards.allCards.length, equals(5));
        expect(playerModel.deckCards.allCards.length, equals(originalDeckSize));

        // Move discard to deck
        playerModel.moveDiscardCardsToDeck();

        // Discard should be empty, deck should have more cards
        expect(playerModel.discardCards.allCards.length, equals(0));
        expect(playerModel.deckCards.allCards.length, equals(originalDeckSize + 5));
        expect(playerModel.discardCards.hasNoCards, isTrue);
      });

      test('returns early when discard pile is empty', () {
        final playerModel = PlayerCoordinator.create(
          state: PlayerModel.create(
            infoModel: testInfoModel,
            handModel: testHandModel,
            deckModel: testDeckModel,
            discardModel: testDiscardModel,
            gameStateService: gameStateService,
            cardSelectionService: cardSelectionService,
          ),
        );

        final originalDeckSize = playerModel.deckCards.allCards.length;
        expect(playerModel.discardCards.hasNoCards, isTrue);

        // Should not throw and deck size should remain same
        expect(() => playerModel.moveDiscardCardsToDeck(), returnsNormally);
        expect(playerModel.deckCards.allCards.length, equals(originalDeckSize));
      });

      test('shuffles deck after adding discard cards', () {
        final playerModel = PlayerCoordinator.create(
          state: PlayerModel.create(
            infoModel: testInfoModel,
            handModel: testHandModel,
            deckModel: testDeckModel,
            discardModel: testDiscardModel,
            gameStateService: gameStateService,
            cardSelectionService: cardSelectionService,
          ),
        );

        // Add cards to discard pile with known order
        final discardCards = [
          CardModel(name: 'Discard 1', type: 'test'),
          CardModel(name: 'Discard 2', type: 'test'),
          CardModel(name: 'Discard 3', type: 'test'),
        ];
        testDiscardModel.addCards(discardCards);

        // Move discard to deck
        playerModel.moveDiscardCardsToDeck();

        // Check that deck was shuffled (cards are still there but order may be different)
        final deckCards = playerModel.deckCards.allCards;
        expect(deckCards.any((card) => card.name == 'Discard 1'), isTrue);
        expect(deckCards.any((card) => card.name == 'Discard 2'), isTrue);
        expect(deckCards.any((card) => card.name == 'Discard 3'), isTrue);
      });
    });

    group('cardPlayed callback functionality', () {
      test('cardPlayed callback can be set and called', () {
        final playerModel = PlayerCoordinator.create(
          state: PlayerModel.create(
            infoModel: testInfoModel,
            handModel: testHandModel,
            deckModel: testDeckModel,
            discardModel: testDiscardModel,
            gameStateService: gameStateService,
            cardSelectionService: cardSelectionService,
          ),
        );

        CardModel? receivedCard;
        playerModel.cardPlayed = (card) => receivedCard = card;

        final testCard = CardModel(name: 'Test Card', type: 'test');
        playerModel.cardPlayed?.call(testCard);

        expect(receivedCard, equals(testCard));
      });

      test('multiple cards can be played through callback', () {
        final playerModel = PlayerCoordinator.create(
          state: PlayerModel.create(
            infoModel: testInfoModel,
            handModel: testHandModel,
            deckModel: testDeckModel,
            discardModel: testDiscardModel,
            gameStateService: gameStateService,
            cardSelectionService: cardSelectionService,
          ),
        );

        final playedCards = <CardModel>[];
        playerModel.cardPlayed = (card) => playedCards.add(card);

        final card1 = CardModel(name: 'Card 1', type: 'test');
        final card2 = CardModel(name: 'Card 2', type: 'test');

        playerModel.cardPlayed?.call(card1);
        playerModel.cardPlayed?.call(card2);

        expect(playedCards.length, equals(2));
        expect(playedCards, containsAll([card1, card2]));
      });
    });
  });
}
