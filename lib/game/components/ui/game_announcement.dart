import 'dart:async' as dart_async;
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:card_battler/game/models/player/info_model.dart';
import 'package:card_battler/game/models/enemy/enemies_model.dart';
import 'package:card_battler/game/models/shared/value_image_label_model.dart';

class GameAnnouncement extends PositionComponent {
  final String title;
  final Duration displayDuration;
  final VoidCallback? onComplete;
  
  late RectangleComponent _backdrop;
  late RectangleComponent _announcementCard;
  late TextComponent _titleText;
  dart_async.Timer? _fadeOutTimer;
  dart_async.Timer? _completionTimer;
  
  GameAnnouncement({
    required this.title,
    this.displayDuration = const Duration(seconds: 5),
    this.onComplete,
  }) : super(priority: 1000); // High priority to appear on top

  @override
  void onLoad() {
    super.onLoad();
    
    // Make component fill the entire game screen
    if (parent is HasGameRef) {
      size = (parent as HasGameRef).gameRef.size;
    } else {
      size = Vector2(800, 600); // Default size
    }
    
    _createBackdrop();
    _createAnnouncementCard();
    _createTitleText();
    
    // Add components
    add(_backdrop);
    add(_announcementCard);
    _announcementCard.add(_titleText);
    
    _startAnimation();
  }
  
  void _createBackdrop() {
    // Semi-transparent dark backdrop that covers entire screen
    _backdrop = RectangleComponent(
      size: size,
      paint: Paint()..color = Colors.black.withOpacity(0.7),
    );
  }
  
  void _createAnnouncementCard() {
    // Central card that contains the announcement
    final cardWidth = 400.0;
    final cardHeight = 150.0;
    
    _announcementCard = RectangleComponent(
      size: Vector2(cardWidth, cardHeight),
      position: Vector2(size.x / 2, size.y / 2),
      anchor: Anchor.center,
      paint: Paint()..color = Colors.white,
    );
    
    // Add border to the card
    _announcementCard.add(RectangleComponent(
      size: _announcementCard.size,
      paint: Paint()
        ..color = Colors.transparent
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0
        ..color = const Color(0xFF2196F3), // Blue border
    ));
    
    // Add subtle shadow effect
    _announcementCard.add(RectangleComponent(
      size: _announcementCard.size + Vector2.all(4),
      position: Vector2(-2, -2),
      paint: Paint()..color = Colors.black.withOpacity(0.1),
    )..priority = -1);
  }
  
  void _createTitleText() {
    _titleText = TextComponent(
      text: title,
      position: Vector2(_announcementCard.size.x / 2, _announcementCard.size.y / 2),
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1976D2), // Dark blue
        ),
      ),
    );
  }
  
  void _startAnimation() {
    // Fade in animation
    _backdrop.opacity = 0;
    _announcementCard.opacity = 0;
    
    // Backdrop fade in
    _backdrop.add(OpacityEffect.to(
      0.7,
      EffectController(duration: 0.3),
    ));
    
    // Card slide in from top with fade
    _announcementCard.position.y -= 100;
    _announcementCard.add(OpacityEffect.to(
      1.0,
      EffectController(duration: 0.5),
    ));
    
    _announcementCard.add(MoveByEffect(
      Vector2(0, 100),
      EffectController(
        duration: 0.5,
        curve: Curves.easeOutBack,
      ),
    ));
    
    // Auto-remove after duration
    add(RemoveEffect(
      delay: displayDuration.inMilliseconds / 1000.0,
    ));
    
    // Call completion callback after fade out starts
    _fadeOutTimer = dart_async.Timer(
      displayDuration - const Duration(milliseconds: 500),
      () => _startFadeOut(),
    );
  }
  
  void _startFadeOut() {
    // Fade out animation
    _backdrop.add(OpacityEffect.to(
      0.0,
      EffectController(duration: 0.5),
    ));
    
    _announcementCard.add(OpacityEffect.to(
      0.0,
      EffectController(duration: 0.5),
    ));
    
    _announcementCard.add(MoveByEffect(
      Vector2(0, -50),
      EffectController(
        duration: 0.5,
        curve: Curves.easeInBack,
      ),
    ));
    
    // Call completion callback
    _completionTimer = dart_async.Timer(const Duration(milliseconds: 500), () {
      onComplete?.call();
    });
  }
  
  // Method to dismiss early if needed
  void dismiss() {
    _cancelTimers();
    _startFadeOut();
  }
  
  @override
  void onRemove() {
    _cancelTimers();
    super.onRemove();
  }
  
  void _cancelTimers() {
    _fadeOutTimer?.cancel();
    _fadeOutTimer = null;
    _completionTimer?.cancel();
    _completionTimer = null;
  }
}

// Enhanced version with additional styling options
// Enhanced announcement that uses InfoModel for player stats
class PlayerInfoAnnouncement extends GameAnnouncement {
  final InfoModel playerInfo;
  
  PlayerInfoAnnouncement({
    required this.playerInfo,
    required super.title,
    super.displayDuration,
    super.onComplete,
  });
  
