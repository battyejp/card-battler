import 'package:card_battler/game/coordinators/components/cards/card_coordinator.dart';
import 'package:card_battler/game/coordinators/components/player/player_info_coordinator.dart';
import 'package:card_battler/game/models/card/card_model.dart';
import 'package:card_battler/game/models/shared/effect_model.dart';
import 'package:card_battler/game/models/shared/play_effects_model.dart';
import 'package:card_battler/game/services/game/game_phase_manager.dart';
import 'package:card_battler/game/services/player/active_player_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Mock classes
class MockCardModel extends Mock implements CardModel {}

class MockGamePhaseManager extends Mock implements GamePhaseManager {}

class MockActivePlayerManager extends Mock implements ActivePlayerManager {}

class MockPlayerInfoCoordinator extends Mock implements PlayerInfoCoordinator {}

void main() {
  group('CardCoordinator', () {
    late CardModel mockCardModel;
    late GamePhaseManager mockGamePhaseManager;
    late ActivePlayerManager mockActivePlayerManager;
    late CardCoordinator cardCoordinator;

    setUp(() {
      mockCardModel = MockCardModel();
      when(() => mockCardModel.name).thenReturn('Test Card');
      when(() => mockCardModel.type).thenReturn(CardType.unknown);
      when(() => mockCardModel.isFaceUp).thenReturn(true);
      final mockPlayEffects = PlayEffectsModel.empty();
      when(() => mockCardModel.playEffects).thenReturn(mockPlayEffects);

      mockGamePhaseManager = MockGamePhaseManager();
      mockActivePlayerManager = MockActivePlayerManager();

      cardCoordinator = CardCoordinator(
        cardModel: mockCardModel,
        gamePhaseManager: mockGamePhaseManager,
        activePlayerManager: mockActivePlayerManager,
      );
    });

    group('Constructor', () {
      test('creates instance with required dependencies', () {
        expect(cardCoordinator, isNotNull);
        expect(cardCoordinator, isA<CardCoordinator>());
      });

      test('stores card model reference correctly', () {
        expect(cardCoordinator.name, equals('Test Card'));
      });

      test('initializes with null onCardPlayed callback', () {
        expect(cardCoordinator.onCardPlayed, isNull);
      });
    });

    group('Properties', () {
      test('name getter returns card model name', () {
        expect(cardCoordinator.name, equals(mockCardModel.name));
      });

      test('isFaceUp getter returns card model isFaceUp', () {
        when(() => mockCardModel.isFaceUp).thenReturn(true);
        expect(cardCoordinator.isFaceUp, isTrue);

        when(() => mockCardModel.isFaceUp).thenReturn(false);
        expect(cardCoordinator.isFaceUp, isFalse);
      });

      test('effects getter returns card model effects', () {
        final testEffects = <EffectModel>[
          EffectModel(
            type: EffectType.attack,
            target: EffectTarget.activePlayer,
            value: 5,
          ),
          EffectModel(
            type: EffectType.heal,
            target: EffectTarget.activePlayer,
            value: 3,
          ),
        ];

        final cardWithEffects = MockCardModel();
        final playEffectsWithTestEffects = PlayEffectsModel(
          operator: PlayEffectsOperator.and,
          effects: testEffects,
        );
        when(() => cardWithEffects.name).thenReturn('Test Card');
        when(() => cardWithEffects.type).thenReturn(CardType.unknown);
        when(() => cardWithEffects.isFaceUp).thenReturn(true);
        when(
          () => cardWithEffects.playEffects,
        ).thenReturn(playEffectsWithTestEffects);
        final coordinatorWithEffects = CardCoordinator(
          cardModel: cardWithEffects,
          gamePhaseManager: mockGamePhaseManager,
          activePlayerManager: mockActivePlayerManager,
        );

        expect(coordinatorWithEffects.playEffects.effects, equals(testEffects));
        expect(coordinatorWithEffects.playEffects.effects.length, equals(2));
      });

      test('service getters return correct instances', () {
        expect(cardCoordinator.gamePhaseManager, isA<GamePhaseManager>());
        expect(cardCoordinator.activePlayerManager, isA<ActivePlayerManager>());
      });
    });

    group('Card Played Handling', () {
      test('handleCardPlayed calls onCardPlayed callback when set', () {
        CardCoordinator? calledWith;
        cardCoordinator.onCardPlayed = (coordinator) {
          calledWith = coordinator;
        };

        cardCoordinator.handleCardPlayed();

        expect(calledWith, equals(cardCoordinator));
      });

      test('handleCardPlayed does nothing when onCardPlayed is null', () {
        cardCoordinator.onCardPlayed = null;

        expect(() => cardCoordinator.handleCardPlayed(), returnsNormally);
      });
    });

    group('Service Integration', () {
      test('coordinator provides access to all required services', () {
        expect(cardCoordinator.gamePhaseManager, isNotNull);
        expect(cardCoordinator.activePlayerManager, isNotNull);
      });
    });

    group('Effects Handling', () {
      test('effects list reflects card model effects', () {
        final effectList = cardCoordinator.playEffects.effects;
        expect(effectList, equals(mockCardModel.playEffects.effects));
      });

      test('empty effects list is handled correctly', () {
        expect(cardCoordinator.playEffects.effects, isEmpty);
      });

      test('multiple effects are handled correctly', () {
        final effects = <EffectModel>[
          EffectModel(
            type: EffectType.attack,
            target: EffectTarget.activePlayer,
            value: 10,
          ),
          EffectModel(
            type: EffectType.heal,
            target: EffectTarget.activePlayer,
            value: 5,
          ),
          EffectModel(
            type: EffectType.credits,
            target: EffectTarget.activePlayer,
            value: 3,
          ),
        ];

        final cardWithEffects = MockCardModel();
        final playEffectsWithEffects = PlayEffectsModel(
          operator: PlayEffectsOperator.and,
          effects: effects,
        );
        when(() => cardWithEffects.name).thenReturn('Test Card');
        when(() => cardWithEffects.type).thenReturn(CardType.unknown);
        when(() => cardWithEffects.isFaceUp).thenReturn(true);
        when(
          () => cardWithEffects.playEffects,
        ).thenReturn(playEffectsWithEffects);
        final coordinatorWithEffects = CardCoordinator(
          cardModel: cardWithEffects,
          gamePhaseManager: mockGamePhaseManager,
          activePlayerManager: mockActivePlayerManager,
        );

        expect(coordinatorWithEffects.playEffects.effects.length, equals(3));
        expect(
          coordinatorWithEffects.playEffects.effects[0].type,
          equals(EffectType.attack),
        );
        expect(coordinatorWithEffects.playEffects.effects[0].value, equals(10));
        expect(
          coordinatorWithEffects.playEffects.effects[1].type,
          equals(EffectType.heal),
        );
        expect(coordinatorWithEffects.playEffects.effects[1].value, equals(5));
        expect(
          coordinatorWithEffects.playEffects.effects[2].type,
          equals(EffectType.credits),
        );
        expect(coordinatorWithEffects.playEffects.effects[2].value, equals(3));
      });
    });

    group('Callback Management', () {
      test('callback receives correct coordinator instance', () {
        CardCoordinator? receivedCoordinator;
        cardCoordinator.onCardPlayed = (coordinator) {
          receivedCoordinator = coordinator;
        };

        cardCoordinator.handleCardPlayed();

        expect(receivedCoordinator, isNotNull);
        expect(identical(receivedCoordinator, cardCoordinator), isTrue);
      });
    });
  });
}
