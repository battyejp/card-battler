import 'package:card_battler/game/components/enemy/enemies.dart';
import 'package:card_battler/game/components/enemy/enemy_turn_area.dart';
import 'package:card_battler/game/components/shared/card_focus_overlay.dart';
import 'package:card_battler/game/components/shop/shop.dart';
import 'package:card_battler/game/components/team/team.dart';
import 'package:card_battler/game/models/game_state_model.dart';
import 'package:card_battler/game/models/shared/card_model.dart';
import 'package:card_battler/game/models/shop/shop_card_model.dart';
import 'package:flame/game.dart';
import 'components/player/player.dart';

class CardBattlerGame extends FlameGame {
  GameStateModel? _gameState;
  Vector2? _testSize;
  EnemyTurnArea? _enemyTurnArea;

  // Default constructor with new game state
  CardBattlerGame();

  // Test-only constructor to set size before onLoad
  CardBattlerGame.withSize(Vector2 testSize) : _testSize = testSize;

  static const double margin = 20.0;
  static const double topLayoutHeightFactor = 0.6;

  @override
  Future<void> onLoad() async {
    List<ShopCardModel> shopCards = [];
    List<CardModel> playerDeckCards = [];
    List<CardModel> enemyCards = [];

    if (_testSize != null) {
      onGameResize(_testSize!);

      shopCards = List.generate(
          10,
          (index) => ShopCardModel(name: 'Test Card ${index + 1}', cost: 1),
        );

      playerDeckCards = List.generate(
          10,
          (index) => CardModel(
            name: 'Card ${index + 1}',
            type: 'Player',
            isFaceUp: false,
          ),
        );

        enemyCards = List.generate(
          10,
          (index) => CardModel(
            name: 'Enemy Card ${index + 1}',
            type: 'Enemy',
            isFaceUp: false,
          ),
        );
    }
    else {
        shopCards = await loadCardsFromJson<ShopCardModel>(
          'assets/data/shop_cards.json',
          ShopCardModel.fromJson,
        );

        playerDeckCards = await loadCardsFromJson<CardModel>(
          'assets/data/hero_starting_cards.json',
          CardModel.fromJson,
        );

        enemyCards = await loadCardsFromJson<CardModel>(
          'assets/data/enemy_cards.json',
          CardModel.fromJson,
        );
    }

    _gameState = GameStateModel.newGame(shopCards, playerDeckCards, enemyCards);
    _gameState!.enemyTurnArea.onTurnFinished = _onEnemyTurnFinished;
    _loadGameComponents();
  }

  void _onPlayerCardsDrawn() {
    _showEnemiesTurn();
  }
  
  void _onEnemyTurnFinished() {
    _enemyTurnArea!.startFadeOut();
  }

  void _onHandCardTapped(CardModel card) {
    _showCardFocus(card, 'Play', () {
      // Handle playing the card
      // TODO: Implement card play logic
    });
  }

  void _onShopCardTapped(CardModel card) {
    _showCardFocus(card, 'Buy', () {
      // Handle buying the card
      // TODO: Implement card purchase logic
    });
  }

  void _showCardFocus(CardModel card, String actionLabel, void Function() onAction) {
    final overlay = CardFocusOverlay(
      cardModel: card,
      actionLabel: actionLabel,
      onActionPressed: onAction,
      onComplete: () {
        // Overlay dismissed
      },
    )..size = size;

    camera.viewport.add(overlay);
  }

  void _showEnemiesTurn() {
    // Show announcement with current enemy state
    _enemyTurnArea = EnemyTurnArea(
      displayDuration: const Duration(seconds: 5),
      onComplete: () {
      },
      model: _gameState!.enemyTurnArea,
    );

    _enemyTurnArea!.size = size;
    camera.viewport.add(_enemyTurnArea!);
  }

  void _loadGameComponents() {
    if (_gameState == null) {
      return;
    }

    final availableHeight = size.y - (margin * 2);
    final availableWidth = size.x - (margin * 2);
    final topLayoutHeight = availableHeight * topLayoutHeightFactor;
    final bottomLayoutHeight = availableHeight - topLayoutHeight;
    final topPositionY = -1 * (size.y / 2) + margin;

    // Create player component with models from game state
    final player = Player(
      playerModel: _gameState!.player,
      onCardsDrawn: _onPlayerCardsDrawn,
      onHandCardTapped: _onHandCardTapped,
    )
      ..size = Vector2(availableWidth, bottomLayoutHeight)
      ..position = Vector2(
        (0 - size.x / 2) + margin,
        (size.y / 2) - margin - bottomLayoutHeight,
      );

    world.add(player);

    // Create enemies component with model from game state
    final enemiesWidth = availableWidth * 0.5;
    final enemies = Enemies(model: _gameState!.enemies)
      ..size = Vector2(enemiesWidth, topLayoutHeight)
      ..position = Vector2((0 - enemiesWidth / 2), topPositionY);

    world.add(enemies);

    // Create shop component with model from game state
    final shopWidth = availableWidth * 0.5 / 2;
    final shop = Shop(_gameState!.shop, onCardTapped: _onShopCardTapped)
      ..size = Vector2(shopWidth, topLayoutHeight)
      ..position = Vector2(enemies.position.x + enemiesWidth, topPositionY);

    world.add(shop);

    // Create team component with model from game state
    final team = Team(_gameState!.team)
      ..size = Vector2(shopWidth, topLayoutHeight)
      ..position = Vector2(0 - enemiesWidth / 2 - shopWidth, topPositionY);

    world.add(team);
  }

  // /// Saves the current game state to JSON
  // Map<String, dynamic> saveGame() {
  //   return _gameState.toJson();
  // }

  // /// Loads a game from JSON data
  // static CardBattlerGame loadGame(Map<String, dynamic> jsonData) {
  //   final gameState = GameStateModel.fromJson(jsonData);
  //   return CardBattlerGame.withState(gameState);
  // }
}
