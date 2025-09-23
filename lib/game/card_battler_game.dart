import 'package:card_battler/game/services/initialization/game_component_builder.dart';
import 'package:card_battler/game/services/initialization/game_initialization_service.dart';
import 'package:flame/game.dart';

class CardBattlerGame extends FlameGame {
  // Test-only constructor to set size before onLoad
  CardBattlerGame.withSize(Vector2 testSize) : _testSize = testSize;

  // Default constructor with new game state
  CardBattlerGame();

  Vector2? _testSize;
  late final RouterComponent router;

  @override
  Future<void> onLoad() async {
    if (_testSize != null) {
      onGameResize(_testSize!);
    }

    await images.loadAllImages();
    final gameState = await GameInitializationService.initializeGameState();
    final services = GameInitializationService.createServices(gameState);
    final router = GameComponentBuilder.buildGameComponents(
      gameSize: size,
      services: services,
    );

    world.add(router);
  }
}
