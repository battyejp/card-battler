import 'package:card_battler/game/coordinators/components/cards/card_coordinator.dart';
import 'package:card_battler/game/game_variables.dart';
import 'package:card_battler/game/models/card/card_model.dart';
import 'package:card_battler/game/models/shared/effect_model.dart';
import 'package:card_battler/game/ui/components/common/icon_stat.dart';
import 'package:card_battler/game/ui/icon_manager.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame_svg/svg.dart';

class CardSprite extends SpriteComponent {
  CardSprite(CardCoordinator cardCoordinator, bool isMini)
    : _cardCoordinator = cardCoordinator,
      _isMini = isMini,
      super(anchor: Anchor.center);

  final CardCoordinator _cardCoordinator;
  final bool _isMini;

  String get getFileName {
    if (!_cardCoordinator.isFaceUp) {
      return _cardCoordinator.type == CardType.enemy
          ? 'cards/dark/enemy_card_back_560.png'
          : 'cards/light/card_face_down_0.08.png';
    }

    final filename = _cardCoordinator.filename.replaceAll(
      'size',
      _isMini ? '60' : '560',
    );

    return filename;
  }

  CardCoordinator get coordinator => _cardCoordinator;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    final image = Flame.images.containsKey(getFileName)
        ? Flame.images.fromCache(getFileName)
        : await Flame.images.load(getFileName);

    sprite = Sprite(image);
  }

  @override
  void onMount() {
    super.onMount();

    if (!_cardCoordinator.isFaceUp) {
      return;
    }

    var count = 0;
    for (final effect in _cardCoordinator.playEffects.effects) {
      Svg svg;
      switch (effect.type) {
        case EffectType.heal:
          svg = IconManager.heart();
          break;
        case EffectType.damage:
          svg = IconManager.target();
          break;
        case EffectType.attack:
          svg = IconManager.target();
          break;
        case EffectType.credits:
          svg = IconManager.rupee();
          break;
        case EffectType.drawCard:
          svg = IconManager.drawCard();
          break;
        case EffectType.maxDamage:
          svg = IconManager.shield();
          break;
      }

      final icon = IconStat(svg, GameVariables.cardIconSize, effect.value)
        ..position = Vector2(
          (count * GameVariables.cardIconSize) + GameVariables.cardIconSize / 2,
          GameVariables.cardIconSize / 2,
        );
      add(icon);
      count += 1;
    }
  }
}
