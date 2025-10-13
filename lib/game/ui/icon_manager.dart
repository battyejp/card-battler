import 'package:flame_svg/svg.dart';

class IconManager {
  static final Map<String, Svg> _icons = {};

  static Future<void> loadAllImages() async {
    _icons['shield'] = await Svg.load('icons/shield.svg');
    _icons['heart'] = await Svg.load('icons/heart.svg');
    _icons['target'] = await Svg.load('icons/target.svg');
    _icons['rupee'] = await Svg.load('icons/rupee.svg');
  }

  static Svg shield() => _icons['shield']!;
  static Svg heart() => _icons['heart']!;
  static Svg target() => _icons['target']!;
  static Svg rupee() => _icons['rupee']!;
}
