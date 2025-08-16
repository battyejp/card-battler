import 'package:card_battler/game/models/shared/value_image_label_model.dart';

class InfoModel {
  final ValueImageLabelModel health;
  final ValueImageLabelModel attack;
  final ValueImageLabelModel credits;

  InfoModel({
    required this.health,
    required this.attack,
    required this.credits,
  });
}