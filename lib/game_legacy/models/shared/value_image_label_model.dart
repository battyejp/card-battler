import 'package:card_battler/game_legacy/models/shared/reactive_model.dart';

class ValueImageLabelModel with ReactiveModel<ValueImageLabelModel> {
  int _value;
  final String _label;

  ValueImageLabelModel({required int value, required String label})
      : _value = value,
        _label = label;

  /// Updates the value by [delta]
  void changeValue(int delta) {
    _value += delta;
    notifyChange();
  }

  int get value => _value;
  String get display => '$_label: $_value';
}