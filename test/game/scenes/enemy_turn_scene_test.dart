import 'package:card_battler/game/scenes/enemy_turn_scene.dart';
import 'package:card_battler/game/models/enemy/enemy_turn_area_model.dart';
import 'package:card_battler/game/models/shared/card_model.dart';
import 'package:card_battler/game/models/shared/card_pile_model.dart';
import 'package:card_battler/game/models/shared/health_model.dart';
import 'package:card_battler/game/models/team/player_stats_model.dart';
import 'package:flame/components.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';

List<CardModel> _generateTestCards(int count) {
  return List.generate(count, (index) => CardModel(
    name: 'Enemy Card $index',
    type: 'enemy',
    isFaceUp: false,
    abilities: [
      AbilityModel(
        type: AbilityType.damage,
        target: AbilityTarget.activePlayer,
        value: 10 + index,
      ),
    ],
  ));
}

PlayerStatsModel _createTestPlayerStats(String name, {bool isActive = false, int health = 100}) {
  final healthModel = HealthModel(maxHealth: health);
  return PlayerStatsModel(
    name: name,
    health: healthModel,
    isActive: isActive,
  );
}

void main() {
  group('EnemyTurnScene', () {
    group('constructor and initialization', () {
      testWithFlameGame('creates with required parameters', (game) async {
        final model = EnemyTurnAreaModel(
          enemyCards: CardPileModel(cards: _generateTestCards(3)),
          playerStats: [_createTestPlayerStats('Player1', isActive: true)],
        );

        final enemyTurnScene = EnemyTurnScene(
          model: model,
        );

        expect(enemyTurnScene, isNotNull);
      });

      testWithFlameGame('accepts optional callback parameters', (game) async {
        bool callbackExecuted = false;
        final model = EnemyTurnAreaModel(
          enemyCards: CardPileModel(cards: _generateTestCards(2)),
          playerStats: [_createTestPlayerStats('Player1')],
        );

        final enemyTurnScene = EnemyTurnScene(
          model: model,
          onSceneComplete: () => callbackExecuted = true,
        );

        expect(enemyTurnScene, isNotNull);
        expect(callbackExecuted, isFalse); // Not called yet
      });
    });

    group('scene content and structure', () {
      testWithFlameGame('loads scene components on mount', (game) async {
        final model = EnemyTurnAreaModel(
          enemyCards: CardPileModel(cards: _generateTestCards(2)),
          playerStats: [_createTestPlayerStats('Player1', isActive: true)],
        );

        final enemyTurnScene = EnemyTurnScene(
          model: model,
        );

        enemyTurnScene.size = Vector2(800, 600); // Set size before loading
        await game.ensureAdd(enemyTurnScene);

        // Check that the scene has been added and loaded
        expect(game.children.contains(enemyTurnScene), isTrue);
        expect(enemyTurnScene.children.isNotEmpty, isTrue); // Should have play area component
      });

      testWithFlameGame('creates deck component with correct properties', (game) async {
        final testCards = _generateTestCards(3);
        final model = EnemyTurnAreaModel(
          enemyCards: CardPileModel(cards: testCards),
          playerStats: [_createTestPlayerStats('Player1', isActive: true)],
        );

        final enemyTurnScene = EnemyTurnScene(
          model: model,
        );

        enemyTurnScene.size = Vector2(800, 600);
        await game.ensureAdd(enemyTurnScene);

        // Verify deck properties through model interaction
        expect(model.enemyCards.allCards.length, equals(3));
      });
    });

    group('model integration', () {
      testWithFlameGame('model interaction works with scene', (game) async {
        final testCards = _generateTestCards(2);
        final model = EnemyTurnAreaModel(
          enemyCards: CardPileModel(cards: testCards),
          playerStats: [_createTestPlayerStats('Player1', isActive: true, health: 100)],
        );

        final enemyTurnScene = EnemyTurnScene(
          model: model,
        );

        enemyTurnScene.size = Vector2(800, 600);
        await game.ensureAdd(enemyTurnScene);

        // Initial state
        expect(model.enemyCards.allCards.length, equals(2));
        expect(model.playedCards.allCards.length, equals(0));
        expect(model.turnFinished, isFalse);

        // Simulate deck tap via model
        model.drawCardsFromDeck();

        // Verify card was drawn
        expect(model.enemyCards.allCards.length, equals(1));
        expect(model.playedCards.allCards.length, equals(1));
        expect(model.turnFinished, isTrue);
      });
    });
  });
}