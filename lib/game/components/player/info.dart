import 'package:card_battler/game/components/shared/health.dart';
import 'package:card_battler/game/components/shared/value_image_label.dart';
import 'package:card_battler/game/models/player/info_model.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Info extends PositionComponent {
  final InfoModel model;

  late ValueImageLabel _healthLabel;
  late ValueImageLabel _attackLabel;
  late ValueImageLabel _creditsLabel;
  
  Info(this.model);

  @override
  bool get debugMode => true;

  @override
  void onLoad() {
    super.onLoad();

    var comp1 = PositionComponent()
      ..size = Vector2(size.x / 3, size.y)
      ..position = Vector2(0, 0)
      ..debugColor = const Color(0xFF00FF00);

    var comp2 = PositionComponent()
      ..size = Vector2(size.x / 3, size.y)
      ..position = Vector2(size.x / 3, 0)
      ..debugColor = const Color.fromARGB(255, 179, 9, 49);

    var comp3 = PositionComponent()
      ..size = Vector2(size.x / 3, size.y)
      ..position = Vector2((size.x / 3) * 2, 0)
      ..debugColor = const Color.fromARGB(255, 15, 23, 191);

    _healthLabel = ValueImageLabel(
      model.health,
    );

    _attackLabel = ValueImageLabel(
      model.attack,
    );

    _creditsLabel = ValueImageLabel(
      model.credits,
    );

    comp1.add(_healthLabel);
    comp2.add(_attackLabel);
    comp3.add(_creditsLabel);

    add(comp1);
    add(comp2);
    add(comp3);
  }
}