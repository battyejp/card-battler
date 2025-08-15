class CardModel {
  final String _name;
  final int _cost;

  bool isFaceUp;

  CardModel({required String name, required int cost, bool faceUp = true})
    : _name = name,
      _cost = cost,
      isFaceUp = faceUp;

  int get cost => _cost;
  String get name => _name;
}
  