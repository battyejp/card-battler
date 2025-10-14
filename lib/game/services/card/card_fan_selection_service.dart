import 'package:card_battler/game/card_battler_game.dart';
import 'package:card_battler/game/ui/components/card/interactive_card_sprite.dart';
import 'package:card_battler/game/ui/components/common/darkening_overlay.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';

class CardFanSelectionService {
  CardFanSelectionService(
    Vector2 size,
    Function(SpriteComponent) onShowCardAtCenter,
    Function(SpriteComponent) onRemoveCardAtCenter,
  ) : _size = size,
      _onShowCardAtCenter = onShowCardAtCenter,
      _onRemoveCardAtCenter = onRemoveCardAtCenter;

  final Vector2 _size;
  final Function(SpriteComponent) _onShowCardAtCenter;
  final Function(SpriteComponent) _onRemoveCardAtCenter;

  late CardBattlerGame game;
  InteractiveCardSprite? selectedCard;
  SpriteComponent? duplicateCard;
  DarkeningOverlay? darkeningOverlay;

  void findHighestPriorityCardSpriteAndSelect(Vector2 position) {
    final components = game.componentsAtPoint(position);
    final cardSprites = components.whereType<InteractiveCardSprite>().toList();

    if (cardSprites.isEmpty) {
      return;
    }

    var highestPriority = -1;
    final comps = cardSprites.whereType<PositionComponent>();
    for (final comp in comps) {
      if (comp.priority > highestPriority) {
        highestPriority = comp.priority;
      }
    }

    // Return the topmost card (last in the list)
    final card = cardSprites.lastWhere(
      (card) => card.priority == highestPriority,
    );
    selectCard(card);
  }

  void selectCard(InteractiveCardSprite? card) {
    if (card == null || card == selectedCard) {
      return;
    }

    if (selectedCard != null) {
      _removeDuplicateCardAtCenter(selectedCard!);
      selectedCard?.isSelected = false;
    }

    _showDuplicateCardAtCenter(card);
    selectedCard = card;
    selectedCard?.isSelected = true;
  }

  void deselectCard() {
    if (selectedCard == null) {
      return;
    }

    _removeDuplicateCardAtCenter(selectedCard!);
    selectedCard?.isSelected = false;
    selectedCard = null;
  }

  void _removeDuplicateCardAtCenter(InteractiveCardSprite card) {
    card.isSelected = false;
    _onRemoveCardAtCenter.call(duplicateCard!);

    // Hide darkening overlay when card is removed
    if (darkeningOverlay != null) {
      darkeningOverlay!.isVisible = false;
    }
  }

  void _showDuplicateCardAtCenter(InteractiveCardSprite card) {
    card.isSelected = true;

    final image = Flame.images.fromCache(card.getFileName);
    const scale = 0.75;

    duplicateCard = SpriteComponent(sprite: Sprite(image))
      ..scale = Vector2.all(scale)
      ..priority = 150; // Above the darkening overlay

    duplicateCard!.position = Vector2(
      _size.x / 2 - duplicateCard!.size.x * scale / 2,
      -duplicateCard!.size.y * scale,
    );
    _onShowCardAtCenter.call(duplicateCard!);

    // Show darkening overlay when card is shown at center
    if (darkeningOverlay != null) {
      darkeningOverlay!.isVisible = true;
    }
  }
}
