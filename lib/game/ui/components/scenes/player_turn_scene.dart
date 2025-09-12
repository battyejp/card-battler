import 'package:card_battler/game/coordinators/components/scenes/player_turn_scene_coordinator.dart';
import 'package:card_battler/game/ui/components/common/flat_button.dart';
import 'package:card_battler/game/ui/components/common/reactive_position_component.dart';
import 'package:card_battler/game/ui/components/enemy/enemies.dart';
import 'package:card_battler/game/ui/components/player/player.dart';
import 'package:card_battler/game/ui/components/shop/shop_display.dart';
import 'package:card_battler/game/ui/components/team/team.dart';
import 'package:flame/components.dart';

class PlayerTurnScene
    extends ReactivePositionComponent<PlayerTurnSceneCoordinator> {
  final Vector2 _size;
  final double _margin = 20.0;
  final double _topLayoutHeightFactor = 0.6;

  late FlatButton _turnButton;
  bool loadingComplete = false;

  PlayerTurnScene(super.coordinator, {required Vector2 size}) : _size = size;

  @override
  bool debugMode = true;

  @override
  void updateDisplay() {
    //Don't call super to remove components
    if (!loadingComplete) {
      _loadGameComponents();
      loadingComplete = true;
    } else {
      _turnButton
        ..text = coordinator.buttonText
        ..isVisible = coordinator.isButtonVisible;
    }
  }

  void _loadGameComponents() {
    final availableHeight = _size.y - (_margin * 2);
    final topLayoutHeight = availableHeight * _topLayoutHeightFactor;
    final topPositionY = -1 * (_size.y / 2) + _margin;
    final availableWidth = _size.x - (_margin * 2);
    final bottomLayoutHeight = availableHeight - topLayoutHeight;

    var player = Player(playerModel: coordinator.playerCoordinator)
      ..size = Vector2(availableWidth, bottomLayoutHeight)
      ..position = Vector2(
        (0 - _size.x / 2) + _margin,
        (_size.y / 2) - _margin - bottomLayoutHeight,
      );

    add(player);

    final enemiesWidth = availableWidth * 0.5;
    final enemies = Enemies(coordinator: coordinator.enemiesCoordinator)
      ..size = Vector2(enemiesWidth, topLayoutHeight)
      ..position = Vector2((0 - enemiesWidth / 2), topPositionY);

    add(enemies);

    final shopWidth = availableWidth * 0.5 / 2;
    final shop =
        ShopDisplay(
            shopDisplayCoordinator:
                coordinator.shopCoordinator.displayCoordinator,
          )
          ..size = Vector2(shopWidth, topLayoutHeight)
          ..position = Vector2(enemies.position.x + enemiesWidth, topPositionY);

    add(shop);

    final team = Team(coordinator: coordinator.teamCoordinator)
      ..size = Vector2(shopWidth, topLayoutHeight)
      ..position = Vector2(0 - enemiesWidth / 2 - shopWidth, topPositionY);

    add(team);

    _turnButton = FlatButton(
      coordinator.buttonText,
      size: Vector2(_size.x * 0.3, 0.1 * _size.y),
      position: Vector2(0, ((_size.y / 2) * -1) + (_size.y * 0.1)),
      onReleased: () {
        if (!(_turnButton.disabled) && (_turnButton.isVisible)) {
          //_cardSelectionService.deselectCard();
          //_sceneManager.handleTurnButtonPress();
        }
      },
    );

    _turnButton.isVisible = coordinator.isButtonVisible;
    add(_turnButton);
  }
}
