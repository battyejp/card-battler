import 'package:card_battler/game/coordinators/components/cards/card_coordinator.dart';
import 'package:card_battler/game/coordinators/components/cards/card_list_coordinator.dart';
import 'package:card_battler/game/models/card/card_model.dart';
import 'package:card_battler/game/models/shared/play_effects_model.dart';
import 'package:card_battler/game/services/game/game_phase_manager.dart';
import 'package:card_battler/game/services/player/active_player_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Mock classes
class MockCardModel extends Mock implements CardModel {}

class MockGamePhaseManager extends Mock implements GamePhaseManager {}

class MockActivePlayerManager extends Mock implements ActivePlayerManager {}

// Mock CardCoordinator for testing
class MockCardCoordinator extends CardCoordinator {
  MockCardCoordinator({String name = 'Test Card'})
    : super(
        cardModel: _createMockCardModel(name),
        gamePhaseManager: MockGamePhaseManager(),
        activePlayerManager: MockActivePlayerManager(),
      );

  static MockCardModel _createMockCardModel(String name) {
    final mock = MockCardModel();
    when(() => mock.name).thenReturn(name);
    when(() => mock.type).thenReturn(CardType.unknown);
    when(() => mock.isFaceUp).thenReturn(true);
    when(() => mock.playEffects).thenReturn(EffectsModel.empty());
    return mock;
  }
}

