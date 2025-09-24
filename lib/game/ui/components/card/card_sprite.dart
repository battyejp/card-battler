import 'package:card_battler/game/card_battler_game.dart';
import 'package:card_battler/game/coordinators/components/cards/card_coordinator.dart';
import 'package:flame/components.dart';

class CardSprite extends SpriteComponent {
  CardSprite(CardCoordinator cardCoordinator, bool isMini)
    : _cardCoordinator = cardCoordinator,
      _isMini = isMini,
      super(anchor: Anchor.center);

  final CardCoordinator _cardCoordinator;
  final bool _isMini;

  String get getFileName {
    if (!_cardCoordinator.isFaceUp) {
      return _cardCoordinator.type == 'Enemy'
          ? 'enemy_card_back_560.png'
          : 'card_face_down_0.08.png';
    }

    return _cardCoordinator.filename.replaceAll('size', _isMini ? '60' : '560');
  }

  CardCoordinator get coordinator => _cardCoordinator;

  @override
  void onLoad() {
    super.onLoad();

    //TODO should we pass this in the constructor?
    final game = findGame() as CardBattlerGame;
    final image = game.images.fromCache(getFileName);
    sprite = Sprite(image);
  }
}
