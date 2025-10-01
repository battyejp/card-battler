import 'package:card_battler/game/ui/components/card/card_drop_area.dart';
import 'package:flame/components.dart';

/// Utility class responsible for finding the CardDragDropArea in the component tree.
/// This class encapsulates the logic for navigating the component hierarchy.
class DropAreaFinder {
  /// Finds the CardDragDropArea by traversing up the component tree and
  /// searching through siblings.
  /// 
  /// Expected hierarchy: CardFanDraggableArea -> CardFan -> Player -> GameScene
  /// The CardDragDropArea is expected to be a child of GameScene.
  static CardDragDropArea? findDropArea(Component component) {
    final cardFan = component.parent;
    if (cardFan == null) {
      return null;
    }

    final player = cardFan.parent;
    if (player == null) {
      return null;
    }

    final gameScene = player.parent;
    if (gameScene == null) {
      return null;
    }

    final dropArea = gameScene.children
        .whereType<CardDragDropArea>()
        .firstOrNull;
    return dropArea;
  }
}
