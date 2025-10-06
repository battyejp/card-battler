import 'package:flame_svg/svg.dart';

class IconManager {
  static final Map<String, Svg> _icons = {};

  static Future<void> loadAllImages() async {
    _icons['shield'] = await Svg.load('icons/shield.svg');
  }

  static Svg shield() => _icons['shield']!;
}
