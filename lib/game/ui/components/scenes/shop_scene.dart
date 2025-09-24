import 'package:card_battler/game/coordinators/components/cards/card_list_coordinator.dart';
import 'package:card_battler/game/coordinators/components/shop/shop_card_coordinator.dart';
import 'package:card_battler/game/ui/components/common/reactive_position_component.dart';
import 'package:card_battler/game/ui/components/shop/shop_display.dart';
import 'package:flame/components.dart';

class ShopScene
    extends
        ReactivePositionComponent<CardListCoordinator<ShopCardCoordinator>> {
  ShopScene(super.coordinator);

  @override
  void updateDisplay() {
    super.updateDisplay();

    // Clear existing components
    removeWhere((component) => true);

    // Add the shop display component
    final shopDisplay = ShopDisplay(coordinator)
      ..size = size
      ..position = Vector2.zero();
    add(shopDisplay);
  }
}