  @override
  void _createAnnouncementCard() {
    final cardWidth = 500.0;
    final cardHeight = 200.0;
    
    _announcementCard = RectangleComponent(
      size: Vector2(cardWidth, cardHeight),
      position: Vector2(size.x / 2, size.y / 2),
      anchor: Anchor.center,
      paint: Paint()..color = Colors.white,
    );
    
    // Add border
    _announcementCard.add(RectangleComponent(
      size: _announcementCard.size,
      paint: Paint()
        ..color = Colors.transparent
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0
        ..color = const Color(0xFF2196F3),
    ));
  }
  
  @override
  void _createTitleText() {
    // Main title
    _titleText = TextComponent(
      text: title,
      position: Vector2(_announcementCard.size.x / 2, 40),
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1976D2),
        ),
      ),
    );
    
    // Player stats below title
    final healthText = TextComponent(
      text: playerInfo.health.display,
      position: Vector2(100, 100),
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: const TextStyle(fontSize: 18, color: Colors.green),
      ),
    );
    
    final attackText = TextComponent(
      text: playerInfo.attack.display,
      position: Vector2(250, 100),
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: const TextStyle(fontSize: 18, color: Colors.red),
      ),
    );
    
    final creditsText = TextComponent(
      text: playerInfo.credits.display,
      position: Vector2(400, 100),
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: const TextStyle(fontSize: 18, color: Colors.orange),
      ),
    );
    
    _announcementCard.addAll([_titleText, healthText, attackText, creditsText]);
  }
}

// Announcement that uses EnemiesModel for enemy status
class EnemyStatusAnnouncement extends GameAnnouncement {
  final EnemiesModel enemiesModel;
  
  EnemyStatusAnnouncement({
    required this.enemiesModel,
    super.displayDuration,
    super.onComplete,
  }) : super(title: 'Enemy Status');
  
  @override
  void _createTitleText() {
    _titleText = TextComponent(
      text: title,
      position: Vector2(_announcementCard.size.x / 2, 40),
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1976D2),
        ),
      ),
    );
    
    // Enemy count display
    final enemyCountText = TextComponent(
      text: enemiesModel.displayText,
      position: Vector2(_announcementCard.size.x / 2, 80),
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: const TextStyle(fontSize: 18, color: Colors.black87),
      ),
    );
    
    // Individual enemy health (first few enemies)
    final enemies = enemiesModel.allEnemies.take(3).toList();
    for (int i = 0; i < enemies.length; i++) {
      final enemy = enemies[i];
      final enemyText = TextComponent(
        text: '${enemy.name}: ${enemy.healthDisplay}',
        position: Vector2(100 + (i * 100), 110),
        anchor: Anchor.center,
        textRenderer: TextPaint(
          style: const TextStyle(fontSize: 14, color: Colors.red),
        ),
      );
      _announcementCard.add(enemyText);
    }
    
    _announcementCard.addAll([_titleText, enemyCountText]);
  }
}

// Dynamic announcement that updates with model changes
class ReactiveGameAnnouncement extends GameAnnouncement {
  final ValueImageLabelModel labelModel;
  late TextComponent _valueText;
  
  ReactiveGameAnnouncement({
    required this.labelModel,
    required super.title,
    super.displayDuration,
    super.onComplete,
  });
  
  @override
  void onLoad() {
    super.onLoad();
    
    // Listen to model changes and update display
    labelModel.changes.listen((_) {
      _updateValueDisplay();
    });
  }
  
  @override
  void _createTitleText() {
    _titleText = TextComponent(
      text: title,
      position: Vector2(_announcementCard.size.x / 2, 60),
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1976D2),
        ),
      ),
    );
    
    // Value display that updates with model
    _valueText = TextComponent(
      text: labelModel.display,
      position: Vector2(_announcementCard.size.x / 2, 100),
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.green,
        ),
      ),
    );
    
    _announcementCard.addAll([_titleText, _valueText]);
  }
  
  void _updateValueDisplay() {
    _valueText.text = labelModel.display;
  }
  
  @override
  void onRemove() {
    // Note: In a real implementation, you'd want to cancel the stream subscription
    super.onRemove();
  }
}

// Original styled version for backward compatibility
class StyledGameAnnouncement extends GameAnnouncement {
  final Color cardColor;
  final Color textColor;
  final Color borderColor;
  final double fontSize;
  
  StyledGameAnnouncement({
    required super.title,
    super.displayDuration,
    super.onComplete,
    this.cardColor = Colors.white,
    this.textColor = const Color(0xFF1976D2),
    this.borderColor = const Color(0xFF2196F3),
    this.fontSize = 32,
  });
  
  @override
  void _createTitleText() {
    _titleText = TextComponent(
      text: title,
      position: Vector2(_announcementCard.size.x / 2, _announcementCard.size.y / 2),
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: textColor,
          shadows: [
            Shadow(
              offset: const Offset(1, 1),
              blurRadius: 2,
              color: Colors.black.withOpacity(0.3),
            ),
          ],
        ),
      ),
    );
  }
}