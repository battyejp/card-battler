import 'package:card_battler/game/coordinators/components/player/stat_coordinator.dart';
import 'package:card_battler/game/ui/components/common/icon_stat.dart';
import 'package:card_battler/game/ui/components/common/reactive_position_component.dart';
import 'package:flame/components.dart';
import 'package:flame_svg/svg.dart';

class IconStatComponent extends ReactivePositionComponent<StatCoordinator> {
  IconStatComponent(super.coordinator, Svg icon, double size)
    : _icon = icon,
      _size = size;

  final Svg _icon;
  final double _size;

  @override
  void updateDisplay() {
    super.updateDisplay();

    final iconStat = IconStat(_icon, _size, coordinator.value)
      ..size = Vector2.all(_size);
    add(iconStat);
  }
}
