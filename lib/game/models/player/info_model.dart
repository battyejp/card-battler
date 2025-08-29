import 'package:card_battler/game/models/shared/value_image_label_model.dart';

class InfoModel {
  final ValueImageLabelModel health;
  final ValueImageLabelModel attack;
  final ValueImageLabelModel credits;
  final String name;
  final bool isActive;

  InfoModel({
    required this.health,
    required this.attack,
    required this.credits,
    required this.name,
    this.isActive = false,
  });
}