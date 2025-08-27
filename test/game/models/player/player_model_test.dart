import 'package:flutter_test/flutter_test.dart';
import 'package:card_battler/game/models/player/player_model.dart';
import 'package:card_battler/game/models/player/info_model.dart';
import 'package:card_battler/game/models/player/card_hand_model.dart';
import 'package:card_battler/game/models/player/card_pile_model.dart';
import 'package:card_battler/game/models/shared/value_image_label_model.dart';
import 'package:card_battler/game/models/shared/card_model.dart';

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

    setUp(() {
      testInfoModel = InfoModel(
        health: ValueImageLabelModel(value: 100, label: 'Health'),
        attack: ValueImageLabelModel(value: 50, label: 'Attack'),
        credits: ValueImageLabelModel(value: 25, label: 'Credits'),
      );
      testHandModel = CardHandModel();
      testDeckModel = CardPileModel(cards: _generateCards(20));
      testDiscardModel = CardPileModel.empty();
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
        expect(playerModel.infoModel.health.display, equals('Health: 100'));
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
  });
}
