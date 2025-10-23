import 'package:card_battler/game/coordinators/components/player/player_coordinator.dart';
import 'package:card_battler/game/ui/components/common/reactive_position_component.dart';
import 'package:flame/components.dart';
import 'package:flutter/painting.dart';

class ShopCredits extends ReactivePositionComponent<PlayerCoordinator> {
  ShopCredits(super.coordinator);

  @override
  void updateDisplay() {
    super.updateDisplay();

    // Add text component with available credits
    final creditsText = TextComponent(
      text: 'Credits: ${coordinator.credits}',
      textRenderer: TextPaint(
        style: const TextStyle(color: Color(0xFFFFFFFF), fontSize: 24),
      ),
      position: size / 2, // Position at center of component
    )..anchor = Anchor.center;
    add(creditsText);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final paint = Paint()..color = const Color.fromARGB(255, 22, 6, 193);
    canvas.drawRect(size.toRect(), paint);
  }
}
