import 'package:card_battler/game/components/deck.dart';
import 'package:flame/components.dart';

class Player extends PositionComponent {
  @override
  bool get debugMode => true;

  @override
  void onLoad() {
    add(Deck()
      ..size = Vector2(size.x / 12, size.y));
  }
}