void main() {
  group('CardListCoordinator', () {
    late CardListCoordinator<MockCardCoordinator> cardListCoordinator;
    late List<MockCardCoordinator> initialCards;

    setUp(() {
      initialCards = [
        MockCardCoordinator(name: 'Card 1'),
        MockCardCoordinator(name: 'Card 2'),
        MockCardCoordinator(name: 'Card 3'),
      ];
      cardListCoordinator = CardListCoordinator(cardCoordinators: initialCards);
    });

    tearDown(() {
      cardListCoordinator.dispose();
    });

    group('Constructor', () {
      test('creates instance with provided card coordinators', () {
        expect(cardListCoordinator, isNotNull);
        expect(
          cardListCoordinator,
          isA<CardListCoordinator<MockCardCoordinator>>(),
        );
        expect(cardListCoordinator.cardCoordinators.length, equals(3));
      });

      test('creates instance with empty list', () {
        final emptyCoordinator = CardListCoordinator<MockCardCoordinator>(
          cardCoordinators: [],
        );

        expect(emptyCoordinator.cardCoordinators, isEmpty);
        expect(emptyCoordinator.isEmpty, isTrue);
        expect(emptyCoordinator.hasCards, isFalse);

        emptyCoordinator.dispose();
      });

      test('maintains reference to original card coordinators', () {
        expect(cardListCoordinator.cardCoordinators, equals(initialCards));
        expect(cardListCoordinator.cardCoordinators[0].name, equals('Card 1'));
        expect(cardListCoordinator.cardCoordinators[1].name, equals('Card 2'));
        expect(cardListCoordinator.cardCoordinators[2].name, equals('Card 3'));
      });
    });

    group('Properties', () {
      test('hasCards returns true when cards are present', () {
        expect(cardListCoordinator.hasCards, isTrue);
      });

      test('hasCards returns false when no cards are present', () {
        final emptyCoordinator = CardListCoordinator<MockCardCoordinator>(
          cardCoordinators: [],
        );

        expect(emptyCoordinator.hasCards, isFalse);
        emptyCoordinator.dispose();
      });

      test('isEmpty returns false when cards are present', () {
        expect(cardListCoordinator.isEmpty, isFalse);
      });

      test('isEmpty returns true when no cards are present', () {
        final emptyCoordinator = CardListCoordinator<MockCardCoordinator>(
          cardCoordinators: [],
        );

        expect(emptyCoordinator.isEmpty, isTrue);
        emptyCoordinator.dispose();
      });

      test('cardCoordinators getter returns list of coordinators', () {
        final coordinators = cardListCoordinator.cardCoordinators;

        expect(coordinators, isA<List<MockCardCoordinator>>());
        expect(coordinators.length, equals(3));
        expect(coordinators, contains(isA<MockCardCoordinator>()));
      });
    });

    group('Drawing Cards', () {
      test('drawCards returns specified number of cards', () {
        final drawnCards = cardListCoordinator.drawCards(2);

        expect(drawnCards.length, equals(2));
        expect(drawnCards, everyElement(isA<MockCardCoordinator>()));
      });

      test('drawCards removes cards from collection', () {
        final originalCount = cardListCoordinator.cardCoordinators.length;
        cardListCoordinator.drawCards(1);

        expect(
          cardListCoordinator.cardCoordinators.length,
          equals(originalCount - 1),
        );
      });

      test(
        'drawCards with count larger than available cards returns all cards',
        () {
          final drawnCards = cardListCoordinator.drawCards(10);

          expect(drawnCards.length, equals(3)); // Only 3 cards available
          expect(cardListCoordinator.isEmpty, isTrue);
        },
      );

      test('drawCards from empty collection returns empty list', () {
        cardListCoordinator.removeAllCards();
        final drawnCards = cardListCoordinator.drawCards(5);

        expect(drawnCards, isEmpty);
      });

      test('drawCards with refreshUi true notifies change', () async {
        final changes = <CardListCoordinator<MockCardCoordinator>>[];
        final subscription = cardListCoordinator.changes.listen(changes.add);

        cardListCoordinator.drawCards(1, refreshUi: true);
        await Future.delayed(Duration.zero);

        expect(changes.length, equals(1));
        expect(identical(changes.first, cardListCoordinator), isTrue);

        await subscription.cancel();
      });

      test('drawCards with refreshUi false does not notify change', () async {
        final changes = <CardListCoordinator<MockCardCoordinator>>[];
        final subscription = cardListCoordinator.changes.listen(changes.add);

        cardListCoordinator.drawCards(1, refreshUi: false);
        await Future.delayed(Duration.zero);

        expect(changes, isEmpty);

        await subscription.cancel();
      });
    });

    group('Adding Cards', () {
      test('addCard adds single card to collection', () {
        final newCard = MockCardCoordinator(name: 'New Card');
        final originalCount = cardListCoordinator.cardCoordinators.length;

        cardListCoordinator.addCard(newCard);

        expect(
          cardListCoordinator.cardCoordinators.length,
          equals(originalCount + 1),
        );
        expect(cardListCoordinator.cardCoordinators, contains(newCard));
      });

      test('addCards adds multiple cards to collection', () {
        final newCards = [
          MockCardCoordinator(name: 'New Card 1'),
          MockCardCoordinator(name: 'New Card 2'),
        ];
        final originalCount = cardListCoordinator.cardCoordinators.length;

        cardListCoordinator.addCards(newCards);

        expect(
          cardListCoordinator.cardCoordinators.length,
          equals(originalCount + 2),
        );
        expect(cardListCoordinator.cardCoordinators, containsAll(newCards));
      });

      test('addCards with empty list does not change collection', () {
        final originalCount = cardListCoordinator.cardCoordinators.length;

        cardListCoordinator.addCards([]);

        expect(
          cardListCoordinator.cardCoordinators.length,
          equals(originalCount),
        );
      });

      test('addCard with refreshUi true notifies change', () async {
        final changes = <CardListCoordinator<MockCardCoordinator>>[];
        final subscription = cardListCoordinator.changes.listen(changes.add);

        cardListCoordinator.addCard(MockCardCoordinator(), refreshUi: true);
        await Future.delayed(Duration.zero);

        expect(changes.length, equals(1));

        await subscription.cancel();
      });

      test('addCard with refreshUi false does not notify change', () async {
        final changes = <CardListCoordinator<MockCardCoordinator>>[];
        final subscription = cardListCoordinator.changes.listen(changes.add);

        cardListCoordinator.addCard(MockCardCoordinator(), refreshUi: false);
        await Future.delayed(Duration.zero);

        expect(changes, isEmpty);

        await subscription.cancel();
      });

      test('addCards with refreshUi true notifies change', () async {
        final changes = <CardListCoordinator<MockCardCoordinator>>[];
        final subscription = cardListCoordinator.changes.listen(changes.add);

        cardListCoordinator.addCards([MockCardCoordinator()], refreshUi: true);
        await Future.delayed(Duration.zero);

        expect(changes.length, equals(1));

        await subscription.cancel();
      });

      test('addCards with refreshUi false does not notify change', () async {
        final changes = <CardListCoordinator<MockCardCoordinator>>[];
        final subscription = cardListCoordinator.changes.listen(changes.add);

        cardListCoordinator.addCards([MockCardCoordinator()], refreshUi: false);
        await Future.delayed(Duration.zero);

        expect(changes, isEmpty);

        await subscription.cancel();
      });
    });

    group('Removing Cards', () {
      test('removeCard removes specific card from collection', () {
        final cardToRemove = cardListCoordinator.cardCoordinators.first;
        final originalCount = cardListCoordinator.cardCoordinators.length;

        cardListCoordinator.removeCard(cardToRemove);

        expect(
          cardListCoordinator.cardCoordinators.length,
          equals(originalCount - 1),
        );
        expect(
          cardListCoordinator.cardCoordinators,
          isNot(contains(cardToRemove)),
        );
      });

      test('removeCard with non-existent card does not change collection', () {
        final nonExistentCard = MockCardCoordinator(name: 'Non-existent');
        final originalCount = cardListCoordinator.cardCoordinators.length;

        cardListCoordinator.removeCard(nonExistentCard);

        expect(
          cardListCoordinator.cardCoordinators.length,
          equals(originalCount),
        );
      });

      test('removeAllCards removes all cards from collection', () {
        final removedCards = cardListCoordinator.removeAllCards();

        expect(cardListCoordinator.cardCoordinators, isEmpty);
        expect(cardListCoordinator.isEmpty, isTrue);
        expect(removedCards.length, equals(3));
      });

      test('removeAllCards returns list of removed cards', () {
        final originalCards = List<MockCardCoordinator>.from(
          cardListCoordinator.cardCoordinators,
        );
        final removedCards = cardListCoordinator.removeAllCards();

        expect(removedCards, containsAll(originalCards));
      });

      test('removeCard with refreshUi true notifies change', () async {
        final changes = <CardListCoordinator<MockCardCoordinator>>[];
        final subscription = cardListCoordinator.changes.listen(changes.add);

        cardListCoordinator.removeCard(
          cardListCoordinator.cardCoordinators.first,
          refreshUi: true,
        );
        await Future.delayed(Duration.zero);

        expect(changes.length, equals(1));

        await subscription.cancel();
      });

      test('removeCard with refreshUi false does not notify change', () async {
        final changes = <CardListCoordinator<MockCardCoordinator>>[];
        final subscription = cardListCoordinator.changes.listen(changes.add);

        cardListCoordinator.removeCard(
          cardListCoordinator.cardCoordinators.first,
          refreshUi: false,
        );
        await Future.delayed(Duration.zero);

        expect(changes, isEmpty);

        await subscription.cancel();
      });

      test('removeAllCards with refreshUi true notifies change', () async {
        final changes = <CardListCoordinator<MockCardCoordinator>>[];
        final subscription = cardListCoordinator.changes.listen(changes.add);

        cardListCoordinator.removeAllCards(refreshUi: true);
        await Future.delayed(Duration.zero);

        expect(changes.length, equals(1));

        await subscription.cancel();
      });

      test(
        'removeAllCards with refreshUi false does not notify change',
        () async {
          final changes = <CardListCoordinator<MockCardCoordinator>>[];
          final subscription = cardListCoordinator.changes.listen(changes.add);

          cardListCoordinator.removeAllCards(refreshUi: false);
          await Future.delayed(Duration.zero);

          expect(changes, isEmpty);

          await subscription.cancel();
        },
      );
    });

    group('Shuffling', () {
      test('shuffle method executes without error', () {
        expect(() => cardListCoordinator.shuffle(), returnsNormally);
      });

      test('shuffle does not change number of cards', () {
        final originalCount = cardListCoordinator.cardCoordinators.length;

        cardListCoordinator.shuffle();

        expect(
          cardListCoordinator.cardCoordinators.length,
          equals(originalCount),
        );
      });

      test('shuffle does not notify change', () async {
        final changes = <CardListCoordinator<MockCardCoordinator>>[];
        final subscription = cardListCoordinator.changes.listen(changes.add);

        cardListCoordinator.shuffle();
        await Future.delayed(Duration.zero);

        expect(changes, isEmpty);

        await subscription.cancel();
      });

      test('shuffle on empty collection works', () {
        cardListCoordinator.removeAllCards();

        expect(() => cardListCoordinator.shuffle(), returnsNormally);
        expect(cardListCoordinator.isEmpty, isTrue);
      });
    });

    group('Reactive Behavior', () {
      test(
        'multiple operations with refreshUi true generate multiple notifications',
        () async {
          final changes = <CardListCoordinator<MockCardCoordinator>>[];
          final subscription = cardListCoordinator.changes.listen(changes.add);

          cardListCoordinator.addCard(MockCardCoordinator(), refreshUi: true);
          cardListCoordinator.drawCards(1, refreshUi: true);
          cardListCoordinator.removeCard(
            cardListCoordinator.cardCoordinators.first,
            refreshUi: true,
          );

          await Future.delayed(Duration.zero);

          expect(changes.length, equals(3));

          await subscription.cancel();
        },
      );

      test(
        'multiple operations with refreshUi false generate no notifications',
        () async {
          final changes = <CardListCoordinator<MockCardCoordinator>>[];
          final subscription = cardListCoordinator.changes.listen(changes.add);

          cardListCoordinator.addCard(MockCardCoordinator(), refreshUi: false);
          cardListCoordinator.drawCards(1, refreshUi: false);
          cardListCoordinator.removeCard(
            cardListCoordinator.cardCoordinators.first,
            refreshUi: false,
          );

          await Future.delayed(Duration.zero);

          expect(changes, isEmpty);

          await subscription.cancel();
        },
      );
    });

    group('Performance', () {
      test('adding many cards is efficient', () {
        final manyCards = List.generate(
          1000,
          (i) => MockCardCoordinator(name: 'Card $i'),
        );

        final stopwatch = Stopwatch()..start();
        cardListCoordinator.addCards(manyCards, refreshUi: false);
        stopwatch.stop();

        expect(stopwatch.elapsedMilliseconds, lessThan(100));
        expect(
          cardListCoordinator.cardCoordinators.length,
          equals(1003),
        ); // 3 initial + 1000
      });

      test('drawing many cards is efficient', () {
        final manyCards = List.generate(
          1000,
          (i) => MockCardCoordinator(name: 'Card $i'),
        );
        cardListCoordinator.addCards(manyCards, refreshUi: false);

        final stopwatch = Stopwatch()..start();
        cardListCoordinator.drawCards(500, refreshUi: false);
        stopwatch.stop();

        expect(stopwatch.elapsedMilliseconds, lessThan(50));
        expect(
          cardListCoordinator.cardCoordinators.length,
          equals(503),
        ); // 1003 - 500
      });

      test('property access is fast', () {
        final stopwatch = Stopwatch()..start();

        for (var i = 0; i < 1000; i++) {
          cardListCoordinator.hasCards;
          cardListCoordinator.isEmpty;
          cardListCoordinator.cardCoordinators;
        }

        stopwatch.stop();
        expect(stopwatch.elapsedMilliseconds, lessThan(50));
      });
    });

    group('Integration', () {
      test('works with complex card operations', () {
        // Add cards
        cardListCoordinator.addCards([
          MockCardCoordinator(name: 'Added 1'),
          MockCardCoordinator(name: 'Added 2'),
        ]);

        expect(cardListCoordinator.cardCoordinators.length, equals(5));

        // Draw some cards
        final drawnCards = cardListCoordinator.drawCards(2);
        expect(drawnCards.length, equals(2));
        expect(cardListCoordinator.cardCoordinators.length, equals(3));

        // Remove specific card
        cardListCoordinator.removeCard(
          cardListCoordinator.cardCoordinators.first,
        );
        expect(cardListCoordinator.cardCoordinators.length, equals(2));

        // Shuffle remaining cards
        cardListCoordinator.shuffle();
        expect(cardListCoordinator.cardCoordinators.length, equals(2));

        // Clear all
        final removedCards = cardListCoordinator.removeAllCards();
        expect(removedCards.length, equals(2));
        expect(cardListCoordinator.isEmpty, isTrue);
      });
    });
  });
}
