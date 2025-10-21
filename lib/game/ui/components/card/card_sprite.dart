import 'package:card_battler/game/coordinators/components/cards/card_coordinator.dart';
import 'package:card_battler/game/game_variables.dart';
import 'package:card_battler/game/models/shared/effect_model.dart';
import 'package:card_battler/game/ui/components/common/icon_stat.dart';
import 'package:card_battler/game/ui/icon_manager.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame_svg/svg.dart';

class CardSprite extends SpriteComponent {
  CardSprite(CardCoordinator cardCoordinator)
    : _cardCoordinator = cardCoordinator,
      super(anchor: Anchor.center);

  final CardCoordinator _cardCoordinator;

  String get getFileName {
    if (!_cardCoordinator.isFaceUp) {
      return 'card_back.png';
    }

    // final filename = _cardCoordinator.filename.replaceAll(
    //   'size',
    //   _isMini ? '60' : '560',
    // );

    return _cardCoordinator.filename;
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
          svg = effect.target == EffectTarget.activePlayer
              ? IconManager.damage()
              : IconManager.multipleDamage();
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
