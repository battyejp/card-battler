import 'package:card_battler/game/models/shared/health_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:card_battler/game/models/player/player_model.dart';
import 'package:card_battler/game/models/player/info_model.dart';
import 'package:card_battler/game/models/shared/cards_model.dart';
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
  group('PlayerModel', () {
    late InfoModel testInfoModel;
    late CardsModel<CardModel> testHandModel;
    late CardPileModel testDeckModel;
    late CardPileModel testDiscardModel;
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
      testDeckModel = CardPileModel(cards: _generateCards(20));
      testDiscardModel = CardPileModel.empty();
      
      // Create service instances for testing
      final gameStateManager = GameStateManager();
      gameStateManager.reset(); // Start in a known state
      gameStateService = DefaultGameStateService(gameStateManager);
      cardSelectionService = DefaultCardSelectionService();
    });

    group('constructor and initialization', () {
      test('creates with required parameters', () {
        final playerModel = PlayerModel(
          infoModel: testInfoModel,
          handModel: testHandModel,
          deckModel: testDeckModel,
          discardModel: testDiscardModel,
          gameStateService: gameStateService,
          cardSelectionService: cardSelectionService,
        );

        expect(playerModel.infoModel, equals(testInfoModel));
        expect(playerModel.handCards, equals(testHandModel));
        expect(playerModel.deckCards, equals(testDeckModel));
        expect(playerModel.discardCards, equals(testDiscardModel));
      });
    });

    group('property getters', () {
      test('infoModel getter returns correct InfoModel', () {
        final playerModel = PlayerModel(
          infoModel: testInfoModel,
          handModel: testHandModel,
          deckModel: testDeckModel,
          discardModel: testDiscardModel,
          gameStateService: gameStateService,
          cardSelectionService: cardSelectionService,
        );

        expect(playerModel.infoModel, isA<InfoModel>());
        expect(playerModel.infoModel, equals(testInfoModel));
        expect(playerModel.infoModel.healthModel.healthDisplay, equals('100/100'));
        expect(playerModel.infoModel.attack.display, equals('Attack: 50'));
        expect(playerModel.infoModel.credits.display, equals('Credits: 25'));
      });

      test('handModel getter returns correct CardsModel<CardModel>', () {
        final playerModel = PlayerModel(
          infoModel: testInfoModel,
          handModel: testHandModel,
          deckModel: testDeckModel,
          discardModel: testDiscardModel,
          gameStateService: gameStateService,
          cardSelectionService: cardSelectionService,
        );

        expect(playerModel.handCards, isA<CardsModel<CardModel>>());
        expect(playerModel.handCards, equals(testHandModel));
        expect(playerModel.handCards.cards.isEmpty, isTrue);
      });

      test('deckModel getter returns correct CardPileModel', () {
        final playerModel = PlayerModel(
          infoModel: testInfoModel,
          handModel: testHandModel,
          deckModel: testDeckModel,
          discardModel: testDiscardModel,
          gameStateService: gameStateService,
          cardSelectionService: cardSelectionService,
        );

        expect(playerModel.deckCards, isA<CardPileModel>());
        expect(playerModel.deckCards, equals(testDeckModel));
        expect(playerModel.deckCards.allCards.length, equals(20));
        expect(playerModel.deckCards.hasNoCards, isFalse);
      });

      test('discardModel getter returns correct CardPileModel', () {
        final playerModel = PlayerModel(
          infoModel: testInfoModel,
          handModel: testHandModel,
          deckModel: testDeckModel,
          discardModel: testDiscardModel,
          gameStateService: gameStateService,
          cardSelectionService: cardSelectionService,
        );

        expect(playerModel.discardCards, isA<CardPileModel>());
        expect(playerModel.discardCards, equals(testDiscardModel));
        expect(playerModel.discardCards.allCards.isEmpty, isTrue);
        expect(playerModel.discardCards.hasNoCards, isTrue);
      });
    });

    group('drawCardsFromDeck functionality', () {
      test('sets onCardPlayed callback on drawn cards', () {
        final playerModel = PlayerModel(
          infoModel: testInfoModel,
          handModel: testHandModel,
          deckModel: testDeckModel,
          discardModel: testDiscardModel,
          gameStateService: gameStateService,
          cardSelectionService: cardSelectionService,
        );

        playerModel.drawCardsFromDeck();

        for (final card in playerModel.handCards.cards) {
          expect(card.onCardPlayed, isNotNull);
        }
      });

      test('calls GameStateService.nextPhase() after drawing cards', () {
        final playerModel = PlayerModel(
          infoModel: testInfoModel,
          handModel: testHandModel,
          deckModel: testDeckModel,
          discardModel: testDiscardModel,
          gameStateService: gameStateService,
          cardSelectionService: cardSelectionService,
        );

        // Verify initial state
        expect(gameStateService.currentPhase, equals(GamePhase.waitingToDrawCards));

        // Draw cards should trigger phase advancement
        playerModel.drawCardsFromDeck();

        // Should now be in cardsDrawn phase
        expect(gameStateService.currentPhase, equals(GamePhase.cardsDrawnWaitingForEnemyTurn));
      });

      test('drawn cards trigger cardPlayed callback when played', () {
        final playerModel = PlayerModel(
          infoModel: testInfoModel,
          handModel: testHandModel,
          deckModel: testDeckModel,
          discardModel: testDiscardModel,
          gameStateService: gameStateService,
          cardSelectionService: cardSelectionService,
        );

        CardModel? playedCard;
        playerModel.cardPlayed = (card) => playedCard = card;

        playerModel.drawCardsFromDeck();
        
        final drawnCard = playerModel.handCards.cards.first;
        drawnCard.onCardPlayed?.call();

        expect(playedCard, equals(drawnCard));
      });

      test('onCardPlayed callback is cleared after card is played', () {
        final playerModel = PlayerModel(
          infoModel: testInfoModel,
          handModel: testHandModel,
          deckModel: testDeckModel,
          discardModel: testDiscardModel,
          gameStateService: gameStateService,
          cardSelectionService: cardSelectionService,
        );

        playerModel.drawCardsFromDeck();
        
        final drawnCard = playerModel.handCards.cards.first;
        expect(drawnCard.onCardPlayed, isNotNull);

        playerModel.cardPlayed = (card) {};
        drawnCard.onCardPlayed?.call();

        expect(drawnCard.onCardPlayed, isNull);
      });
    });

    group('cardPlayed callback functionality', () {
      test('cardPlayed callback can be set and called', () {
        final playerModel = PlayerModel(
          infoModel: testInfoModel,
          handModel: testHandModel,
          deckModel: testDeckModel,
          discardModel: testDiscardModel,
          gameStateService: gameStateService,
          cardSelectionService: cardSelectionService,
        );

        CardModel? receivedCard;
        playerModel.cardPlayed = (card) => receivedCard = card;

        final testCard = CardModel(name: 'Test Card', type: 'test');
        playerModel.cardPlayed?.call(testCard);

        expect(receivedCard, equals(testCard));
      });

      test('multiple cards can be played through callback', () {
        final playerModel = PlayerModel(
          infoModel: testInfoModel,
          handModel: testHandModel,
          deckModel: testDeckModel,
          discardModel: testDiscardModel,
          gameStateService: gameStateService,
          cardSelectionService: cardSelectionService,
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
