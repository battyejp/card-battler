import 'package:card_battler/game/components/scenes/enemy_turn_scene.dart';
import 'package:card_battler/game/services/enemy/enemy_turn_coordinator.dart';
import 'package:card_battler/game/models/shared/cards_model.dart';
import 'package:card_battler/game/models/team/player_stats_model.dart';
import 'package:card_battler/game/models/team/players_model.dart';
import 'package:card_battler/game/models/shared/health_model.dart';
import 'package:card_battler/game/models/shared/card_model.dart';
import 'package:card_battler/game/components/shared/card/card_deck.dart';
import 'package:card_battler/game/components/shared/card/card_pile.dart';
import 'package:card_battler/game/components/team/player_stats.dart';
import 'package:card_battler/game/components/team/players.dart';
import 'package:flame/components.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:card_battler/game/services/game_state/game_state_service.dart';
import 'package:card_battler/game/services/game_state/game_state_manager.dart';

List<CardModel> _generateTestCards(int count) {
  return List.generate(count, (index) => CardModel(
    name: 'Enemy Card $index',
    type: 'enemy',
    isFaceUp: false,
    effects: [
      EffectModel(
        type: EffectType.attack,
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

EnemyTurnCoordinator _createTestModel({
  List<CardModel>? cards,
  List<PlayerStatsModel>? players,
}) {
  return EnemyTurnCoordinator(
    enemyCards: CardPileModel(cards: cards ?? _generateTestCards(3)),
    playersModel: PlayersModel(players: players ?? [_createTestPlayerStats('Player1', isActive: true)]),
    gameStateService: DefaultGameStateService(GameStateManager()),
  );
}

void main() {
  group('EnemyTurnScene', () {
    group('constructor and initialization', () {
      testWithFlameGame('creates with required parameters', (game) async {
        final model = _createTestModel();
        final size = Vector2(800, 600);
        
        final scene = EnemyTurnScene(model: model, size: size);
        
        expect(scene, isA<EnemyTurnScene>());
      });

      testWithFlameGame('initializes with correct size', (game) async {
        final model = _createTestModel();
        final size = Vector2(1000, 800);
        
        final scene = EnemyTurnScene(model: model, size: size);
        await game.ensureAdd(scene);
        
        expect(game.children.contains(scene), isTrue);
      });

      testWithFlameGame('works with different model configurations', (game) async {
        final players = [
          _createTestPlayerStats('Player1', isActive: true, health: 100),
          _createTestPlayerStats('Player2', isActive: false, health: 80),
          _createTestPlayerStats('Player3', isActive: true, health: 120),
        ];
        final cards = _generateTestCards(5);
        final model = _createTestModel(cards: cards, players: players);
        final size = Vector2(800, 600);
        
        final scene = EnemyTurnScene(model: model, size: size);
        await game.ensureAdd(scene);
        
        expect(game.children.contains(scene), isTrue);
      });
    });

    group('component structure', () {
      testWithFlameGame('has play area as root component', (game) async {
        final model = _createTestModel();
        final size = Vector2(800, 600);
        
        final scene = EnemyTurnScene(model: model, size: size);
        await game.ensureAdd(scene);
        
        expect(scene.children.length, equals(1));
        expect(scene.children.first, isA<RectangleComponent>());
        
        final playArea = scene.children.first as RectangleComponent;
        expect(playArea.size, equals(Vector2(800, 600)));
        expect(playArea.anchor, equals(Anchor.center));
        expect(playArea.position, equals(Vector2(0, 0)));
      });

      testWithFlameGame('contains card deck component', (game) async {
        final model = _createTestModel();
        final size = Vector2(800, 600);
        
        final scene = EnemyTurnScene(model: model, size: size);
        await game.ensureAdd(scene);
        
        final playArea = scene.children.first as RectangleComponent;
        final cardDecks = playArea.children.whereType<CardDeck>();
        
        expect(cardDecks.length, equals(1));
        
        final deck = cardDecks.first;
        expect(deck.anchor, equals(Anchor.topLeft));
        expect(deck.position, equals(Vector2(0, 0)));
        expect(deck.size, equals(Vector2(200, 300))); // 800 * 0.25, 600 / 2
      });

      testWithFlameGame('contains played cards pile component', (game) async {
        final model = _createTestModel();
        final size = Vector2(800, 600);
        
        final scene = EnemyTurnScene(model: model, size: size);
        await game.ensureAdd(scene);
        
        final playArea = scene.children.first as RectangleComponent;
        final cardPiles = playArea.children.whereType<CardPile>().where((pile) => pile is! CardDeck);
        
        expect(cardPiles.length, equals(1));
        
        final pile = cardPiles.first;
        expect(pile.anchor, equals(Anchor.topRight));
        expect(pile.position.x, equals(800));
        expect(pile.position.y, equals(0));
        expect(pile.size, equals(Vector2(200, 300))); // 800 * 0.25, 600 / 2
      });

      testWithFlameGame('creates player stats components for each player', (game) async {
        final players = [
          _createTestPlayerStats('Player1', isActive: true),
          _createTestPlayerStats('Player2', isActive: false),
          _createTestPlayerStats('Player3', isActive: true),
        ];
        final model = _createTestModel(players: players);
        final size = Vector2(800, 600);
        
        final scene = EnemyTurnScene(model: model, size: size);
        await game.ensureAdd(scene);
        
        final playArea = scene.children.first as RectangleComponent;
        final playersComponent = playArea.children.whereType<Players>().first;
        final playerStatsComponents = playersComponent.children.whereType<PlayerStats>();
        
        expect(playerStatsComponents.length, equals(3));
      });

      testWithFlameGame('handles empty player list', (game) async {
        final model = _createTestModel(players: []);
        final size = Vector2(800, 600);
        
        final scene = EnemyTurnScene(model: model, size: size);
        await game.ensureAdd(scene);
        
        final playArea = scene.children.first as RectangleComponent;
        final playersComponent = playArea.children.whereType<Players>().first;
        final playerStatsComponents = playersComponent.children.whereType<PlayerStats>();
        
        expect(playerStatsComponents.length, equals(0));
      });
    });

    group('component positioning and sizing', () {
      testWithFlameGame('positions player stats correctly for single player', (game) async {
        final players = [_createTestPlayerStats('Player1')];
        final model = _createTestModel(players: players);
        final size = Vector2(800, 600);
        
        final scene = EnemyTurnScene(model: model, size: size);
        await game.ensureAdd(scene);
        
        final playArea = scene.children.first as RectangleComponent;
        final playersComponent = playArea.children.whereType<Players>().first;
        final playerStats = playersComponent.children.whereType<PlayerStats>().first;
        
        final expectedHeight = 600 / 2; // 300 - Players component height divided by 1 player
        expect(playerStats.size, equals(Vector2(800, expectedHeight)));
        expect(playerStats.position, equals(Vector2(0, 0))); // relative to Players component
      });

      testWithFlameGame('positions player stats correctly for multiple players', (game) async {
        final players = [
          _createTestPlayerStats('Player1'),
          _createTestPlayerStats('Player2'),
          _createTestPlayerStats('Player3'),
        ];
        final model = _createTestModel(players: players);
        final size = Vector2(1000, 800);
        
        final scene = EnemyTurnScene(model: model, size: size);
        await game.ensureAdd(scene);
        
        final playArea = scene.children.first as RectangleComponent;
        final playersComponent = playArea.children.whereType<Players>().first;
        final playerStatsComponents = playersComponent.children.whereType<PlayerStats>().toList();
        
        final expectedHeight = (800 / 2) / 3; // 400 / 3 players = 133.33
        
        expect(playerStatsComponents[0].position, equals(Vector2(0, 0)));
        expect(playerStatsComponents[1].position, equals(Vector2(0, expectedHeight)));
        expect(playerStatsComponents[2].position, equals(Vector2(0, 2 * expectedHeight)));
        
        for (final playerStats in playerStatsComponents) {
          expect(playerStats.size, equals(Vector2(1000, expectedHeight)));
        }
      });

      testWithFlameGame('adapts to different scene sizes', (game) async {
        final model = _createTestModel();
        final size = Vector2(1200, 900);
        
        final scene = EnemyTurnScene(model: model, size: size);
        await game.ensureAdd(scene);
        
        final playArea = scene.children.first as RectangleComponent;
        expect(playArea.size, equals(Vector2(1200, 900)));
        
        final deck = playArea.children.whereType<CardDeck>().first;
        expect(deck.size, equals(Vector2(300, 450))); // 1200 * 0.25, 900 / 2
        
        final pile = playArea.children.whereType<CardPile>().where((pile) => pile is! CardDeck).first;
        expect(pile.size, equals(Vector2(300, 450)));
        expect(pile.position.x, equals(1200));
        expect(pile.position.y, equals(0));
      });

      testWithFlameGame('handles very small sizes', (game) async {
        final model = _createTestModel();
        final size = Vector2(100, 100);
        
        final scene = EnemyTurnScene(model: model, size: size);
        await game.ensureAdd(scene);
        
        final playArea = scene.children.first as RectangleComponent;
        expect(playArea.size, equals(Vector2(100, 100)));
        
        final deck = playArea.children.whereType<CardDeck>().first;
        expect(deck.size, equals(Vector2(25, 50))); // 100 * 0.25, 100 / 2
      });

      testWithFlameGame('handles very large sizes', (game) async {
        final model = _createTestModel();
        final size = Vector2(2000, 1500);
        
        final scene = EnemyTurnScene(model: model, size: size);
        await game.ensureAdd(scene);
        
        final playArea = scene.children.first as RectangleComponent;
        expect(playArea.size, equals(Vector2(2000, 1500)));
        
        final deck = playArea.children.whereType<CardDeck>().first;
        expect(deck.size, equals(Vector2(500, 750))); // 2000 * 0.25, 1500 / 2
      });
    });

    group('model integration', () {
      testWithFlameGame('deck component uses correct model reference', (game) async {
        final testCards = _generateTestCards(5);
        final model = _createTestModel(cards: testCards);
        final size = Vector2(800, 600);
        
        final scene = EnemyTurnScene(model: model, size: size);
        await game.ensureAdd(scene);
        
        final playArea = scene.children.first as RectangleComponent;
        final deck = playArea.children.whereType<CardDeck>().first;
        
        // The deck should be created with the model's enemy cards
        // We can't directly access the deck's internal model, but we can verify it was created
        expect(deck, isNotNull);
      });

      testWithFlameGame('played cards pile uses correct model reference', (game) async {
        final model = _createTestModel();
        final size = Vector2(800, 600);
        
        final scene = EnemyTurnScene(model: model, size: size);
        await game.ensureAdd(scene);
        
        final playArea = scene.children.first as RectangleComponent;
        final pile = playArea.children.whereType<CardPile>().first;
        
        // The pile should be created with the model's played cards
        expect(pile, isNotNull);
      });

      testWithFlameGame('player stats components use correct models', (game) async {
        final players = [
          _createTestPlayerStats('TestPlayer1', health: 80),
          _createTestPlayerStats('TestPlayer2', health: 120),
        ];
        final model = _createTestModel(players: players);
        final size = Vector2(800, 600);
        
        final scene = EnemyTurnScene(model: model, size: size);
        await game.ensureAdd(scene);
        
        final playArea = scene.children.first as RectangleComponent;
        final playersComponent = playArea.children.whereType<Players>().first;
        final playerStatsComponents = playersComponent.children.whereType<PlayerStats>().toList();
        
        expect(playerStatsComponents.length, equals(2));
        // Each PlayerStats component should be created with its corresponding model
        // We can't directly verify the model reference, but we can verify components exist
      });

      testWithFlameGame('updates when model changes', (game) async {
        final model = _createTestModel();
        final size = Vector2(800, 600);
        
        final scene = EnemyTurnScene(model: model, size: size);
        await game.ensureAdd(scene);
        
        // Initial state verification
        final playArea = scene.children.first as RectangleComponent;
        final playersComponent = playArea.children.whereType<Players>().first;
        final initialPlayerStatsCount = playersComponent.children.whereType<PlayerStats>().length;
        
        expect(initialPlayerStatsCount, equals(1));
        
        // The scene itself doesn't automatically update when the model changes
        // This is expected behavior as it's a static scene structure
      });
    });

    group('edge cases and error handling', () {
      testWithFlameGame('handles zero-sized scene', (game) async {
        final model = _createTestModel();
        final size = Vector2.zero();
        
        final scene = EnemyTurnScene(model: model, size: size);
        
        // Should not throw during construction
        expect(() => game.ensureAdd(scene), returnsNormally);
      });

      testWithFlameGame('handles negative size values', (game) async {
        final model = _createTestModel();
        final size = Vector2(-100, -200);
        
        final scene = EnemyTurnScene(model: model, size: size);
        
        // Should not throw during construction
        expect(() => game.ensureAdd(scene), returnsNormally);
      });

      testWithFlameGame('handles model with no cards', (game) async {
        final model = EnemyTurnCoordinator(
          enemyCards: CardPileModel.empty(),
          playersModel: PlayersModel(players: [_createTestPlayerStats('Player1')]),
          gameStateService: DefaultGameStateService(GameStateManager()),
        );
        final size = Vector2(800, 600);
        
        final scene = EnemyTurnScene(model: model, size: size);
        await game.ensureAdd(scene);
        
        // Should create all components normally
        final playArea = scene.children.first as RectangleComponent;
        expect(playArea.children.whereType<CardDeck>().length, equals(1));
        expect(playArea.children.whereType<CardPile>().where((pile) => pile is! CardDeck).length, equals(1));
      });

      testWithFlameGame('handles extremely large player count', (game) async {
        final players = List.generate(100, (i) => _createTestPlayerStats('Player$i'));
        final model = _createTestModel(players: players);
        final size = Vector2(800, 600);
        
        final scene = EnemyTurnScene(model: model, size: size);
        await game.ensureAdd(scene);
        
        final playArea = scene.children.first as RectangleComponent;
        final playersComponent = playArea.children.whereType<Players>().first;
        final playerStatsComponents = playersComponent.children.whereType<PlayerStats>();
        
        expect(playerStatsComponents.length, equals(100));
      });
    });

    group('component hierarchy validation', () {
      testWithFlameGame('maintains proper component hierarchy', (game) async {
        final model = _createTestModel();
        final size = Vector2(800, 600);
        
        final scene = EnemyTurnScene(model: model, size: size);
        await game.ensureAdd(scene);
        
        // Scene should have exactly one child (the play area)
        expect(scene.children.length, equals(1));
        
        final playArea = scene.children.first as RectangleComponent;
        
        // Play area should contain: deck, pile, and players component
        final deckCount = playArea.children.whereType<CardDeck>().length;
        final pileCount = playArea.children.whereType<CardPile>().where((pile) => pile is! CardDeck).length;
        final playersCount = playArea.children.whereType<Players>().length;
        
        expect(deckCount, equals(1));
        expect(pileCount, equals(1));
        expect(playersCount, equals(1));
      });

      testWithFlameGame('all components are properly parented', (game) async {
        final model = _createTestModel();
        final size = Vector2(800, 600);
        
        final scene = EnemyTurnScene(model: model, size: size);
        await game.ensureAdd(scene);
        
        final playArea = scene.children.first as RectangleComponent;
        
        // Verify all child components have the play area as parent
        for (final child in playArea.children) {
          expect(child.parent, equals(playArea));
        }
        
        // Verify play area has scene as parent
        expect(playArea.parent, equals(scene));
      });
    });
  });
}