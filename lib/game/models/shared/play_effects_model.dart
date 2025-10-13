import 'package:card_battler/game/models/shared/effect_model.dart';

enum EffectsOperator { and, or }

class EffectsModel {
  EffectsModel({required this.operator, required this.effects});

  factory EffectsModel.fromJson(Map<String, dynamic> json) {
    final operatorStr = (json['operator'] as String?)?.toLowerCase() ?? 'and';
    final operator = operatorStr == 'or'
        ? EffectsOperator.or
        : EffectsOperator.and;
    final effectsJson = json['effects'] as List<dynamic>?;
    final effects = effectsJson != null
        ? effectsJson.map((e) => EffectModel.fromJson(e)).toList()
        : <EffectModel>[];
    return EffectsModel(operator: operator, effects: effects);
  }

  factory EffectsModel.empty() =>
      EffectsModel(operator: EffectsOperator.and, effects: []);

  final EffectsOperator operator;
  final List<EffectModel> effects;

  EffectsModel copy() => EffectsModel(
    operator: operator,
    effects: effects.map((e) => e.copy()).toList(),
  );

  Map<String, dynamic> toJson() => {
    'operator': operator == EffectsOperator.or ? 'Or' : 'And',
    'effects': effects.map((e) => e.toJson()).toList(),
  };
}
