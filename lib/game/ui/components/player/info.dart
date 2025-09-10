import 'package:card_battler/game/models/player/info_model.dart';
import 'package:card_battler/game/ui/components/common/value_image_label.dart';
import 'package:card_battler/game/ui/components/shared/health.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Info extends PositionComponent {
  Info(this.model);

  final InfoModel model;

  @override
  void onLoad() {
    super.onLoad();

    var comp1 = PositionComponent()
      ..size = Vector2(size.x / 4, size.y)
      ..position = Vector2(0, 0);

    var comp2 = PositionComponent()
      ..size = Vector2(size.x / 4, size.y)
      ..position = Vector2(size.x / 4, 0);

    var comp3 = PositionComponent()
      ..size = Vector2(size.x / 4, size.y)
      ..position = Vector2((size.x / 4) * 2, 0);

    var comp4 = PositionComponent()
      ..size = Vector2(size.x / 4, size.y)
      ..position = Vector2((size.x / 4) * 3, 0);

    var healthLabel = Health(
      model.healthModel,
      Anchor.topLeft,
    );

    var attackLabel = ValueImageLabel(
      model.attack,
    );

    var creditsLabel = ValueImageLabel(
      model.credits,
    );

    var nameLabel = TextComponent(
      text: model.name,
      position: Vector2(comp1.size.x / 2, comp1.size.y / 2),
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 20,
          color: Colors.white,
        ),
      ),
    );

    comp1.add(nameLabel);
    comp2.add(healthLabel);
    comp3.add(attackLabel);
    comp4.add(creditsLabel);

    add(comp1);
    add(comp2);
    add(comp3);
    add(comp4);
  }
}