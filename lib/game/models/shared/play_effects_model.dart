import 'package:card_battler/game/models/shared/effect_model.dart';

enum PlayEffectsOperator { and, or }

class PlayEffectsModel {
  PlayEffectsModel({required this.operator, required this.effects});

  factory PlayEffectsModel.fromJson(Map<String, dynamic> json) {
    final operatorStr = (json['operator'] as String?)?.toLowerCase() ?? 'and';
    final operator = operatorStr == 'or'
        ? PlayEffectsOperator.or
        : PlayEffectsOperator.and;
    final effectsJson = json['effects'] as List<dynamic>?;
    final effects = effectsJson != null
        ? effectsJson.map((e) => EffectModel.fromJson(e)).toList()
        : <EffectModel>[];
    return PlayEffectsModel(operator: operator, effects: effects);
  }

  factory PlayEffectsModel.empty() =>
      PlayEffectsModel(operator: PlayEffectsOperator.and, effects: []);

  final PlayEffectsOperator operator;
  final List<EffectModel> effects;

  PlayEffectsModel copy() => PlayEffectsModel(
    operator: operator,
    effects: effects.map((e) => e.copy()).toList(),
  );

  Map<String, dynamic> toJson() => {
    'operator': operator == PlayEffectsOperator.or ? 'Or' : 'And',
    'effects': effects.map((e) => e.toJson()).toList(),
  };
}
