import 'package:card_battler/game/card_battler_game.dart';
import 'package:card_battler/screens/services/game_navigation_service.dart';
import 'package:flame/game.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCardBattlerGame extends Mock implements CardBattlerGame {}

class MockRouterComponent extends Mock implements RouterComponent {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('GameNavigationService', () {
    late MockCardBattlerGame mockGame;
    late MockRouterComponent mockRouter;
    late GameNavigationService navigationService;

    setUp(() {
      mockGame = MockCardBattlerGame();
      mockRouter = MockRouterComponent();
      when(() => mockGame.router).thenReturn(mockRouter);
      navigationService = GameNavigationService(mockGame);
    });

    group('navigateToShop', () {
      test('calls router.pushNamed with shop route', () {
        when(() => mockRouter.pushNamed('shop')).thenReturn(null);

        navigationService.navigateToShop();

        verify(() => mockRouter.pushNamed('shop')).called(1);
      });
    });

    group('navigateBackFromShop', () {
      test('calls router.pop to go back from shop', () {
        when(() => mockRouter.pop()).thenReturn(null);

        navigationService.navigateBackFromShop();

        verify(() => mockRouter.pop()).called(1);
      });
    });

    group('goBack', () {
      test('calls router.pop for generic navigation back', () {
        when(() => mockRouter.pop()).thenReturn(null);

        navigationService.goBack();

        verify(() => mockRouter.pop()).called(1);
      });
    });
  });
}
