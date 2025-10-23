import 'package:card_battler/game/coordinators/components/scenes/shop_scene_coordinator.dart';
import 'package:card_battler/game/game_variables.dart';
import 'package:card_battler/game/ui/components/shop/shop_credits.dart';
import 'package:card_battler/game/ui/components/shop/shop_display.dart';
import 'package:flame/components.dart';

class ShopScene extends PositionComponent {
  ShopScene(ShopSceneCoordinator coordinator) : _coordinator = coordinator;

  final ShopSceneCoordinator _coordinator;

  @override
  void onMount() {
    super.onMount();
    removeWhere((component) => true);

    final creditsText = ShopCredits(_coordinator.teamCoordinator.activePlayer)
      ..size = Vector2(size.x, GameVariables.topMargin)
      ..position = Vector2(-size.x / 2, -size.y / 2);
    add(creditsText);

    final shopDisplay = ShopDisplay(_coordinator.shopDisplayCoordinator)
      ..size = Vector2(creditsText.width, size.y - creditsText.height)
      ..position = Vector2(
        creditsText.x,
        -size.y / 2 + GameVariables.topMargin,
      );
    add(shopDisplay);
  }
}
