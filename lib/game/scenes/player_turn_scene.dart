import 'package:card_battler/game/card_battler_game.dart';
import 'package:card_battler/game/components/enemy/enemies.dart';
import 'package:card_battler/game/components/player/player.dart';
import 'package:card_battler/game/components/shop/shop.dart';
import 'package:card_battler/game/components/team/team.dart';
import 'package:card_battler/game/components/shared/take_enemy_turn_button.dart';
import 'package:card_battler/game/models/player/player_turn_model.dart';
import 'package:flame/components.dart';
import 'dart:async';

class PlayerTurnScene extends Component with HasGameReference<CardBattlerGame>{
  final PlayerTurnModel _model;
  final Vector2 _size;
  final void Function()? onTakeEnemyTurn;
  TakeEnemyTurnButton? _takeEnemyTurnButton;
  late StreamSubscription _modelSubscription;

  PlayerTurnScene({
    required PlayerTurnModel model, 
    required Vector2 size,
    this.onTakeEnemyTurn,
  }) : _model = model, _size = size {
    _loadGameComponents();
  }

  @override 
  void onMount() {
    super.onMount();
    // Listen to model changes for the button
    _modelSubscription = _model.changes.listen((_) {
      _handleModelChange();
    });
  }

  @override
  void onRemove() {
    _modelSubscription.cancel();
    super.onRemove();
  }

  void _handleModelChange() {
    // Add the button if cards have been drawn and button doesn't exist
    if (_model.cardsDrawn && _takeEnemyTurnButton == null) {
      _addTakeEnemyTurnButton();
    }
    // Remove the button if cards haven't been drawn and button exists
    else if (!_model.cardsDrawn && _takeEnemyTurnButton != null) {
      _takeEnemyTurnButton?.removeFromParent();
      _takeEnemyTurnButton = null;
    }
  }

  static const double margin = 20.0;
  static const double topLayoutHeightFactor = 0.6;

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
  
  void _addTakeEnemyTurnButton() {
    if (_takeEnemyTurnButton != null) return;
    
    // Position the button at the top center of the screen
    final buttonWidth = 200.0;
    final buttonHeight = 60.0;
    
    _takeEnemyTurnButton = TakeEnemyTurnButton(
      onTap: onTakeEnemyTurn,
    )
      ..size = Vector2(buttonWidth, buttonHeight)
      ..position = Vector2(
        -buttonWidth / 2, // Center horizontally
        -_size.y / 2 + 10, // Top of screen with small margin
      );
    
    add(_takeEnemyTurnButton!);
  }
}