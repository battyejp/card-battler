import 'package:card_battler/game/components/shared/overlay.dart' as game_overlay;
import 'package:card_battler/game/components/shared/card.dart' as game_card;
import 'package:card_battler/game/models/shared/card_model.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

/// Overlay that displays an enlarged, focused card in the center of the screen
class CardFocusOverlay extends game_overlay.Overlay with TapCallbacks {
  final CardModel cardModel;
  final VoidCallback onDismiss;
  late game_card.Card enlargedCard;
  
  static const double focusedCardScale = 2.0;
  static const double animationDuration = 0.3;
  
  CardFocusOverlay({
    required this.cardModel,
    required this.onDismiss,
  });

  @override  
  void addContent() {
    // Create the enlarged card
    enlargedCard = game_card.Card(cardModel);
    
    // Position and size the enlarged card in the center
    final cardWidth = 120.0;
    final cardHeight = 180.0;
    
    enlargedCard.size = Vector2(cardWidth, cardHeight);
    enlargedCard.position = Vector2(
      (size.x - cardWidth) / 2,
      (size.y - cardHeight) / 2,
    );
    
    // Start card with scale 0 for animation
    enlargedCard.scale = Vector2.zero();
    
    add(enlargedCard);
    
    // Animate the card scaling in
    enlargedCard.add(ScaleEffect.to(
      Vector2.all(focusedCardScale),
      EffectController(duration: animationDuration),
    ));
  }
  
  @override
  bool onTapUp(TapUpEvent event) {
    // Dismiss when tapped anywhere
    dismiss();
    return true;
  }
  
  void dismiss() {
    // Animate card scaling out
    enlargedCard.add(ScaleEffect.to(
      Vector2.zero(),
      EffectController(duration: animationDuration),
      onComplete: () {
        onDismiss();
        removeFromParent();
      },
    ));
    
    // Animate backdrop fade out
    startFadeOut();
  }
}