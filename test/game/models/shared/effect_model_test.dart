import 'package:card_battler/game/models/shared/effect_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EffectType', () {
    test('fromString creates correct enum values', () {
      expect(EffectType.fromString('attack'), equals(EffectType.attack));
      expect(EffectType.fromString('heal'), equals(EffectType.heal));
      expect(EffectType.fromString('credits'), equals(EffectType.credits));
      expect(EffectType.fromString('drawCard'), equals(EffectType.drawCard));
      expect(EffectType.fromString('damageLimit'), equals(EffectType.damageLimit));
    });

    test('fromString is case insensitive', () {
      expect(EffectType.fromString('ATTACK'), equals(EffectType.attack));
      expect(EffectType.fromString('Attack'), equals(EffectType.attack));
      expect(EffectType.fromString('aTtAcK'), equals(EffectType.attack));
    });

    test('fromString throws on unknown type', () {
      expect(
        () => EffectType.fromString('unknown'),
        throwsA(isA<ArgumentError>()),
      );
    });
  });

  group('EffectTarget', () {
    test('fromString creates correct enum values', () {
      expect(EffectTarget.fromString('activePlayer'), equals(EffectTarget.activePlayer));
      expect(EffectTarget.fromString('nonActivePlayers'), equals(EffectTarget.nonActivePlayers));
      expect(EffectTarget.fromString('allPlayers'), equals(EffectTarget.allPlayers));
      expect(EffectTarget.fromString('base'), equals(EffectTarget.base));
      expect(EffectTarget.fromString('chosenPlayer'), equals(EffectTarget.chosenPlayer));
      expect(EffectTarget.fromString('self'), equals(EffectTarget.self));
    });

    test('fromString is case insensitive', () {
      expect(EffectTarget.fromString('ACTIVEPLAYER'), equals(EffectTarget.activePlayer));
      expect(EffectTarget.fromString('ActivePlayer'), equals(EffectTarget.activePlayer));
      expect(EffectTarget.fromString('sElF'), equals(EffectTarget.self));
    });

    test('fromString throws on unknown target', () {
      expect(
        () => EffectTarget.fromString('unknownTarget'),
        throwsA(isA<ArgumentError>()),
      );
    });
  });

  group('EffectModel', () {
    group('Constructor', () {
      test('creates effect with required parameters', () {
        final effect = EffectModel(
          type: EffectType.attack,
          target: EffectTarget.activePlayer,
          value: 10,
        );

        expect(effect.type, equals(EffectType.attack));
        expect(effect.target, equals(EffectTarget.activePlayer));
        expect(effect.value, equals(10));
      });

      test('allows negative values', () {
        final effect = EffectModel(
          type: EffectType.heal,
          target: EffectTarget.self,
          value: -5,
        );

        expect(effect.value, equals(-5));
      });

      test('allows zero values', () {
        final effect = EffectModel(
          type: EffectType.credits,
          target: EffectTarget.base,
          value: 0,
        );

        expect(effect.value, equals(0));
      });
    });

    group('fromJson factory', () {
      test('creates effect from valid JSON', () {
        final json = {
          'type': 'attack',
          'target': 'activePlayer',
          'value': 15,
        };

        final effect = EffectModel.fromJson(json);

        expect(effect.type, equals(EffectType.attack));
        expect(effect.target, equals(EffectTarget.activePlayer));
        expect(effect.value, equals(15));
      });

      test('handles all effect types and targets', () {
        final testCases = [
          {'type': 'heal', 'target': 'self', 'value': 5},
          {'type': 'credits', 'target': 'base', 'value': 3},
          {'type': 'drawCard', 'target': 'allPlayers', 'value': 1},
          {'type': 'damageLimit', 'target': 'chosenPlayer', 'value': 2},
        ];

        for (final testCase in testCases) {
          final effect = EffectModel.fromJson(testCase);
          expect(effect.type, equals(EffectType.fromString(testCase['type'] as String)));
          expect(effect.target, equals(EffectTarget.fromString(testCase['target'] as String)));
          expect(effect.value, equals(testCase['value']));
        }
      });

      test('throws on invalid JSON', () {
        expect(
          () => EffectModel.fromJson({'type': 'invalid', 'target': 'self', 'value': 1}),
          throwsA(isA<ArgumentError>()),
        );
        
        expect(
          () => EffectModel.fromJson({'type': 'attack', 'target': 'invalid', 'value': 1}),
          throwsA(isA<ArgumentError>()),
        );
      });
    });

    group('copy method', () {
      test('creates exact copy of effect', () {
        final original = EffectModel(
          type: EffectType.heal,
          target: EffectTarget.nonActivePlayers,
          value: 7,
        );

        final copy = original.copy();

        expect(copy.type, equals(original.type));
        expect(copy.target, equals(original.target));
        expect(copy.value, equals(original.value));
        expect(identical(copy, original), isFalse); // Ensure it's a different instance
      });
    });

    group('toJson method', () {
      test('converts effect to JSON correctly', () {
        final effect = EffectModel(
          type: EffectType.credits,
          target: EffectTarget.base,
          value: 12,
        );

        final json = effect.toJson();

        expect(json['type'], equals('credits'));
        expect(json['target'], equals('base'));
        expect(json['value'], equals(12));
      });

      test('roundtrip conversion preserves data', () {
        final original = EffectModel(
          type: EffectType.attack,
          target: EffectTarget.activePlayer,
          value: 8,
        );

        final json = original.toJson();
        final reconstructed = EffectModel.fromJson(json);

        expect(reconstructed.type, equals(original.type));
        expect(reconstructed.target, equals(original.target));
        expect(reconstructed.value, equals(original.value));
      });
    });
  });
}