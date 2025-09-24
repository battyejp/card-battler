import 'package:card_battler/game/card_battler_game.dart';
import 'package:flame/components.dart';

class CardSprite extends SpriteComponent {
  CardSprite(String fileName) : super(anchor: Anchor.center) {
    _fileName = fileName;
  }

  late String _fileName;

  String get getFileName => _fileName;

  @override
  void onLoad() {
    super.onLoad();

    final game = findGame() as CardBattlerGame;
    final image = game.images.fromCache(_fileName);
    print('Loaded image $_fileName with size ${image.width}x${image.height}');
    sprite = Sprite(image);
  }
}
