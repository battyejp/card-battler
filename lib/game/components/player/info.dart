import 'package:card_battler/game/components/shared/value_image_label.dart';
import 'package:card_battler/game/models/player/info_model.dart';
import 'package:card_battler/game/models/shared/value_image_label_model.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Info extends PositionComponent {
  late InfoModel _infoModel;

  late ValueImageLabel _healthLabel;
  late ValueImageLabel _attackLabel;
  late ValueImageLabel _creditsLabel;
  

  @override
  bool get debugMode => true;

  @override
  void onLoad() {
    super.onLoad();
    _infoModel = InfoModel(
      health: ValueImageLabelModel(value: 10, label: 'Health'),
      attack: ValueImageLabelModel(value: 0, label: 'Attack'),
      credits: ValueImageLabelModel(value: 0, label: 'Credits'),
    );

    var comp1 = PositionComponent()
      ..size = Vector2(size.x / 3, size.y)
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
      _infoModel.health,
    );

    _attackLabel = ValueImageLabel(
      _infoModel.attack,
    );

    _creditsLabel = ValueImageLabel(
      _infoModel.credits,
    );

    comp1.add(_healthLabel);
    comp2.add(_attackLabel);
    comp3.add(_creditsLabel);

    add(comp1);
    add(comp2);
    add(comp3);
  }
}