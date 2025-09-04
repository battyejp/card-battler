import 'package:flutter_test/flutter_test.dart';

import 'package:card_battler/game/models/enemy/enemies_model.dart';
import 'package:card_battler/game/models/game_state_model.dart';
import 'package:card_battler/game/models/player/card_hand_model.dart';
import 'package:card_battler/game/models/player/info_model.dart';
import 'package:card_battler/game/models/player/player_model.dart';
import 'package:card_battler/game/models/player/player_turn_model.dart';
import 'package:card_battler/game/models/shared/card_model.dart';
import 'package:card_battler/game/models/shared/card_pile_model.dart';
import 'package:card_battler/game/models/shared/health_model.dart';
import 'package:card_battler/game/models/shared/value_image_label_model.dart';
import 'package:card_battler/game/models/shop/shop_card_model.dart';
import 'package:card_battler/game/models/shop/shop_model.dart';
import 'package:card_battler/game/models/team/bases_model.dart';
import 'package:card_battler/game/models/team/team_model.dart';

void main() {
  group('PlayerTurnModel', () {
    late PlayerModel playerModel;
    late TeamModel teamModel;
    late EnemiesModel enemiesModel;
    late ShopModel shopModel;
    late PlayerTurnModel playerTurnModel;

    setUp(() {
      GameStateModel.instance.selectedPlayer = null;

      final infoModel = InfoModel(
        attack: ValueImageLabelModel(value: 50, label: 'Attack'),
        credits: ValueImageLabelModel(value: 100, label: 'Credits'),
        healthModel: HealthModel(maxHealth: 100),
        name: 'TestPlayer',
      );

      final handModel = CardHandModel();
      final deckModel = CardPileModel.empty();
      final discardModel = CardPileModel.empty();

      playerModel = PlayerModel(
        infoModel: infoModel,
        handModel: handModel,
        deckModel: deckModel,
        discardModel: discardModel,
      );

      teamModel = TeamModel(bases: BasesModel(bases: []), players: []);
      enemiesModel = EnemiesModel(
        totalEnemies: 0,
        maxNumberOfEnemiesInPlay: 3,
        maxEnemyHealth: 50,
        enemyCards: [],
      );

      final shopCards = List.generate(10, (index) => 
        ShopCardModel(name: 'Shop Card ${index + 1}', cost: 10)
      );
      shopModel = ShopModel(
        numberOfRows: 2, 
        numberOfColumns: 3,
        cards: shopCards
      );

      playerTurnModel = PlayerTurnModel(
        playerModel: playerModel,
        teamModel: teamModel,
        enemiesModel: enemiesModel,
        shopModel: shopModel,
      );
    });

    group('constructor and initialization', () {
      test('creates with all required models', () {
        expect(playerTurnModel.playerModel, equals(playerModel));
        expect(playerTurnModel.teamModel, equals(teamModel));
        expect(playerTurnModel.enemiesModel, equals(enemiesModel));
        expect(playerTurnModel.shopModel, equals(shopModel));
      });

      test('sets up card played callbacks', () {
        expect(playerModel.cardPlayed, isNotNull);
        expect(shopModel.cardPlayed, isNotNull);
      });

      test('selectedPlayer starts as null', () {
        expect(GameStateModel.instance.selectedPlayer, isNull);
      });
    });

    group('onCardPlayed method', () {
      test('handles regular card play correctly', () {
        final card = CardModel(name: 'Test Card', type: 'attack');
        card.isFaceUp = true;
        playerModel.handModel.addCard(card);

        final initialHandSize = playerModel.handModel.cards.length;
        final initialDiscardSize = playerModel.discardModel.allCards.length;

        playerTurnModel.onCardPlayed(card);

        expect(card.isFaceUp, isFalse);
        expect(playerModel.handModel.cards.length, equals(initialHandSize - 1));
        expect(playerModel.discardModel.allCards.length, equals(initialDiscardSize + 1));
        expect(playerModel.discardModel.allCards.contains(card), isTrue);
      });

      test('handles shop card play correctly', () {
        final shopCard = shopModel.selectableCards.first;
        final initialCredits = playerModel.infoModel.credits.value;
        final initialShopSize = shopModel.selectableCards.length;
        final initialDiscardSize = playerModel.discardModel.allCards.length;

        playerTurnModel.onCardPlayed(shopCard);

        expect(shopCard.isFaceUp, isFalse);
        expect(shopModel.selectableCards.length, equals(initialShopSize - 1));
        expect(playerModel.infoModel.credits.value, equals(initialCredits - shopCard.cost));
        expect(playerModel.discardModel.allCards.length, equals(initialDiscardSize + 1));
        expect(playerModel.discardModel.allCards.contains(shopCard), isTrue);
      });

      test('calls applyCardEffects after handling card', () {
        final card = CardModel(
          name: 'Credit Card', 
          type: 'utility',
          effects: [EffectModel(type: EffectType.credits, target: EffectTarget.self, value: 25)]
        );
        playerModel.handModel.addCard(card);

        final initialCredits = playerModel.infoModel.credits.value;

        playerTurnModel.onCardPlayed(card);

        expect(playerModel.infoModel.credits.value, equals(initialCredits + 25));
      });
    });

    group('applyCardEffects method', () {
      test('applies credits effect correctly', () {
        final card = CardModel(
          name: 'Credit Card',
          type: 'utility',
          effects: [EffectModel(type: EffectType.credits, target: EffectTarget.self, value: 50)]
        );

        final initialCredits = playerModel.infoModel.credits.value;

        playerTurnModel.applyCardEffects(card);

        expect(playerModel.infoModel.credits.value, equals(initialCredits + 50));
      });

      test('applies negative credits effect correctly', () {
        final card = CardModel(
          name: 'Expensive Card',
          type: 'utility',
          effects: [EffectModel(type: EffectType.credits, target: EffectTarget.self, value: -30)]
        );

        final initialCredits = playerModel.infoModel.credits.value;

        playerTurnModel.applyCardEffects(card);

        expect(playerModel.infoModel.credits.value, equals(initialCredits - 30));
      });

      test('handles multiple effects on single card', () {
        final card = CardModel(
          name: 'Multi Effect Card',
          type: 'utility',
          effects: [
            EffectModel(type: EffectType.credits, target: EffectTarget.self, value: 20),
            EffectModel(type: EffectType.credits, target: EffectTarget.self, value: 10)
          ]
        );

        final initialCredits = playerModel.infoModel.credits.value;

        playerTurnModel.applyCardEffects(card);

        expect(playerModel.infoModel.credits.value, equals(initialCredits + 30));
      });

      test('handles cards with no effects', () {
        final card = CardModel(
          name: 'Simple Card',
          type: 'basic'
        );

        final initialCredits = playerModel.infoModel.credits.value;

        playerTurnModel.applyCardEffects(card);

        expect(playerModel.infoModel.credits.value, equals(initialCredits));
      });

      test('handles unimplemented effect types gracefully', () {
        final card = CardModel(
          name: 'Attack Card',
          type: 'attack',
          effects: [
            EffectModel(type: EffectType.attack, target: EffectTarget.otherPlayers, value: 10),
            EffectModel(type: EffectType.heal, target: EffectTarget.self, value: 5),
            EffectModel(type: EffectType.damageLimit, target: EffectTarget.self, value: 3),
            EffectModel(type: EffectType.drawCard, target: EffectTarget.self, value: 1)
          ]
        );

        // Should not throw, even though these effects aren't implemented yet
        expect(() => playerTurnModel.applyCardEffects(card), returnsNormally);
      });
    });

    group('static selectedPlayer', () {
      test('can be set and retrieved', () {
        final newPlayer = PlayerModel(
          infoModel: InfoModel(
            attack: ValueImageLabelModel(value: 30, label: 'Attack'),
            credits: ValueImageLabelModel(value: 50, label: 'Credits'),
            healthModel: HealthModel(maxHealth: 80),
            name: 'NewPlayer',
          ),
          handModel: CardHandModel(),
          deckModel: CardPileModel.empty(),
          discardModel: CardPileModel.empty(),
        );

        GameStateModel.instance.selectedPlayer = newPlayer;
        expect(GameStateModel.instance.selectedPlayer, equals(newPlayer));
      });

      test('can be set to null', () {
        GameStateModel.instance.selectedPlayer = null;
        expect(GameStateModel.instance.selectedPlayer, isNull);
      });
    });
  });
}