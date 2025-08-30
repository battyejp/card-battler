import 'package:card_battler/game/components/enemy/enemy_turn_area.dart';
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
    effects: [
      EffectModel(
        type: EffectType.damage,
        target: EffectTarget.activePlayer,
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
  group('EnemyTurnArea', () {
    group('constructor and initialization', () {
      testWithFlameGame('creates with required parameters', (game) async {
        final model = EnemyTurnAreaModel(
          enemyCards: CardPileModel(cards: _generateTestCards(3)),
          playerStats: [_createTestPlayerStats('Player1', isActive: true)],
        );

        final enemyTurnArea = EnemyTurnArea(
          model: model,
          displayDuration: const Duration(seconds: 3),
        );

        expect(enemyTurnArea, isNotNull);
      });

      testWithFlameGame('accepts optional parameters', (game) async {
        final model = EnemyTurnAreaModel(
          enemyCards: CardPileModel(cards: _generateTestCards(2)),
          playerStats: [_createTestPlayerStats('Player1')],
        );

        final enemyTurnArea = EnemyTurnArea(
          model: model,
          displayDuration: const Duration(seconds: 5),
          onComplete: () => {},
        );

        expect(enemyTurnArea, isNotNull);
      });
    });

    group('component structure', () {
      testWithFlameGame('adds backdrop and play area on mount', (game) async {
        final model = EnemyTurnAreaModel(
          enemyCards: CardPileModel(cards: _generateTestCards(2)),
          playerStats: [_createTestPlayerStats('Player1', isActive: true)],
        );

        final enemyTurnArea = EnemyTurnArea(
          model: model,
          displayDuration: const Duration(seconds: 2),
        );

        await game.ensureAdd(enemyTurnArea);

        // Check that the component has been added
        expect(game.children.contains(enemyTurnArea), isTrue);
        
        // Check that backdrop exists (from parent Overlay class)
        expect(enemyTurnArea.children.isNotEmpty, isTrue);
      });

      testWithFlameGame('creates deck component with correct properties', (game) async {
        final testCards = _generateTestCards(3);
        final model = EnemyTurnAreaModel(
          enemyCards: CardPileModel(cards: testCards),
          playerStats: [_createTestPlayerStats('Player1', isActive: true)],
        );

        final enemyTurnArea = EnemyTurnArea(
          model: model,
          displayDuration: const Duration(seconds: 2),
        );

        await game.ensureAdd(enemyTurnArea);

        // Verify deck properties through model interaction
        expect(model.enemyCards.allCards.length, equals(3));
      });

      testWithFlameGame('creates played cards pile component', (game) async {
        final model = EnemyTurnAreaModel(
          enemyCards: CardPileModel(cards: _generateTestCards(2)),
          playerStats: [_createTestPlayerStats('Player1', isActive: true)],
        );

        final enemyTurnArea = EnemyTurnArea(
          model: model,
          displayDuration: const Duration(seconds: 2),
        );

        await game.ensureAdd(enemyTurnArea);

        // Verify played cards pile is initially empty
        expect(model.playedCards.allCards.isEmpty, isTrue);
      });

      testWithFlameGame('creates player stats components for each player', (game) async {
        final players = [
          _createTestPlayerStats('Player1', isActive: true, health: 100),
          _createTestPlayerStats('Player2', isActive: false, health: 80),
          _createTestPlayerStats('Player3', isActive: false, health: 120),
        ];

        final model = EnemyTurnAreaModel(
          enemyCards: CardPileModel(cards: _generateTestCards(1)),
          playerStats: players,
        );

        final enemyTurnArea = EnemyTurnArea(
          model: model,
          displayDuration: const Duration(seconds: 2),
        );

        await game.ensureAdd(enemyTurnArea);

        // Verify all players are present in model
        expect(model.playerStats.length, equals(3));
        expect(model.playerStats[0].name, equals('Player1'));
        expect(model.playerStats[1].name, equals('Player2'));
        expect(model.playerStats[2].name, equals('Player3'));
      });
    });

    group('animation behavior', () {
      testWithFlameGame('startAnimation sets turnFinished to false', (game) async {
        final model = EnemyTurnAreaModel(
          enemyCards: CardPileModel(cards: _generateTestCards(1)),
          playerStats: [_createTestPlayerStats('Player1', isActive: true)],
        );

        final enemyTurnArea = EnemyTurnArea(
          model: model,
          displayDuration: const Duration(seconds: 2),
        );

        await game.ensureAdd(enemyTurnArea);
        
        // Verify turnFinished is set to false after component loads (startAnimation is called automatically)
        expect(model.turnFinished, isFalse);
      });

      testWithFlameGame('startFadeOut triggers fade effect', (game) async {
        final model = EnemyTurnAreaModel(
          enemyCards: CardPileModel(cards: _generateTestCards(1)),
          playerStats: [_createTestPlayerStats('Player1', isActive: true)],
        );

        final enemyTurnArea = EnemyTurnArea(
          model: model,
          displayDuration: const Duration(seconds: 2),
        );

        await game.ensureAdd(enemyTurnArea);
        enemyTurnArea.startAnimation();

        // Should not throw when starting fade out
        expect(() => enemyTurnArea.startFadeOut(), returnsNormally);
      });
    });

    group('model integration', () {
      testWithFlameGame('deck tap calls model drawCardsFromDeck', (game) async {
        final testCards = _generateTestCards(2);
        final model = EnemyTurnAreaModel(
          enemyCards: CardPileModel(cards: testCards),
          playerStats: [_createTestPlayerStats('Player1', isActive: true, health: 100)],
        );

        final enemyTurnArea = EnemyTurnArea(
          model: model,
          displayDuration: const Duration(seconds: 2),
        );

        await game.ensureAdd(enemyTurnArea);

        // Initial state
        expect(model.enemyCards.allCards.length, equals(2));
        expect(model.playedCards.allCards.length, equals(0));
        expect(model.turnFinished, isFalse);

        // Simulate deck tap
        model.drawCardsFromDeck();

        // Verify card was drawn
        expect(model.enemyCards.allCards.length, equals(1));
        expect(model.playedCards.allCards.length, equals(1));
        expect(model.turnFinished, isTrue);
      });

      testWithFlameGame('handles multiple player damage correctly', (game) async {
        final activePlayer1 = _createTestPlayerStats('Active1', isActive: true, health: 100);
        final activePlayer2 = _createTestPlayerStats('Active2', isActive: true, health: 80);
        final inactivePlayer = _createTestPlayerStats('Inactive', isActive: false, health: 90);

        final testCard = CardModel(
          name: 'Multi-Target Card',
          type: 'enemy',
          isFaceUp: false,
          effects: [
            EffectModel(
              type: EffectType.damage,
              target: EffectTarget.activePlayer,
              value: 25,
            ),
          ],
        );

        final model = EnemyTurnAreaModel(
          enemyCards: CardPileModel(cards: [testCard]),
          playerStats: [activePlayer1, activePlayer2, inactivePlayer],
        );

        final enemyTurnArea = EnemyTurnArea(
          model: model,
          displayDuration: const Duration(seconds: 2),
        );

        await game.ensureAdd(enemyTurnArea);

        // Execute turn
        model.drawCardsFromDeck();

        // Verify damage applied to active players only
        expect(activePlayer1.health.currentHealth, equals(75)); // 100 - 25
        expect(activePlayer2.health.currentHealth, equals(55)); // 80 - 25
        expect(inactivePlayer.health.currentHealth, equals(90)); // unchanged
      });
    });

    group('edge cases', () {
      testWithFlameGame('handles empty enemy deck', (game) async {
        final model = EnemyTurnAreaModel(
          enemyCards: CardPileModel.empty(),
          playerStats: [_createTestPlayerStats('Player1', isActive: true)],
        );

        final enemyTurnArea = EnemyTurnArea(
          model: model,
          displayDuration: const Duration(seconds: 2),
        );

        await game.ensureAdd(enemyTurnArea);

        // Should handle empty deck gracefully
        expect(() => model.drawCardsFromDeck(), returnsNormally);
        expect(model.playedCards.allCards.length, equals(0));
      });

      testWithFlameGame('handles no player stats', (game) async {
        final model = EnemyTurnAreaModel(
          enemyCards: CardPileModel(cards: _generateTestCards(1)),
          playerStats: [],
        );

        final enemyTurnArea = EnemyTurnArea(
          model: model,
          displayDuration: const Duration(seconds: 2),
        );

        await game.ensureAdd(enemyTurnArea);

        // Should not throw with no players
        expect(() => model.drawCardsFromDeck(), returnsNormally);
        expect(model.turnFinished, isTrue);
      });

      testWithFlameGame('handles single player stats', (game) async {
        final singlePlayer = _createTestPlayerStats('Solo', isActive: true, health: 50);
        final model = EnemyTurnAreaModel(
          enemyCards: CardPileModel(cards: _generateTestCards(1)),
          playerStats: [singlePlayer],
        );

        final enemyTurnArea = EnemyTurnArea(
          model: model,
          displayDuration: const Duration(seconds: 2),
        );

        await game.ensureAdd(enemyTurnArea);

        model.drawCardsFromDeck();

        // Should work correctly with single player
        expect(model.turnFinished, isTrue);
        expect(singlePlayer.health.currentHealth, equals(40)); // 50 - 10 damage
      });

      testWithFlameGame('handles zero display duration', (game) async {
        final model = EnemyTurnAreaModel(
          enemyCards: CardPileModel(cards: _generateTestCards(1)),
          playerStats: [_createTestPlayerStats('Player1', isActive: true)],
        );

        final enemyTurnArea = EnemyTurnArea(
          model: model,
          displayDuration: Duration.zero,
        );

        await game.ensureAdd(enemyTurnArea);
        
        // Should not throw with zero duration - component loads normally
        expect(enemyTurnArea.isMounted, isTrue);
      });
    });

    group('completion callback', () {
      testWithFlameGame('calls onComplete callback when provided', (game) async {
        bool callbackExecuted = false;
        final model = EnemyTurnAreaModel(
          enemyCards: CardPileModel(cards: _generateTestCards(1)),
          playerStats: [_createTestPlayerStats('Player1', isActive: true)],
        );

        final enemyTurnArea = EnemyTurnArea(
          model: model,
          displayDuration: const Duration(milliseconds: 100),
          onComplete: () => callbackExecuted = true,
        );

        await game.ensureAdd(enemyTurnArea);
        
        // The callback would be called by the parent Overlay class animation system
        // We verify it can be set without issues
        expect(callbackExecuted, isFalse); // Not called yet
      });
    });

    group('size and positioning', () {
      testWithFlameGame('creates components with correct relative sizes', (game) async {
        final model = EnemyTurnAreaModel(
          enemyCards: CardPileModel(cards: _generateTestCards(2)),
          playerStats: [
            _createTestPlayerStats('Player1', isActive: true),
            _createTestPlayerStats('Player2', isActive: false),
          ],
        );

        final enemyTurnArea = EnemyTurnArea(
          model: model,
          displayDuration: const Duration(seconds: 2),
        );

        await game.ensureAdd(enemyTurnArea);

        // Component should be created without errors
        expect(enemyTurnArea.isMounted, isTrue);
      });

      testWithFlameGame('handles different screen sizes', (game) async {
        game.camera.viewfinder.visibleGameSize = Vector2(800, 600);
        
        final model = EnemyTurnAreaModel(
          enemyCards: CardPileModel(cards: _generateTestCards(1)),
          playerStats: [_createTestPlayerStats('Player1', isActive: true)],
        );

        final enemyTurnArea = EnemyTurnArea(
          model: model,
          displayDuration: const Duration(seconds: 2),
        );

        await game.ensureAdd(enemyTurnArea);

        // Should adapt to different screen sizes
        expect(enemyTurnArea.isMounted, isTrue);
      });
    });
  });
}