import 'package:card_battler/game/models/shared/health_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:card_battler/game/models/player/player_model.dart';
import 'package:card_battler/game/models/player/info_model.dart';
import 'package:card_battler/game/models/player/card_hand_model.dart';
import 'package:card_battler/game/models/shared/card_pile_model.dart';
import 'package:card_battler/game/models/shared/value_image_label_model.dart';
import 'package:card_battler/game/models/shared/card_model.dart';
import 'package:card_battler/game/services/game_state_manager.dart';
import 'package:card_battler/game/models/game_state_model.dart';
import 'package:card_battler/game/services/game_state_service.dart';
import 'package:card_battler/game/services/card_selection_service.dart';
import 'package:card_battler/game/services/player_action_service.dart';

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
    late CardHandModel testHandModel;
    late CardPileModel testDeckModel;
    late CardPileModel testDiscardModel;
    late GameStateService gameStateService;
    late CardSelectionService cardSelectionService;
    late PlayerActionService playerActionService;

    setUp(() {
      testInfoModel = InfoModel(
        attack: ValueImageLabelModel(value: 50, label: 'Attack'),
        credits: ValueImageLabelModel(value: 25, label: 'Credits'),
        healthModel: HealthModel(maxHealth: 100),
        name: 'TestPlayer',
      );
      testHandModel = CardHandModel();
      testDeckModel = CardPileModel(cards: _generateCards(20));
      testDiscardModel = CardPileModel.empty();
      
      // Create service instances for testing
      final gameStateManager = GameStateManager();
      gameStateManager.reset(); // Start in a known state
      gameStateService = DefaultGameStateService(gameStateManager);
      cardSelectionService = DefaultCardSelectionService();
      playerActionService = PlayerActionService(
        gameStateService: gameStateService,
        cardSelectionService: cardSelectionService,
      );
    });

    group('constructor and initialization', () {
      test('creates with required parameters', () {
        final playerModel = PlayerModel(
          infoModel: testInfoModel,
          handModel: testHandModel,
          deckModel: testDeckModel,
          discardModel: testDiscardModel,
        );

        expect(playerModel.infoModel, equals(testInfoModel));
        expect(playerModel.handModel, equals(testHandModel));
        expect(playerModel.deckModel, equals(testDeckModel));
        expect(playerModel.discardModel, equals(testDiscardModel));
      });
    });

    group('property getters', () {
      test('infoModel getter returns correct InfoModel', () {
        final playerModel = PlayerModel(
          infoModel: testInfoModel,
          handModel: testHandModel,
          deckModel: testDeckModel,
          discardModel: testDiscardModel,
        );

        expect(playerModel.infoModel, isA<InfoModel>());
        expect(playerModel.infoModel, equals(testInfoModel));
        expect(playerModel.infoModel.healthModel.healthDisplay, equals('100/100'));
        expect(playerModel.infoModel.attack.display, equals('Attack: 50'));
        expect(playerModel.infoModel.credits.display, equals('Credits: 25'));
      });

      test('handModel getter returns correct CardHandModel', () {
        final playerModel = PlayerModel(
          infoModel: testInfoModel,
          handModel: testHandModel,
          deckModel: testDeckModel,
          discardModel: testDiscardModel,
        );

        expect(playerModel.handModel, isA<CardHandModel>());
        expect(playerModel.handModel, equals(testHandModel));
        expect(playerModel.handModel.cards.isEmpty, isTrue);
      });

      test('deckModel getter returns correct CardPileModel', () {
        final playerModel = PlayerModel(
          infoModel: testInfoModel,
          handModel: testHandModel,
          deckModel: testDeckModel,
          discardModel: testDiscardModel,
        );

        expect(playerModel.deckModel, isA<CardPileModel>());
        expect(playerModel.deckModel, equals(testDeckModel));
        expect(playerModel.deckModel.allCards.length, equals(20));
        expect(playerModel.deckModel.hasNoCards, isFalse);
      });

      test('discardModel getter returns correct CardPileModel', () {
        final playerModel = PlayerModel(
          infoModel: testInfoModel,
          handModel: testHandModel,
          deckModel: testDeckModel,
          discardModel: testDiscardModel,
        );

        expect(playerModel.discardModel, isA<CardPileModel>());
        expect(playerModel.discardModel, equals(testDiscardModel));
        expect(playerModel.discardModel.allCards.isEmpty, isTrue);
        expect(playerModel.discardModel.hasNoCards, isTrue);
      });
    });

    group('PlayerActionService integration', () {
      test('drawCardsFromDeck sets onCardPlayed callback on drawn cards', () {
        final playerModel = PlayerModel(
          infoModel: testInfoModel,
          handModel: testHandModel,
          deckModel: testDeckModel,
          discardModel: testDiscardModel,
        );

        playerActionService.drawCardsFromDeck(
          deckModel: playerModel.deckModel,
          handModel: playerModel.handModel,
          cardsToDraw: PlayerModel.cardsToDrawOnTap,
          onCardPlayed: (card) {},
        );

        for (final card in playerModel.handModel.cards) {
          expect(card.onCardPlayed, isNotNull);
        }
      });

      test('drawCardsFromDeck calls GameStateService.nextPhase() after drawing cards', () {
        final playerModel = PlayerModel(
          infoModel: testInfoModel,
          handModel: testHandModel,
          deckModel: testDeckModel,
          discardModel: testDiscardModel,
        );

        // Verify initial state
        expect(gameStateService.currentPhase, equals(GamePhase.waitingToDrawCards));

        // Draw cards should trigger phase advancement
        playerActionService.drawCardsFromDeck(
          deckModel: playerModel.deckModel,
          handModel: playerModel.handModel,
          cardsToDraw: PlayerModel.cardsToDrawOnTap,
          onCardPlayed: (card) {},
        );

        // Should now be in cardsDrawn phase
        expect(gameStateService.currentPhase, equals(GamePhase.cardsDrawnWaitingForEnemyTurn));
      });

      test('drawn cards trigger cardPlayed callback when played', () {
        final playerModel = PlayerModel(
          infoModel: testInfoModel,
          handModel: testHandModel,
          deckModel: testDeckModel,
          discardModel: testDiscardModel,
        );

        CardModel? playedCard;
        
        playerActionService.drawCardsFromDeck(
          deckModel: playerModel.deckModel,
          handModel: playerModel.handModel,
          cardsToDraw: PlayerModel.cardsToDrawOnTap,
          onCardPlayed: (card) => playedCard = card,
        );
        
        final drawnCard = playerModel.handModel.cards.first;
        drawnCard.onCardPlayed?.call();

        expect(playedCard, equals(drawnCard));
      });

      test('handleCardPlayed clears callback after card is played', () {
        final playerModel = PlayerModel(
          infoModel: testInfoModel,
          handModel: testHandModel,
          deckModel: testDeckModel,
          discardModel: testDiscardModel,
        );

        playerActionService.drawCardsFromDeck(
          deckModel: playerModel.deckModel,
          handModel: playerModel.handModel,
          cardsToDraw: PlayerModel.cardsToDrawOnTap,
          onCardPlayed: (card) {},
        );
        
        final drawnCard = playerModel.handModel.cards.first;
        expect(drawnCard.onCardPlayed, isNotNull);

        CardModel? receivedCard;
        playerActionService.handleCardPlayed(drawnCard, (card) => receivedCard = card);

        expect(drawnCard.onCardPlayed, isNull);
        expect(receivedCard, equals(drawnCard));
      });
    });

    group('cardPlayed callback functionality', () {
      test('cardPlayed callback can be set and called', () {
        final playerModel = PlayerModel(
          infoModel: testInfoModel,
          handModel: testHandModel,
          deckModel: testDeckModel,
          discardModel: testDiscardModel,
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
