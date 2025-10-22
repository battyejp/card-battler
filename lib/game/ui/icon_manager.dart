import 'package:flame_svg/svg.dart';

class IconManager {
  static final Map<String, Svg> _icons = {};

  static Future<void> loadAllImages() async {
    _icons['shield'] = await Svg.load('icons/shield.svg');
    _icons['heart'] = await Svg.load('icons/heart.svg');
    _icons['target'] = await Svg.load('icons/target.svg');
    _icons['rupee'] = await Svg.load('icons/rupee.svg');
    _icons['drawCard'] = await Svg.load('icons/draw_card.svg');
    _icons['damage'] = await Svg.load('icons/damage.svg');
    _icons['multiple-damage'] = await Svg.load('icons/multiple-damage.svg');
    _icons['card-pile'] = await Svg.load('icons/card_pile.svg');
  }

  static Svg shield() => _icons['shield']!;
  static Svg heart() => _icons['heart']!;
  static Svg target() => _icons['target']!;
  static Svg rupee() => _icons['rupee']!;
  static Svg drawCard() => _icons['drawCard']!;
  static Svg damage() => _icons['damage']!;
  static Svg multipleDamage() => _icons['multiple-damage']!;
  static Svg cardPile() => _icons['card-pile']!;
}
