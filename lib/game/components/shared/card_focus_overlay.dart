import 'package:card_battler/game/components/shared/card.dart' as game_card;
import 'package:card_battler/game/components/shared/overlay.dart' as game_overlay;
import 'package:card_battler/game/models/shared/card_model.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart' hide Card;

class CardFocusOverlay extends game_overlay.Overlay with TapCallbacks {
  final CardModel cardModel;
  final void Function()? onActionPressed;
  final String actionLabel;
  
  late RectangleComponent _cardContainer;
  late game_card.Card _enlargedCard;
  late TextComponent _descriptionText;
  late RectangleComponent _actionButton;
  late TextComponent _actionButtonText;

  CardFocusOverlay({
    required this.cardModel,
    this.onActionPressed,
    required this.actionLabel,
    super.onComplete,
  }) : super(displayDuration: const Duration(seconds: 30)); // Long duration, dismiss manually

  @override
  void addContent() {
    // Create card container in the center
    final cardWidth = size.x * 0.6;
    final cardHeight = size.y * 0.7;
    final cardX = (size.x - cardWidth) / 2;
    final cardY = (size.y - cardHeight) / 2;
    
    _cardContainer = RectangleComponent(
      size: Vector2(cardWidth, cardHeight),
      position: Vector2(cardX, cardY),
      paint: Paint()..color = const Color.fromARGB(255, 40, 40, 40),
    );
    backdrop.add(_cardContainer);

    // Create enlarged card
    final enlargedCardWidth = cardWidth * 0.8;
    final enlargedCardHeight = cardHeight * 0.5;
    _enlargedCard = game_card.Card(cardModel)
      ..size = Vector2(enlargedCardWidth, enlargedCardHeight)
      ..position = Vector2(
        (cardWidth - enlargedCardWidth) / 2, 
        cardHeight * 0.1,
      );
    _cardContainer.add(_enlargedCard);

    // Create description text
    _descriptionText = TextComponent(
      text: cardModel.description,
      anchor: Anchor.topLeft,
      position: Vector2(cardWidth * 0.1, cardHeight * 0.65),
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 16,
          color: Colors.white,
        ),
      ),
    );
    _cardContainer.add(_descriptionText);

    // Create action button
    final buttonWidth = cardWidth * 0.6;
    final buttonHeight = cardHeight * 0.08;
    _actionButton = RectangleComponent(
      size: Vector2(buttonWidth, buttonHeight),
      position: Vector2(
        (cardWidth - buttonWidth) / 2,
        cardHeight * 0.85,
      ),
      paint: Paint()..color = const Color.fromARGB(255, 0, 120, 215),
    );
    _cardContainer.add(_actionButton);

    _actionButtonText = TextComponent(
      text: actionLabel,
      anchor: Anchor.center,
      position: Vector2(buttonWidth / 2, buttonHeight / 2),
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 18,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    _actionButton.add(_actionButtonText);
  }

  @override
  void onTapUp(TapUpEvent event) {
    super.onTapUp(event);
    
    // Check if tap is on the action button
    final localPoint = event.localPosition;
    final buttonBounds = Rect.fromLTWH(
      _cardContainer.position.x + _actionButton.position.x,
      _cardContainer.position.y + _actionButton.position.y,
      _actionButton.size.x,
      _actionButton.size.y,
    );
    
    if (buttonBounds.contains(localPoint.toOffset())) {
      onActionPressed?.call();
      dismiss();
    } else {
      // Check if tap is outside the card container
      final cardBounds = Rect.fromLTWH(
        _cardContainer.position.x,
        _cardContainer.position.y,
        _cardContainer.size.x,
        _cardContainer.size.y,
      );
      
      if (!cardBounds.contains(localPoint.toOffset())) {
        dismiss();
      }
    }
  }
}