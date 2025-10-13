import 'package:card_battler/game/services/initialization/game_component_builder.dart';
import 'package:card_battler/game/services/initialization/game_initialization_service.dart';
import 'package:card_battler/game/ui/icon_manager.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';

class CardBattlerGame extends FlameGame {
  // Test-only constructor to set size before onLoad
  CardBattlerGame.withSize(Vector2 testSize) : _testSize = testSize;

  // Default constructor with new game state
  CardBattlerGame();

  Vector2? _testSize;
  late final RouterComponent router;

  @override
  Future<void> onLoad() async {
    // Load background image
    final bgSprite = await Sprite.load('game_background_with_base.png');
    final bgSize = Vector2(bgSprite.srcSize.x, bgSprite.srcSize.y);

    // Restrict game size to background aspect ratio
    Vector2 targetSize;
    if (_testSize != null) {
      targetSize = _testSize!;
    } else {
      // For web, center and fit within background
      if (kIsWeb) {
        final minDim = size.x < size.y ? size.x : size.y;
        final aspect = bgSize.x / bgSize.y;
        if (minDim / aspect < size.y) {
          targetSize = Vector2(minDim, minDim / aspect);
        } else {
          targetSize = Vector2(size.y * aspect, size.y);
        }
      } else {
        // For mobile, always cover the screen with the background, keep aspect ratio
        final screenAspect = size.x / size.y;
        final bgAspect = bgSize.x / bgSize.y;
        if (screenAspect > bgAspect) {
          // Screen is wider, scale by height so background covers width
          targetSize = Vector2(size.x, size.x / bgAspect);
        } else {
          // Screen is taller, scale by width so background covers height
          targetSize = Vector2(size.y * bgAspect, size.y);
        }
      }
    }
    // Camera uses default behavior; background and components are centered/scaled manually

    // Add background sprite, centered and scaled
    final bgComponent = SpriteComponent(
      sprite: bgSprite,
      size: targetSize,
      anchor: Anchor.center,
      position: kIsWeb ? size / 2 : targetSize / 2,
      priority: -100,
    );
    add(bgComponent);

    //TODO might get rid of this eventually and should we have a loading screen for this in the game
    await images.loadAllImages();
    final gameState = await GameInitializationService.initializeGameState();
    await IconManager.loadAllImages();

    final services = GameInitializationService.createServices(gameState);
    router = GameComponentBuilder.buildGameComponents(
      gameSize: kIsWeb ? targetSize : size,
      services: services,
    );

    world.add(router);
  }
}
