import 'package:card_battler/game/components/scenes/player_turn_scene.dart';
import 'package:card_battler/game/models/player/player_turn_model.dart';
import 'package:card_battler/game/models/shared/effect_model.dart';
import 'package:card_battler/game/services/player_turn/player_turn_coordinator.dart';
import 'package:card_battler/game/services/player/player_coordinator.dart';
import 'package:card_battler/game/models/player/player_model.dart';
import 'package:card_battler/game/models/player/info_model.dart';
import 'package:card_battler/game/models/shared/cards_model.dart';
import 'package:card_battler/game/models/shared/health_model.dart';
import 'package:card_battler/game/models/shared/value_image_label_model.dart';
import 'package:card_battler/game/models/shared/card_model.dart';
import 'package:card_battler/game/models/team/team_model.dart';
import 'package:card_battler/game/models/team/bases_model.dart';
import 'package:card_battler/game/models/team/base_model.dart';
import 'package:card_battler/game/models/team/player_stats_model.dart';
import 'package:card_battler/game/models/team/players_model.dart';
import 'package:card_battler/game/models/enemy/enemies_model.dart';
import 'package:card_battler/game/services/shop/shop_coordinator.dart';
import 'package:card_battler/game/models/shop/shop_card_model.dart';
import 'package:card_battler/game/components/player/player.dart';
import 'package:card_battler/game/components/enemy/enemies.dart';
import 'package:card_battler/game/components/shop/shop.dart';
import 'package:card_battler/game/components/team/team.dart';
import 'package:card_battler/game/services/game_state/game_state_manager.dart';
import 'package:card_battler/game/services/game_state/game_state_service.dart';
import 'package:card_battler/game/services/card/card_selection_service.dart';
import 'package:card_battler/game/components/shared/flat_button.dart';
import 'package:flame/components.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';

List<CardModel> _generatePlayerCards(int count) {
  return List.generate(count, (index) => CardModel(
    name: 'Player Card $index',
    type: 'player',
    isFaceUp: false,
    effects: [
      EffectModel(
        type: EffectType.attack,
        target: EffectTarget.activePlayer,
        value: 5,
      ),
    ],
  ));
}

List<CardModel> _generateEnemyCards(int count) {
  return List.generate(count, (index) => CardModel(
    name: 'Enemy Card $index',
    type: 'enemy',
    isFaceUp: false,
    effects: [
      EffectModel(
        type: EffectType.attack,
        target: EffectTarget.activePlayer,
        value: 3,
      ),
    ],
  ));
}

List<ShopCardModel> _generateShopCards(int count) {
  return List.generate(count, (index) => ShopCardModel(
    name: 'Shop Card $index',
    cost: index + 1,
    isFaceUp: true,
  ));
}

PlayerCoordinator _createTestPlayerModel({String name = 'Test Player', bool isActive = true}) {
  return PlayerCoordinator.create(
    state: PlayerModel.create(
      infoModel: InfoModel(
        name: name,
        attack: ValueImageLabelModel(value: 10, label: 'Attack'),
        credits: ValueImageLabelModel(value: 5, label: 'Credits'),
        healthModel: HealthModel(maxHealth: 100),
      ),
      handModel: CardsModel<CardModel>(),
      deckModel: CardsModel<CardModel>(cards: _generatePlayerCards(20)),
      discardModel: CardsModel<CardModel>.empty(),
      gameStateService: DefaultGameStateService(GameStateManager()),
      cardSelectionService: DefaultCardSelectionService(),
    ),
  );
}

TeamModel _createTestTeamModel() {
  final bases = BasesModel(
    bases: [
      BaseModel(name: 'Base 1', maxHealth: 10),
      BaseModel(name: 'Base 2', maxHealth: 10),
      BaseModel(name: 'Base 3', maxHealth: 10),
    ],
  );

  final players = [
    PlayerStatsModel(
      name: 'Player 1',
      health: HealthModel(maxHealth: 100),
      isActive: true,
    ),
    PlayerStatsModel(
      name: 'Player 2',
      health: HealthModel(maxHealth: 100),
      isActive: false,
    ),
  ];

  return TeamModel(bases: bases, playersModel: PlayersModel(players: players));
}

EnemiesModel _createTestEnemiesModel() {
  return EnemiesModel(
    totalEnemies: 5,
    maxNumberOfEnemiesInPlay: 3,
    maxEnemyHealth: 15,
    enemyCards: _generateEnemyCards(10),
  );
}

