import 'package:card_battler/game/components/player/card_pile.dart';
import 'package:card_battler/game/components/player/card_deck.dart';
import 'package:card_battler/game/components/shared/card.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:card_battler/game/components/player/player.dart';
import 'package:card_battler/game/components/player/card_hand.dart';
import 'package:card_battler/game/components/player/info.dart';
import 'package:card_battler/game/models/player/info_model.dart';
import 'package:card_battler/game/models/player/card_hand_model.dart';
import 'package:card_battler/game/models/player/card_pile_model.dart';
import 'package:card_battler/game/models/player/player_model.dart';
import 'package:card_battler/game/models/shared/value_image_label_model.dart';
import 'package:card_battler/game/models/shared/card_model.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flame/components.dart';

List<CardModel> _generateCards(int count) {
  return List.generate(count, (index) => CardModel(
    name: 'Card $index',
    type: 'test',
    isFaceUp: false,
  ));
}

void main() {
  group('Player', () {
    Player createTestPlayer() {
      final infoModel = InfoModel(
        health: ValueImageLabelModel(value: 100, label: 'Health'),
        attack: ValueImageLabelModel(value: 50, label: 'Attack'),
        credits: ValueImageLabelModel(value: 25, label: 'Credits'),
      );
      final handModel = CardHandModel();
      final deckModel = CardPileModel(cards: _generateCards(20));
      final discardModel = CardPileModel.empty();
      
      final playerModel = PlayerModel(
        infoModel: infoModel,
        handModel: handModel,
        deckModel: deckModel,
        discardModel: discardModel,
      );
      
      return Player(
        playerModel: playerModel,
      );
    }
    group('layout and positioning', () {
      final testCases = [
        {
          'size': Vector2(300, 100),
          'deck': {'size': Vector2(60, 100), 'pos': Vector2(0, 0)},
          'info': {'size': Vector2(180, 10), 'pos': Vector2(60, 0)},
          'hand': {'size': Vector2(180, 90), 'pos': Vector2(60, 10)},
          'discard': {'size': Vector2(60, 100), 'pos': Vector2(240, 0)},
        },
        {
          'size': Vector2(400, 200),
          'deck': {'size': Vector2(80, 200), 'pos': Vector2(0, 0)},
          'info': {'size': Vector2(240, 20), 'pos': Vector2(80, 0)},
          'hand': {'size': Vector2(240, 180), 'pos': Vector2(80, 20)},
          'discard': {'size': Vector2(80, 200), 'pos': Vector2(320, 0)},
        },
        {
          'size': Vector2(600, 300),
          'deck': {'size': Vector2(120, 300), 'pos': Vector2(0, 0)},
          'info': {'size': Vector2(360, 30), 'pos': Vector2(120, 0)},
          'hand': {'size': Vector2(360, 270), 'pos': Vector2(120, 30)},
          'discard': {'size': Vector2(120, 300), 'pos': Vector2(480, 0)},
        },
      ];

      for (final testCase in testCases) {
        testWithFlameGame(
          'Player children sizes and positions for size ${testCase['size']}',
          (game) async {
            final player = createTestPlayer()..size = testCase['size'] as Vector2;

            await game.ensureAdd(player);

            final deck = player.children.whereType<CardDeck>().first;
            final info = player.children.whereType<Info>().first;
            final hand = player.children.whereType<CardHand>().first;
            final discard = player.children.whereType<CardPile>().where((pile) => pile is! CardDeck).first;
            
            final deckCase = testCase['deck'] as Map<String, Vector2>;
            final infoCase = testCase['info'] as Map<String, Vector2>;
            final handCase = testCase['hand'] as Map<String, Vector2>;
            final discardCase = testCase['discard'] as Map<String, Vector2>;
            
            expect(deck.size, deckCase['size']);
            expect(deck.position, deckCase['pos']);
            expect(info.size, infoCase['size']);
            expect(info.position, infoCase['pos']);
            expect(hand.size, handCase['size']);
            expect(hand.position, handCase['pos']);
            expect(discard.size, discardCase['size']);
            expect(discard.position, discardCase['pos']);
            
            // Verify we have exactly 1 CardDeck, 1 Info, 1 CardHand, and 1 CardPile (discard)
            expect(player.children.whereType<CardDeck>().length, 1);
            expect(player.children.whereType<Info>().length, 1);
            expect(player.children.whereType<CardHand>().length, 1);
            expect(player.children.whereType<CardPile>().length, 2); // CardDeck + discard pile
          },
        );
      }

      testWithFlameGame('layout factors are applied correctly', (game) async {
        final player = createTestPlayer()..size = Vector2(500, 250);

        await game.ensureAdd(player);

        final deck = player.children.whereType<CardDeck>().first;
        final info = player.children.whereType<Info>().first;
        final hand = player.children.whereType<CardHand>().first;
        final discard = player.children.whereType<CardPile>().where((pile) => pile is! CardDeck).first;

        expect(deck.size.x, equals(500 * Player.pileWidthFactor));
        expect(info.size.x, equals(500 * Player.handWidthFactor));
        expect(info.size.y, equals(250 * Player.infoHeightFactor));
        expect(hand.size.x, equals(500 * Player.handWidthFactor));
        expect(hand.size.y, equals(250 * (1 - Player.infoHeightFactor)));
        expect(discard.size.x, equals(500 * Player.pileWidthFactor));
      });
    });

    group('component initialization', () {
      testWithFlameGame('deck starts with 20 cards', (game) async {
        final player = createTestPlayer()..size = Vector2(600, 300);

        await game.ensureAdd(player);

        final deck = player.children.whereType<CardDeck>().first;
        
        expect(deck.model.allCards.length, equals(20));
        expect(deck.model.hasNoCards, isFalse);
      });

      testWithFlameGame('hand starts empty', (game) async {
        final player = createTestPlayer()..size = Vector2(600, 300);

        await game.ensureAdd(player);

        final hand = player.children.whereType<CardHand>().first;
        
        expect(hand.model.cards.length, equals(0));
        
        // Should display no cards initially
        final displayedCards = hand.children.whereType<Card>().toList();
        expect(displayedCards.length, equals(0));
      });

      testWithFlameGame('discard starts empty', (game) async {
        final player = createTestPlayer()..size = Vector2(600, 300);

        await game.ensureAdd(player);

        final discard = player.children.whereType<CardPile>().where((pile) => pile is! CardDeck).first;
        
        expect(discard.model.allCards.length, equals(0));
        expect(discard.model.hasNoCards, isTrue);
      });

      testWithFlameGame('deck has tap callback configured', (game) async {
        final player = createTestPlayer()..size = Vector2(600, 300);

        await game.ensureAdd(player);

        final deck = player.children.whereType<CardDeck>().first;
        
        expect(deck.onTap, isNotNull);
      });
    });

    group('deck tap functionality', () {
      testWithFlameGame('deck tap draws 5 cards to hand', (game) async {
        final player = createTestPlayer()..size = Vector2(600, 300);

        await game.ensureAdd(player);

        final deck = player.children.whereType<CardDeck>().first;
        final hand = player.children.whereType<CardHand>().first;

        // Initial state
        expect(deck.model.allCards.length, equals(20));
        expect(hand.model.cards.length, equals(0));

        // Simulate deck tap
        deck.onTap?.call();

        // Verify cards were drawn
        expect(deck.model.allCards.length, equals(15));
        expect(hand.model.cards.length, equals(5));
      });

      testWithFlameGame('deck tap updates hand display', (game) async {
        final player = createTestPlayer()..size = Vector2(600, 300);

        await game.ensureAdd(player);

        final deck = player.children.whereType<CardDeck>().first;
        final hand = player.children.whereType<CardHand>().first;

        // Initially no displayed cards
        expect(hand.children.whereType<Card>().length, equals(0));

        // Tap deck
        deck.onTap?.call();

        // Wait for the next frame to allow component updates
        await game.ready();

        // Verify hand display updated
        final displayedCards = hand.children.whereType<Card>().toList();
        expect(displayedCards.length, equals(5));
      });

      testWithFlameGame('multiple deck taps accumulate cards in hand', (game) async {
        final player = createTestPlayer()..size = Vector2(600, 300);

        await game.ensureAdd(player);

        final deck = player.children.whereType<CardDeck>().first;
        final hand = player.children.whereType<CardHand>().first;

        // First tap
        deck.onTap?.call();
        await game.ready();
        expect(deck.model.allCards.length, equals(15));
        expect(hand.model.cards.length, equals(5));
        expect(hand.children.whereType<Card>().length, equals(5));

        // Second tap
        deck.onTap?.call();
        await game.ready();
        expect(deck.model.allCards.length, equals(10));
        expect(hand.model.cards.length, equals(10));
        expect(hand.children.whereType<Card>().length, equals(10));
      });

      testWithFlameGame('deck tap with insufficient cards draws remaining cards', (game) async {
        final player = createTestPlayer()..size = Vector2(600, 300);

        await game.ensureAdd(player);

        final deck = player.children.whereType<CardDeck>().first;
        final hand = player.children.whereType<CardHand>().first;

        // Tap until only 3 cards remain
        deck.onTap?.call(); // 15 left
        deck.onTap?.call(); // 10 left  
        deck.onTap?.call(); // 5 left
        deck.onTap?.call(); // 0 left

        // All cards should now be in hand
        expect(deck.model.allCards.length, equals(0));
        expect(hand.model.cards.length, equals(20));
      });

      testWithFlameGame('deck tap on empty deck does nothing', (game) async {
        final player = createTestPlayer()..size = Vector2(600, 300);

        await game.ensureAdd(player);

        final deck = player.children.whereType<CardDeck>().first;
        final hand = player.children.whereType<CardHand>().first;

        // Empty the deck
        for (int i = 0; i < 4; i++) {
          deck.onTap?.call();
        }
        expect(deck.model.allCards.length, equals(0));

        final handSizeBeforeTap = hand.model.cards.length;

        // Tap empty deck
        deck.onTap?.call();

        // Nothing should change
        expect(deck.model.allCards.length, equals(0));
        expect(hand.model.cards.length, equals(handSizeBeforeTap));
      });

      testWithFlameGame('deck display updates after drawing cards', (game) async {
        final player = createTestPlayer()..size = Vector2(600, 300);

        await game.ensureAdd(player);

        final deck = player.children.whereType<CardDeck>().first;

        // Initial state - deck should show 20 cards
        expect(deck.model.allCards.length, equals(20));
        
        // Find the count label (TextComponent) in the deck
        var countLabels = deck.children.whereType<TextComponent>().where(
          (component) => component.text.contains(RegExp(r'^\d+$'))
        ).toList();
        expect(countLabels.length, equals(1));
        expect(countLabels.first.text, equals('20'));

        // Tap deck to draw 5 cards
        deck.onTap?.call();
        await game.ready();

        // Verify model updated
        expect(deck.model.allCards.length, equals(15));
        
        // Verify display updated - find the new count label
        countLabels = deck.children.whereType<TextComponent>().where(
          (component) => component.text.contains(RegExp(r'^\d+$'))
        ).toList();
        expect(countLabels.length, equals(1));
        expect(countLabels.first.text, equals('15'));
      });
    });

    group('card order and content', () {
      testWithFlameGame('drawn cards match deck order', (game) async {
        final player = createTestPlayer()..size = Vector2(600, 300);

        await game.ensureAdd(player);

        final deck = player.children.whereType<CardDeck>().first;
        final hand = player.children.whereType<CardHand>().first;

        // Record first 5 cards from deck
        final expectedCards = deck.model.allCards.take(5).toList();

        // Draw cards
        deck.onTap?.call();

        // Verify drawn cards match expected order
        for (int i = 0; i < 5; i++) {
          expect(hand.model.cards[i].name, equals(expectedCards[i].name));
        }
      });

      testWithFlameGame('displayed cards match hand model', (game) async {
        final player = createTestPlayer()..size = Vector2(600, 300);

        await game.ensureAdd(player);

        final deck = player.children.whereType<CardDeck>().first;
        final hand = player.children.whereType<CardHand>().first;

        // Draw cards
        deck.onTap?.call();

        // Wait for the next frame to allow component updates
        await game.ready();

        final displayedCards = hand.children.whereType<Card>().toList();
        
        // Verify displayed cards match model
        for (int i = 0; i < 5; i++) {
          expect(displayedCards[i].cardModel.name, equals(hand.model.cards[i].name));
        }
      });

      testWithFlameGame('cards in hand are face up', (game) async {
        final player = createTestPlayer()..size = Vector2(600, 300);

        await game.ensureAdd(player);

        final deck = player.children.whereType<CardDeck>().first;
        final hand = player.children.whereType<CardHand>().first;

        // Verify deck cards are face down initially
        expect(deck.model.allCards.every((card) => !card.isFaceUp), isTrue);

        // Draw cards
        deck.onTap?.call();

        // Wait for the next frame to allow component updates
        await game.ready();

        // Verify all cards in hand are face up
        expect(hand.model.cards.every((card) => card.isFaceUp), isTrue);
        
        // Verify displayed cards show face up content
        final displayedCards = hand.children.whereType<Card>().toList();
        for (final card in displayedCards) {
          expect(card.cardModel.isFaceUp, isTrue);
        }
      });
    });

    group('constants and configuration', () {
      test('player constants are defined correctly', () {
        expect(Player.handWidthFactor, equals(0.6));
        expect(Player.pileWidthFactor, equals(0.2));
        expect(Player.cardsToDrawOnTap, equals(5));
        expect(Player.infoHeightFactor, equals(0.1));
      });

      test('layout factors sum to 1.0', () {
        final total = Player.handWidthFactor + (Player.pileWidthFactor * 2);
        expect(total, equals(1.0));
      });
    });
  });
}
