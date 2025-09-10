enum EffectType {
  attack,
  heal,
  credits,
  drawCard, //discard
  damageLimit;
  // placeNewCardOnDeck
  // random skill
  // Search pile
  // BlockEnemy

  static EffectType fromString(String value) {
    return EffectType.values.firstWhere(
      (e) => e.name.toLowerCase() == value.toLowerCase(),
      orElse: () => throw ArgumentError('Unknown effect type: $value'),
    );
  }
}

enum EffectTarget {
  activePlayer,
  otherPlayers,
  allPlayers,
  base,
  chosenPlayer,
  self;

  static EffectTarget fromString(String value) {
    return EffectTarget.values.firstWhere(
      (e) => e.name.toLowerCase() == value.toLowerCase(),
      orElse: () => throw ArgumentError('Unknown effect target: $value'),
    );
  }
}

class EffectModel {
  final EffectType type;
  final EffectTarget target;
  final int value;

  EffectModel copy() => EffectModel(type: type, target: target, value: value);

  EffectModel({required this.type, required this.target, required this.value});

  factory EffectModel.fromJson(Map<String, dynamic> json) {
    return EffectModel(
      type: EffectType.fromString(json['type']),
      target: EffectTarget.fromString(json['target']),
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'type': type.name, 'target': target.name, 'value': value};
  }
}