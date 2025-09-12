import 'package:card_battler/game/coordinators/components/cards/card_coordinator.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Card extends PositionComponent {
  final CardCoordinator _coordinator;

  @protected
  late TextComponent nameTextComponent;

  Card({required CardCoordinator coordinator}) : _coordinator = coordinator;

  @override
  void onLoad() {
    super.onLoad();
    addTextComponent();
  }

  @protected
  void addTextComponent() {
    if (_coordinator.isFaceUp) {
      createNameTextComponent(Vector2(size.x / 2, size.y / 2));
      add(nameTextComponent);
    } else {
      createBackTextComponent();
      add(nameTextComponent);
    }
  }

  @protected
  void createNameTextComponent(Vector2 position) {
    nameTextComponent = TextComponent(
      text: _coordinator.name,
      anchor: Anchor.center,
      position: position,
      textRenderer: TextPaint(
        style: const TextStyle(fontSize: 20, color: Colors.white),
      ),
    );
  }

  @protected
  void createBackTextComponent() {
    nameTextComponent = TextComponent(
      text: "Back",
      anchor: Anchor.center,
      position: Vector2(size.x / 2, size.y / 2),
      textRenderer: TextPaint(
        style: const TextStyle(fontSize: 20, color: Colors.white),
      ),
    );
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final paint = Paint()..color = const Color.fromARGB(255, 22, 6, 193);
    canvas.drawRect(size.toRect(), paint);
  }

  CardCoordinator get coordinator => _coordinator;
}
