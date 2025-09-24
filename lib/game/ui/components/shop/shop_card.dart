import 'package:card_battler/game/coordinators/components/shop/shop_card_coordinator.dart';
import 'package:card_battler/game/ui/components/card/card_sprite.dart';

class ShopCard extends CardSprite {
  ShopCard(ShopCardCoordinator super.coordinator, super.isMini)
    : _coordinator = coordinator;

  final ShopCardCoordinator _coordinator;
}
