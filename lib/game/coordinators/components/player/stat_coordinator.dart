import 'package:card_battler/game/coordinators/common/reactive_coordinator.dart';

class StatCoordinator with ReactiveCoordinator<StatCoordinator> {
  StatCoordinator(int initialValue, {int? maxValue}) {
    _value = initialValue;
    _maxValue = maxValue;
  }

  int _value = 0;
  int? _maxValue = 0;

  int get value => _value;

  void adjustValue(int amount) {
    if (_maxValue != null && _maxValue! > 0) {
      final newValue = _value + amount;
      _value = newValue.clamp(0, _maxValue!);
    } else {
      _value += amount;
    }

    notifyChange();
  }
}
