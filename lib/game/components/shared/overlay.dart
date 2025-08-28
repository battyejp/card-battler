import 'dart:async' as dart_async;
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';

class Overlay extends PositionComponent {
  static const double fadeTime = 1.5;
  @protected
  double get fadeDuration => fadeTime;
  final Duration displayDuration;
  final VoidCallback? onComplete;
  
  late RectangleComponent backdrop;
  dart_async.Timer? _fadeOutTimer;
  dart_async.Timer? _completionTimer;
  
  Overlay({
    this.displayDuration = const Duration(seconds: 5),
    this.onComplete,
  }) : super(priority: 1000); // High priority to appear on top

  @override
  void onLoad() {
    super.onLoad();
    
    _createBackdrop();
    add(backdrop);
    addContent();
    startAnimation();
  }
  
  void _createBackdrop() {
    // Semi-transparent dark backdrop that covers entire screen
    backdrop = RectangleComponent(
      size: size,
      paint: Paint()..color = Colors.black.withAlpha((255)),
    );
  }
  
  void startAnimation() {
    // Fade in animation
    backdrop.opacity = 0;

    var effectController = EffectController(duration: fadeTime);

    // Backdrop fade in
    backdrop.add(OpacityEffect.to(
      0.8,
      effectController,
      onComplete: () => {
        //startFadeOut(),
      },
    ));
  }
  
  void startFadeOut() {
    var effectController = EffectController(duration: fadeTime);

    backdrop.add(OpacityEffect.to(
      0.0,
      effectController,
      onComplete: () => {
        onComplete?.call(),
      },
    ));
  }
  
  // Method to dismiss early if needed
  void dismiss() {
    _cancelTimers();
    startFadeOut();
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
  
  void addContent() {}
}