import 'package:card_battler/game_legacy/models/shared/health_model.dart';
import 'package:card_battler/game_legacy/models/shared/value_image_label_model.dart';

class InfoModel {
  final ValueImageLabelModel attack;
  final ValueImageLabelModel credits;
  final HealthModel healthModel;
  final String name;

  InfoModel({
    required this.attack,
    required this.credits,
    required this.name,
    required this.healthModel,
  });
}