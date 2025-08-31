import 'package:card_battler/game/models/shared/health_model.dart';
import 'package:card_battler/game/models/shared/value_image_label_model.dart';

class InfoModel {
  final ValueImageLabelModel attack;
  final ValueImageLabelModel credits;
  final HealthModel healthModel;
  final String name;
  final bool isActive;

  InfoModel({
    required this.attack,
    required this.credits,
    required this.name,
    required this.healthModel,
    this.isActive = false,
  });
}