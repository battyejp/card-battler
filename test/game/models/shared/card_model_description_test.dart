import 'package:card_battler/game/models/shared/card_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CardModel description', () {
    test('generates description from single effect', () {
      final card = CardModel(
        name: 'Attack Card',
        type: 'Player',
        effects: [
          EffectModel(
            type: EffectType.attack,
            target: EffectTarget.self,
            value: 2,
          ),
        ],
      );

      expect(card.description, equals('Attack +2 self'));
    });

    test('generates description from multiple effects', () {
      final card = CardModel(
        name: 'Complex Card',
        type: 'Player',
        effects: [
          EffectModel(
            type: EffectType.heal,
            target: EffectTarget.self,
            value: 3,
          ),
          EffectModel(
            type: EffectType.attack,
            target: EffectTarget.activePlayer,
            value: 1,
          ),
        ],
      );

      expect(card.description, equals('Heal +3 self, Attack +1 active player'));
    });

    test('handles no effects', () {
      final card = CardModel(
        name: 'Simple Card',
        type: 'Player',
        effects: [],
      );

      expect(card.description, equals('No special effects.'));
    });

    test('formats different effect types correctly', () {
      final creditCard = CardModel(
        name: 'Credit Card',
        type: 'Player',
        effects: [
          EffectModel(
            type: EffectType.credits,
            target: EffectTarget.allPlayers,
            value: 5,
          ),
        ],
      );

      expect(creditCard.description, equals('Credits +5 all players'));

      final drawCard = CardModel(
        name: 'Draw Card',
        type: 'Player',
        effects: [
          EffectModel(
            type: EffectType.drawCard,
            target: EffectTarget.self,
            value: 2,
          ),
        ],
      );

      expect(drawCard.description, equals('Draw 2 cards self'));

      final singleDrawCard = CardModel(
        name: 'Draw One Card',
        type: 'Player',
        effects: [
          EffectModel(
            type: EffectType.drawCard,
            target: EffectTarget.self,
            value: 1,
          ),
        ],
      );

      expect(singleDrawCard.description, equals('Draw 1 card self'));
    });

    test('formats different target types correctly', () {
      final targets = [
        (EffectTarget.activePlayer, 'active player'),
        (EffectTarget.otherPlayers, 'other players'),
        (EffectTarget.allPlayers, 'all players'),
        (EffectTarget.base, 'base'),
        (EffectTarget.chosenPlayer, 'chosen player'),
        (EffectTarget.self, 'self'),
      ];

      for (final (target, expectedText) in targets) {
        final card = CardModel(
          name: 'Test Card',
          type: 'Player',
          effects: [
            EffectModel(
              type: EffectType.heal,
              target: target,
              value: 1,
            ),
          ],
        );

        expect(
          card.description,
          equals('Heal +1 $expectedText'),
          reason: 'Target $target should format as "$expectedText"',
        );
      }
    });
  });
}