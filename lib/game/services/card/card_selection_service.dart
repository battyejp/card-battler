import 'package:card_battler/game/card_battler_game.dart';
import 'package:card_battler/game/game_variables.dart';
import 'package:card_battler/game/ui/components/card/card_sprite.dart';
import 'package:card_battler/game/ui/components/card/interactive_card_sprite.dart';
import 'package:card_battler/game/ui/components/common/darkening_overlay.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';

class CardSelectionService {
  CardSelectionService();

  late CardBattlerGame game;
  InteractiveCardSprite? selectedCard;
  SpriteComponent? duplicateCard;
  DarkeningOverlay? darkeningOverlay;

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

    if (darkeningOverlay != null) {
      darkeningOverlay!.isVisible = false;
      darkeningOverlay!.add(duplicateCard!);
    }
  }

  void _showDuplicateCardAtCenter(InteractiveCardSprite card) {
    card.isSelected = true;
    const scale = 0.5;

    duplicateCard = CardSprite(card.coordinator)
      ..size = Vector2(
        GameVariables.originalCardSizeWidth * scale,
        GameVariables.originalCardSizeHeight * scale,
      )
      ..position = Vector2(
        darkeningOverlay!.width / 2,
        darkeningOverlay!.height / 2,
      )
      ..priority = 150; // Above the darkening overlay

    if (darkeningOverlay != null) {
      darkeningOverlay!.isVisible = true;
      darkeningOverlay!.add(duplicateCard!);
    }
  }
}
