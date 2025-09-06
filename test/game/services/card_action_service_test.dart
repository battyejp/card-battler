import 'package:flutter_test/flutter_test.dart';
import 'package:card_battler/game/services/card_action_service.dart';
import 'package:card_battler/game/models/shared/card_model.dart';

void main() {
  group('CardActionService', () {
    late CardActionService cardActionService;

    setUp(() {
      cardActionService = CardActionService();
    });

    test('playCard calls the card onCardPlayed callback', () {
      bool callbackCalled = false;
      final card = CardModel(name: 'Test Card', type: 'test');
      card.onCardPlayed = () => callbackCalled = true;

      cardActionService.playCard(card);

      expect(callbackCalled, isTrue);
    });

    test('playCard handles null onCardPlayed callback gracefully', () {
      final card = CardModel(name: 'Test Card', type: 'test');
      
      expect(() => cardActionService.playCard(card), returnsNormally);
    });

    test('setCardPlayedCallback sets the callback correctly', () {
      final card = CardModel(name: 'Test Card', type: 'test');
      bool callbackCalled = false;
      
      cardActionService.setCardPlayedCallback(card, () => callbackCalled = true);
      card.onCardPlayed?.call();

      expect(callbackCalled, isTrue);
    });

    test('clearCardPlayedCallback removes the callback', () {
      final card = CardModel(name: 'Test Card', type: 'test');
      card.onCardPlayed = () {};
      
      cardActionService.clearCardPlayedCallback(card);

      expect(card.onCardPlayed, isNull);
    });
  });
}