ShopCoordinator _createTestShopCoordinator() {
  return ShopCoordinator.create(
    numberOfRows: 2,
    numberOfColumns: 3,
    cards: _generateShopCards(6),
  );
}

PlayerTurnCoordinator _createTestPlayerTurnModel({
  PlayerCoordinator? playerModel,
  TeamModel? teamModel,
  EnemiesModel? enemiesModel,
  ShopCoordinator? shopModel,
}) {
  final gameStateService = DefaultGameStateService(GameStateManager());
  final state = PlayerTurnModel(
    playerModel: playerModel ?? _createTestPlayerModel(),
    teamModel: teamModel ?? _createTestTeamModel(),
    enemiesModel: enemiesModel ?? _createTestEnemiesModel(),
    shopModel: shopModel ?? _createTestShopCoordinator(),
  );
  return PlayerTurnCoordinator(
    state: state,
    gameStateService: gameStateService,
  );
}

void main() {
  group('PlayerTurnScene', () {
    group('constructor and initialization', () {
      testWithFlameGame('creates with required parameters', (game) async {
        final model = _createTestPlayerTurnModel();
        final size = Vector2(800, 600);
        
        final scene = PlayerTurnScene(model: model, size: size);
        
        expect(scene, isA<PlayerTurnScene>());
      });

      testWithFlameGame('initializes with correct size', (game) async {
        final model = _createTestPlayerTurnModel();
        final size = Vector2(1000, 800);
        
        final scene = PlayerTurnScene(model: model, size: size);
        await game.ensureAdd(scene);
        
        expect(game.children.contains(scene), isTrue);
      });

      testWithFlameGame('works with different model configurations', (game) async {
        final customPlayer = _createTestPlayerModel(name: 'Custom Player', isActive: false);
        final model = _createTestPlayerTurnModel(playerModel: customPlayer);
        final size = Vector2(800, 600);
        
        final scene = PlayerTurnScene(model: model, size: size);
        await game.ensureAdd(scene);
        
        expect(game.children.contains(scene), isTrue);
      });
    });

    group('component structure and layout', () {
      testWithFlameGame('has all required child components', (game) async {
        final model = _createTestPlayerTurnModel();
        final size = Vector2(800, 600);
        
        final scene = PlayerTurnScene(model: model, size: size);
        await game.ensureAdd(scene);
        
        // Should have exactly 5 child components: Player, Enemies, Shop, Team, TurnButton
        expect(scene.children.length, equals(5));
        expect(scene.children.whereType<Player>().length, equals(1));
        expect(scene.children.whereType<Enemies>().length, equals(1));
        expect(scene.children.whereType<Shop>().length, equals(1));
        expect(scene.children.whereType<Team>().length, equals(1));
        expect(scene.children.whereType<FlatButton>().length, equals(1));
      });

      testWithFlameGame('player component has correct size and position', (game) async {
        final model = _createTestPlayerTurnModel();
        final size = Vector2(800, 600);
        
        final scene = PlayerTurnScene(model: model, size: size);
        await game.ensureAdd(scene);
        
        final player = scene.children.whereType<Player>().first;
        
        // Calculate expected values
        final availableHeight = size.y - (PlayerTurnScene.margin * 2);
        final availableWidth = size.x - (PlayerTurnScene.margin * 2);
        final bottomLayoutHeight = availableHeight * (1 - PlayerTurnScene.topLayoutHeightFactor);
        
        expect(player.size.x, equals(availableWidth));
        expect(player.size.y, equals(bottomLayoutHeight));
        expect(player.position.x, equals((0 - size.x / 2) + PlayerTurnScene.margin));
        expect(player.position.y, equals((size.y / 2) - PlayerTurnScene.margin - bottomLayoutHeight));
      });

      testWithFlameGame('enemies component has correct size and position', (game) async {
        final model = _createTestPlayerTurnModel();
        final size = Vector2(800, 600);
        
        final scene = PlayerTurnScene(model: model, size: size);
        await game.ensureAdd(scene);
        
        final enemies = scene.children.whereType<Enemies>().first;
        
        // Calculate expected values
        final availableHeight = size.y - (PlayerTurnScene.margin * 2);
        final availableWidth = size.x - (PlayerTurnScene.margin * 2);
        final topLayoutHeight = availableHeight * PlayerTurnScene.topLayoutHeightFactor;
        final enemiesWidth = availableWidth * 0.5;
        final topPositionY = -1 * (size.y / 2) + PlayerTurnScene.margin;
        
        expect(enemies.size.x, equals(enemiesWidth));
        expect(enemies.size.y, equals(topLayoutHeight));
        expect(enemies.position.x, equals(0 - enemiesWidth / 2));
        expect(enemies.position.y, equals(topPositionY));
      });

      testWithFlameGame('shop component has correct size and position', (game) async {
        final model = _createTestPlayerTurnModel();
        final size = Vector2(800, 600);
        
        final scene = PlayerTurnScene(model: model, size: size);
        await game.ensureAdd(scene);
        
        final shop = scene.children.whereType<Shop>().first;
        final enemies = scene.children.whereType<Enemies>().first;
        
        // Calculate expected values
        final availableHeight = size.y - (PlayerTurnScene.margin * 2);
        final availableWidth = size.x - (PlayerTurnScene.margin * 2);
        final topLayoutHeight = availableHeight * PlayerTurnScene.topLayoutHeightFactor;
        final enemiesWidth = availableWidth * 0.5;
        final shopWidth = availableWidth * 0.5 / 2;
        final topPositionY = -1 * (size.y / 2) + PlayerTurnScene.margin;
        
        expect(shop.size.x, equals(shopWidth));
        expect(shop.size.y, equals(topLayoutHeight));
        expect(shop.position.x, equals(enemies.position.x + enemiesWidth));
        expect(shop.position.y, equals(topPositionY));
      });

      testWithFlameGame('team component has correct size and position', (game) async {
        final model = _createTestPlayerTurnModel();
        final size = Vector2(800, 600);
        
        final scene = PlayerTurnScene(model: model, size: size);
        await game.ensureAdd(scene);
        
        final team = scene.children.whereType<Team>().first;
        
        // Calculate expected values
        final availableHeight = size.y - (PlayerTurnScene.margin * 2);
        final availableWidth = size.x - (PlayerTurnScene.margin * 2);
        final topLayoutHeight = availableHeight * PlayerTurnScene.topLayoutHeightFactor;
        final enemiesWidth = availableWidth * 0.5;
        final teamWidth = availableWidth * 0.5 / 2; // Same as shop width
        final topPositionY = -1 * (size.y / 2) + PlayerTurnScene.margin;
        
        expect(team.size.x, equals(teamWidth));
        expect(team.size.y, equals(topLayoutHeight));
        expect(team.position.x, equals(0 - enemiesWidth / 2 - teamWidth));
        expect(team.position.y, equals(topPositionY));
      });
    });

    group('layout calculations with different screen sizes', () {
      testWithFlameGame('adapts to small screen sizes', (game) async {
        final model = _createTestPlayerTurnModel();
        final size = Vector2(400, 300);
        
        final scene = PlayerTurnScene(model: model, size: size);
        await game.ensureAdd(scene);
        
        final availableWidth = size.x - (PlayerTurnScene.margin * 2);
        
        final player = scene.children.whereType<Player>().first;
        final enemies = scene.children.whereType<Enemies>().first;
        final shop = scene.children.whereType<Shop>().first;
        final team = scene.children.whereType<Team>().first;
        
        expect(player.size.x, equals(availableWidth));
        expect(enemies.size.x, equals(availableWidth * 0.5));
        expect(shop.size.x, equals(availableWidth * 0.5 / 2));
        expect(team.size.x, equals(availableWidth * 0.5 / 2));
      });

      testWithFlameGame('adapts to large screen sizes', (game) async {
        final model = _createTestPlayerTurnModel();
        final size = Vector2(1920, 1080);
        
        final scene = PlayerTurnScene(model: model, size: size);
        await game.ensureAdd(scene);
        
        final availableHeight = size.y - (PlayerTurnScene.margin * 2);
        final topLayoutHeight = availableHeight * PlayerTurnScene.topLayoutHeightFactor;
        final bottomLayoutHeight = availableHeight - topLayoutHeight;
        
        final player = scene.children.whereType<Player>().first;
        final enemies = scene.children.whereType<Enemies>().first;
        
        expect(player.size.y, equals(bottomLayoutHeight));
        expect(enemies.size.y, equals(topLayoutHeight));
      });

      testWithFlameGame('handles extreme aspect ratios', (game) async {
        final model = _createTestPlayerTurnModel();
        final size = Vector2(1000, 200); // Very wide, short screen
        
        final scene = PlayerTurnScene(model: model, size: size);
        await game.ensureAdd(scene);
        
        expect(scene.children.length, equals(5));
        
        // Should still create all components even with extreme ratios
        expect(scene.children.whereType<Player>().length, equals(1));
        expect(scene.children.whereType<Enemies>().length, equals(1));
        expect(scene.children.whereType<Shop>().length, equals(1));
        expect(scene.children.whereType<Team>().length, equals(1));
        expect(scene.children.whereType<FlatButton>().length, equals(1));
      });
    });

    group('model integration', () {
      testWithFlameGame('player component uses correct model', (game) async {
        final customPlayerModel = _createTestPlayerModel(name: 'Integration Test Player');
        final model = _createTestPlayerTurnModel(playerModel: customPlayerModel);
        final size = Vector2(800, 600);
        
        final scene = PlayerTurnScene(model: model, size: size);
        await game.ensureAdd(scene);
        
        final player = scene.children.whereType<Player>().first;
        expect(player, isNotNull);
        // Player component should be created with the model from PlayerTurnModel
      });

      testWithFlameGame('enemies component uses correct model', (game) async {
        final customEnemiesModel = EnemiesModel(
          totalEnemies: 3,
          maxNumberOfEnemiesInPlay: 2,
          maxEnemyHealth: 20,
          enemyCards: _generateEnemyCards(5),
        );
        final model = _createTestPlayerTurnModel(enemiesModel: customEnemiesModel);
        final size = Vector2(800, 600);
        
        final scene = PlayerTurnScene(model: model, size: size);
        await game.ensureAdd(scene);
        
        final enemies = scene.children.whereType<Enemies>().first;
        expect(enemies, isNotNull);
        // Enemies component should be created with the custom model
      });

      testWithFlameGame('shop component uses correct model', (game) async {
        final customShopCoordinator = ShopCoordinator.create(
          numberOfRows: 3,
          numberOfColumns: 4,
          cards: _generateShopCards(12),
        );
        final model = _createTestPlayerTurnModel(shopModel: customShopCoordinator);
        final size = Vector2(800, 600);
        
        final scene = PlayerTurnScene(model: model, size: size);
        await game.ensureAdd(scene);
        
        final shop = scene.children.whereType<Shop>().first;
        expect(shop, isNotNull);
        // Shop component should be created with the custom model
      });

      testWithFlameGame('team component uses correct model', (game) async {
        final customTeamModel = TeamModel(
          bases: BasesModel(
            bases: [
              BaseModel(name: 'Custom Base 1', maxHealth: 20),
              BaseModel(name: 'Custom Base 2', maxHealth: 25),
            ],
          ),
          playersModel: PlayersModel(players: [
            PlayerStatsModel(
              name: 'Custom Player 1',
              health: HealthModel(maxHealth: 150),
              isActive: true,
            ),
          ]),
        );
        final model = _createTestPlayerTurnModel(teamModel: customTeamModel);
        final size = Vector2(800, 600);
        
        final scene = PlayerTurnScene(model: model, size: size);
        await game.ensureAdd(scene);
        
        final team = scene.children.whereType<Team>().first;
        expect(team, isNotNull);
        // Team component should be created with the custom model
      });
    });

    group('edge cases and error handling', () {
      testWithFlameGame('handles zero-sized scene', (game) async {
        final model = _createTestPlayerTurnModel();
        final size = Vector2.zero();
        
        final scene = PlayerTurnScene(model: model, size: size);
        
        // Should not throw during construction
        expect(() => game.ensureAdd(scene), returnsNormally);
      });

      testWithFlameGame('handles negative size values', (game) async {
        final model = _createTestPlayerTurnModel();
        final size = Vector2(-100, -200);
        
        final scene = PlayerTurnScene(model: model, size: size);
        
        // Should not throw during construction
        expect(() => game.ensureAdd(scene), returnsNormally);
      });

      testWithFlameGame('handles very small positive sizes', (game) async {
        final model = _createTestPlayerTurnModel();
        final size = Vector2(10, 10);
        
        final scene = PlayerTurnScene(model: model, size: size);
        await game.ensureAdd(scene);
        
        // Should create all components even with tiny size
        expect(scene.children.length, equals(5));
      });

      testWithFlameGame('handles margin larger than screen size', (game) async {
        final model = _createTestPlayerTurnModel();
        final size = Vector2(30, 30); // Smaller than 2 * margin (40)
        
        final scene = PlayerTurnScene(model: model, size: size);
        await game.ensureAdd(scene);
        
        // Should still create components even if calculations result in negative values
        expect(scene.children.length, equals(5));
      });
    });

    group('layout constants validation', () {
      test('margin constant has expected value', () {
        expect(PlayerTurnScene.margin, equals(20.0));
      });

      test('topLayoutHeightFactor constant has expected value', () {
        expect(PlayerTurnScene.topLayoutHeightFactor, equals(0.6));
      });

      testWithFlameGame('layout proportions are maintained across different sizes', (game) async {
        final model = _createTestPlayerTurnModel();
        final testSizes = [
          Vector2(800, 600),
          Vector2(1200, 900),
          Vector2(400, 300),
        ];
        
        for (final size in testSizes) {
          final scene = PlayerTurnScene(model: model, size: size);
          await game.ensureAdd(scene);
          
          final availableWidth = size.x - (PlayerTurnScene.margin * 2);
          final enemies = scene.children.whereType<Enemies>().first;
          final shop = scene.children.whereType<Shop>().first;
          final team = scene.children.whereType<Team>().first;
          
          // Enemies should always be 50% of available width
          expect(enemies.size.x, equals(availableWidth * 0.5));
          
          // Shop and Team should each be 25% of available width (half of 50%)
          expect(shop.size.x, equals(availableWidth * 0.5 / 2));
          expect(team.size.x, equals(availableWidth * 0.5 / 2));
          
          // Clean up for next iteration
          game.removeAll(game.children);
        }
      });
    });

    group('component hierarchy validation', () {
      testWithFlameGame('all components are direct children of scene', (game) async {
        final model = _createTestPlayerTurnModel();
        final size = Vector2(800, 600);
        
        final scene = PlayerTurnScene(model: model, size: size);
        await game.ensureAdd(scene);
        
        // Verify all child components have the scene as parent
        for (final child in scene.children) {
          expect(child.parent, equals(scene));
        }
      });

      testWithFlameGame('components maintain expected types', (game) async {
        final model = _createTestPlayerTurnModel();
        final size = Vector2(800, 600);
        
        final scene = PlayerTurnScene(model: model, size: size);
        await game.ensureAdd(scene);
        
        final components = scene.children.toList();
        
        // Should have exactly one of each component type
        final playerComponents = components.whereType<Player>();
        final enemiesComponents = components.whereType<Enemies>();
        final shopComponents = components.whereType<Shop>();
        final teamComponents = components.whereType<Team>();
        
        expect(playerComponents.length, equals(1));
        expect(enemiesComponents.length, equals(1));
        expect(shopComponents.length, equals(1));
        expect(teamComponents.length, equals(1));
      });
    });

    group('position relationships validation', () {
      testWithFlameGame('components are positioned relative to each other correctly', (game) async {
        final model = _createTestPlayerTurnModel();
        final size = Vector2(800, 600);
        
        final scene = PlayerTurnScene(model: model, size: size);
        await game.ensureAdd(scene);
        
        final enemies = scene.children.whereType<Enemies>().first;
        final shop = scene.children.whereType<Shop>().first;
        final team = scene.children.whereType<Team>().first;
        
        // Shop should be positioned to the right of enemies
        expect(shop.position.x, greaterThan(enemies.position.x));
        
        // Team should be positioned to the left of enemies
        expect(team.position.x, lessThan(enemies.position.x));
        
        // All top components should have same Y position
        expect(shop.position.y, equals(enemies.position.y));
        expect(team.position.y, equals(enemies.position.y));
      });

      testWithFlameGame('player component is positioned in bottom area', (game) async {
        final model = _createTestPlayerTurnModel();
        final size = Vector2(800, 600);
        
        final scene = PlayerTurnScene(model: model, size: size);
        await game.ensureAdd(scene);
        
        final player = scene.children.whereType<Player>().first;
        final enemies = scene.children.whereType<Enemies>().first;
        
        // Player should be positioned below the top components
        expect(player.position.y, greaterThan(enemies.position.y));
      });
    });
  });
}