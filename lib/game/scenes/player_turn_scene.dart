import 'package:card_battler/game/card_battler_game.dart';
import 'package:card_battler/game/components/enemy/enemies.dart';
import 'package:card_battler/game/components/player/player.dart';
import 'package:card_battler/game/components/shop/shop.dart';
import 'package:card_battler/game/components/team/team.dart';
import 'package:card_battler/game/components/shared/flat_button.dart';
import 'package:card_battler/game/components/shared/card/card_interaction_controller.dart';
import 'package:card_battler/game/models/player/player_turn_model.dart';
import 'package:flame/components.dart';
import 'package:flutter/foundation.dart';

class PlayerTurnScene extends Component with HasGameReference<CardBattlerGame>{
  final PlayerTurnModel _model;
  final Vector2 _size;
  final VoidCallback? onTurnEnded;
  late final FlatButton turnButton;

  PlayerTurnScene({required PlayerTurnModel model, required Vector2 size, this.onTurnEnded})
      : _model = model,
        _size = size {
    _model.playerModel.onCardsDrawn = _onPlayerCardsDrawn;
  }

  void _setupModelCallbacks() {
    _model.onShowConfirmDialog = () => game.router.pushOverlay('confirm');
    _model.onHideTurnButton = hideTurnButton;
    _model.onSetTurnButtonEndTurnText = () => turnButton.text = 'End Turn';
    _model.onNavigateToEnemyTurn = () => game.router.pushNamed('enemyTurn');
  }

  static const double margin = 20.0;
  static const double topLayoutHeightFactor = 0.6;

  @override
  Future<void> onMount() async {
    super.onMount();
    _loadGameComponents();
    _createTurnButton();
    _setupModelCallbacks();
  }

  void _loadGameComponents() {
    final availableHeight = _size.y - (margin * 2);
    final availableWidth = _size.x - (margin * 2);
    final topLayoutHeight = availableHeight * topLayoutHeightFactor;
    final bottomLayoutHeight = availableHeight - topLayoutHeight;
    final topPositionY = -1 * (_size.y / 2) + margin;

    // Create player component with models from game state
    final player = Player(
      playerModel: _model.playerModel,
    )
      ..size = Vector2(availableWidth, bottomLayoutHeight)
      ..position = Vector2(
        (0 - _size.x / 2) + margin,
        (_size.y / 2) - margin - bottomLayoutHeight,
      );

    add(player);

    // Create enemies component with model from game state
    final enemiesWidth = availableWidth * 0.5;
    final enemies = Enemies(model: _model.enemiesModel)
      ..size = Vector2(enemiesWidth, topLayoutHeight)
      ..position = Vector2((0 - enemiesWidth / 2), topPositionY);

    add(enemies);

    // Create shop component with model from game state
    final shopWidth = availableWidth * 0.5 / 2;
    final shop = Shop(_model.shopModel)
      ..size = Vector2(shopWidth, topLayoutHeight)
      ..position = Vector2(enemies.position.x + enemiesWidth, topPositionY);

    add(shop);

    // Create team component with model from game state
    final team = Team(_model.teamModel)
      ..size = Vector2(shopWidth, topLayoutHeight)
      ..position = Vector2(0 - enemiesWidth / 2 - shopWidth, topPositionY);

    add(team);
  }

  void _createTurnButton() {
    turnButton = FlatButton(
      'Take Enemy Turn',
      size: Vector2(_size.x * 0.3, 0.1 * _size.y),
      position: Vector2(0, ((_size.y / 2) * -1) + (_size.y * 0.1)),
      onReleased: () {
        if (!turnButton.disabled && turnButton.isVisible) {
          CardInteractionController.deselectAny();
          _model.handleTurnButtonPress();
        }
      }
    );

    turnButton.isVisible = false;
    add(turnButton);
  }

  void _onPlayerCardsDrawn() {
    turnButton.isVisible = true;
  }

  void hideTurnButton() {
    turnButton.text = 'Take Enemy Turn';
    turnButton.isVisible = false;
  }
}