class CardModel {
  final String _name;
  final int _cost;
  final bool _isFaceUp;

  CardModel({
    required String name,
    required int cost,
    bool isFaceUp = true,
  })  : _name = name,
        _cost = cost,
        _isFaceUp = isFaceUp;

  int get cost => _cost;
  String get name => _name;
  bool get isFaceUp => _isFaceUp;
}