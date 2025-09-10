import 'package:card_battler/game/coordinators/components/scenes/player_turn_scene_coordinator.dart';
import 'package:card_battler/game/ui/components/common/flat_button.dart';
import 'package:card_battler/game/ui/components/player/player.dart';
import 'package:flame/components.dart';

class PlayerTurnScene extends Component {
  final Vector2 _size;
  final PlayerTurnSceneCoordinator _coordinator;

  double _margin = 20.0;
  double _topLayoutHeightFactor = 0.6;

  PlayerTurnScene({
    required PlayerTurnSceneCoordinator coordinator,
    required Vector2 size,
  }) : _size = size,
       _coordinator = coordinator;

  @override
  Future<void> onMount() async {
    super.onMount();

    _loadGameComponents();
  }

  void _loadGameComponents() {
    final availableHeight = _size.y - (_margin * 2);
    final topLayoutHeight = availableHeight * _topLayoutHeightFactor;
    final topPositionY = -1 * (_size.y / 2) + _margin;
    final _availableWidth = _size.x - (_margin * 2);
    final _bottomLayoutHeight = availableHeight - topLayoutHeight;

    var player = Player(playerModel: _coordinator.playerCoordinator)
      ..size = Vector2(_availableWidth, _bottomLayoutHeight)
      ..position = Vector2(
        (0 - _size.x / 2) + _margin,
        (_size.y / 2) - _margin - _bottomLayoutHeight,
      );

    add(player);

    // // Create enemies component with model from game state
    // final enemiesWidth = _availableWidth * 0.5;
    // final enemies = Enemies(model: _model.enemiesModel)
    //   ..size = Vector2(enemiesWidth, topLayoutHeight)
    //   ..position = Vector2((0 - enemiesWidth / 2), topPositionY);

    // add(enemies);

    // // Create shop component with model from game state
    // final shopWidth = _availableWidth * 0.5 / 2;
    // final shop =
    //     Shop(
    //         _model.shopModel,
    //         cardInteractionService: _cardInteractionService,
    //         cardSelectionService: _cardSelectionService,
    //       )
    //       ..size = Vector2(shopWidth, topLayoutHeight)
    //       ..position = Vector2(enemies.position.x + enemiesWidth, topPositionY);

    // add(shop);

    // // Create team component with model from game state
    // final team = Team(_model.teamModel)
    //   ..size = Vector2(shopWidth, topLayoutHeight)
    //   ..position = Vector2(0 - enemiesWidth / 2 - shopWidth, topPositionY);

    // add(team);

    FlatButton? turnButton;

    turnButton = FlatButton(
      'Take Enemy Turn',
      size: Vector2(_size.x * 0.3, 0.1 * _size.y),
      position: Vector2(0, ((_size.y / 2) * -1) + (_size.y * 0.1)),
      onReleased: () {
        if (!(turnButton?.disabled ?? true) &&
            (turnButton?.isVisible ?? false)) {
          //_cardSelectionService.deselectCard();
          //_sceneManager.handleTurnButtonPress();
        }
      },
    );

    turnButton.isVisible = false;
    add(turnButton);
  }
}
