enum EffectType {
  attack, // gets attack points
  damage, // takes damage
  heal, // is healed
  credits, //gets credits
  drawCard, // draws cards
  protection; // gets a protection
  // placeNewCardOnDeck
  // random skill
  // Search pile
  // BlockEnemy

  static EffectType fromString(String value) => EffectType.values.firstWhere(
    (e) => e.name.toLowerCase() == value.toLowerCase(),
    orElse: () => throw ArgumentError('Unknown effect type: $value'),
  );  
}

enum EffectTarget {
  activePlayer,
  nonActivePlayers,
  allPlayers,
  base;

  static EffectTarget fromString(String value) =>
      EffectTarget.values.firstWhere(
        (e) => e.name.toLowerCase() == value.toLowerCase(),
        orElse: () => throw ArgumentError('Unknown effect target: $value'),
      );
}

class EffectModel {
  EffectModel({required this.type, required this.target, required this.value});

  factory EffectModel.fromJson(Map<String, dynamic> json) => EffectModel(
    type: EffectType.fromString(json['type']),
    target: EffectTarget.fromString(json['target']),
    value: json['value'],
  );

  final EffectType type;
  final EffectTarget target;
  final int value;

  EffectModel copy() => EffectModel(type: type, target: target, value: value);

  Map<String, dynamic> toJson() => {
    'type': type.name,
    'target': target.name,
    'value': value,
  };
}
