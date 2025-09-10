import 'package:flutter_test/flutter_test.dart';
import 'package:card_battler/game_legacy/services/card/card_selection_service.dart';
import 'package:card_battler/game_legacy/models/shared/card_model.dart';

void main() {
  group('DefaultCardSelectionService', () {
    late DefaultCardSelectionService selectionService;
    late CardModel card1;
    late CardModel card2;

    setUp(() {
      selectionService = DefaultCardSelectionService();
      card1 = CardModel(name: 'Card 1', type: 'Action');
      card2 = CardModel(name: 'Card 2', type: 'Magic');
    });

    tearDown(() {
      selectionService.reset();
    });

    group('initial state', () {
      test('has no selection initially', () {
        expect(selectionService.selectedCard, isNull);
        expect(selectionService.hasSelection, isFalse);
      });

      test('no card is initially selected', () {
        expect(selectionService.isCardSelected(card1), isFalse);
        expect(selectionService.isCardSelected(card2), isFalse);
      });
    });

    group('selectCard', () {
      test('selects a card', () {
        selectionService.selectCard(card1);
        
        expect(selectionService.selectedCard, equals(card1));
        expect(selectionService.hasSelection, isTrue);
        expect(selectionService.isCardSelected(card1), isTrue);
        expect(selectionService.isCardSelected(card2), isFalse);
      });

      test('replaces previous selection', () {
        selectionService.selectCard(card1);
        expect(selectionService.selectedCard, equals(card1));
        
        selectionService.selectCard(card2);
        expect(selectionService.selectedCard, equals(card2));
        expect(selectionService.isCardSelected(card1), isFalse);
        expect(selectionService.isCardSelected(card2), isTrue);
      });

      test('does not notify listeners when selecting same card', () {
        int notificationCount = 0;
        selectionService.addSelectionListener((_) => notificationCount++);
        
        selectionService.selectCard(card1);
        expect(notificationCount, equals(1));
        
        selectionService.selectCard(card1); // Select same card
        expect(notificationCount, equals(1)); // Should not increment
      });
    });

    group('deselectCard', () {
      test('deselects currently selected card', () {
        selectionService.selectCard(card1);
        expect(selectionService.hasSelection, isTrue);
        
        selectionService.deselectCard();
        expect(selectionService.selectedCard, isNull);
        expect(selectionService.hasSelection, isFalse);
        expect(selectionService.isCardSelected(card1), isFalse);
      });

      test('does nothing when no card is selected', () {
        expect(selectionService.hasSelection, isFalse);
        
        selectionService.deselectCard();
        expect(selectionService.selectedCard, isNull);
        expect(selectionService.hasSelection, isFalse);
      });

      test('does not notify listeners when no card was selected', () {
        int notificationCount = 0;
        selectionService.addSelectionListener((_) => notificationCount++);
        
        selectionService.deselectCard(); // No card selected
        expect(notificationCount, equals(0));
      });
    });

    group('listener management', () {
      test('notifies listeners when card is selected', () {
        CardModel? notifiedCard;
        bool listenerCalled = false;
        
        selectionService.addSelectionListener((card) {
          notifiedCard = card;
          listenerCalled = true;
        });
        
        selectionService.selectCard(card1);
        
        expect(listenerCalled, isTrue);
        expect(notifiedCard, equals(card1));
      });

      test('notifies listeners when card is deselected', () {
        CardModel? notifiedCard;
        int notificationCount = 0;
        
        selectionService.addSelectionListener((card) {
          notifiedCard = card;
          notificationCount++;
        });
        
        selectionService.selectCard(card1);
        expect(notificationCount, equals(1));
        expect(notifiedCard, equals(card1));
        
        selectionService.deselectCard();
        expect(notificationCount, equals(2));
        expect(notifiedCard, isNull);
      });

      test('handles multiple listeners', () {
        int listener1Count = 0;
        int listener2Count = 0;
        CardModel? listener1Card;
        CardModel? listener2Card;
        
        selectionService.addSelectionListener((card) {
          listener1Count++;
          listener1Card = card;
        });
        
        selectionService.addSelectionListener((card) {
          listener2Count++;
          listener2Card = card;
        });
        
        selectionService.selectCard(card1);
        
        expect(listener1Count, equals(1));
        expect(listener2Count, equals(1));
        expect(listener1Card, equals(card1));
        expect(listener2Card, equals(card1));
      });

      test('removes listeners correctly', () {
        int callCount = 0;
        void listener(CardModel? card) => callCount++;
        
        selectionService.addSelectionListener(listener);
        selectionService.selectCard(card1);
        expect(callCount, equals(1));
        
        selectionService.removeSelectionListener(listener);
        selectionService.selectCard(card2);
        expect(callCount, equals(1)); // Should not increment
      });

      test('continues notifying other listeners when one fails', () {
        int successfulListener = 0;
        
        // Add a failing listener
        selectionService.addSelectionListener((_) {
          throw Exception('Test error');
        });
        
        // Add a successful listener
        selectionService.addSelectionListener((_) {
          successfulListener++;
        });
        
        selectionService.selectCard(card1);
        expect(successfulListener, equals(1));
      });

      test('handles removing non-existent listener', () {
        void listener(CardModel? card) {}
        
        // Should not throw
        expect(() => selectionService.removeSelectionListener(listener), returnsNormally);
      });
    });

    group('reset', () {
      test('clears selection and listeners', () {
        int callCount = 0;
        selectionService.addSelectionListener((_) => callCount++);
        selectionService.selectCard(card1);
        expect(callCount, equals(1));
        expect(selectionService.hasSelection, isTrue);
        
        selectionService.reset();
        
        expect(selectionService.selectedCard, isNull);
        expect(selectionService.hasSelection, isFalse);
        
        selectionService.selectCard(card2);
        expect(callCount, equals(1)); // Listeners were cleared, should not increment
      });
    });

    group('edge cases', () {
      test('handles rapid selection changes', () {
        List<CardModel?> notifications = [];
        selectionService.addSelectionListener((card) => notifications.add(card));
        
        // Rapid selection changes
        selectionService.selectCard(card1);
        selectionService.selectCard(card2);
        selectionService.deselectCard();
        selectionService.selectCard(card1);
        
        expect(notifications, equals([card1, card2, null, card1]));
      });

      test('can select same card after deselection', () {
        int notificationCount = 0;
        selectionService.addSelectionListener((_) => notificationCount++);
        
        selectionService.selectCard(card1);
        selectionService.deselectCard();
        selectionService.selectCard(card1);
        
        expect(notificationCount, equals(3)); // Select, deselect, select again
        expect(selectionService.selectedCard, equals(card1));
      });

      test('maintains correct state when adding duplicate listeners', () {
        int callCount = 0;
        void listener(CardModel? card) => callCount++;
        
        selectionService.addSelectionListener(listener);
        selectionService.addSelectionListener(listener); // Add same listener twice
        
        selectionService.selectCard(card1);
        expect(callCount, equals(2)); // Called twice because added twice
      });
    });

    group('isCardSelected consistency', () {
      test('returns true only for currently selected card', () {
        expect(selectionService.isCardSelected(card1), isFalse);
        expect(selectionService.isCardSelected(card2), isFalse);
        
        selectionService.selectCard(card1);
        expect(selectionService.isCardSelected(card1), isTrue);
        expect(selectionService.isCardSelected(card2), isFalse);
        
        selectionService.selectCard(card2);
        expect(selectionService.isCardSelected(card1), isFalse);
        expect(selectionService.isCardSelected(card2), isTrue);
        
        selectionService.deselectCard();
        expect(selectionService.isCardSelected(card1), isFalse);
        expect(selectionService.isCardSelected(card2), isFalse);
      });
    });
  });
}