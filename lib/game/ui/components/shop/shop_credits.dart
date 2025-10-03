import 'package:card_battler/game/coordinators/components/player/player_info_coordinator.dart';
import 'package:card_battler/game/ui/components/common/reactive_position_component.dart';
import 'package:flame/components.dart';
import 'package:flutter/painting.dart';

class ShopCredits extends ReactivePositionComponent<PlayerInfoCoordinator> {
  ShopCredits(super.coordinator);

  @override
  void updateDisplay() {
    super.updateDisplay();

    // Add text component with available credits
    final creditsText =
        TextComponent(
            text:
                'Credits: ${coordinator.credits}',
            textRenderer: TextPaint(
              style: const TextStyle(color: Color(0xFFFFFFFF), fontSize: 24),
            ),
          )
          ..anchor = Anchor.topCenter;
    add(creditsText);
  }
}