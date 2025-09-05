import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:card_battler/game/services/card_loader_service.dart';
import 'package:card_battler/game/models/shared/card_model.dart';
import 'package:card_battler/game/models/shop/shop_card_model.dart';

void main() {
  group('CardLoaderService', () {
    TestWidgetsFlutterBinding.ensureInitialized();

    setUpAll(() {
      // Setup test asset bundle for loadString calls
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        const MethodChannel('flutter/assets'),
        (MethodCall methodCall) async {
          if (methodCall.method == 'loadString') {
            final String key = methodCall.arguments as String;
            if (key == 'test_cards.json') {
              return '''[
                {
                  "id": "test_card_1",
                  "name": "Test Card",
                  "cardDescription": "A test card",
                  "cost": 2,
                  "effects": []
                }
              ]''';
            }
            if (key == 'test_shop_cards.json') {
              return '''[
                {
                  "id": "shop_card_1",
                  "name": "Shop Card",
                  "cardDescription": "A shop card",
                  "cost": 10,
                  "effects": []
                }
              ]''';
            }
            if (key == 'invalid.json') {
              return 'invalid json content';
            }
            if (key == 'empty.json') {
              return '[]';
            }
            throw FlutterError('Asset not found: $key');
          }
          return null;
        },
      );
    });

    tearDownAll(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        const MethodChannel('flutter/assets'),
        null,
      );
    });

    group('loadCardsFromJson', () {
      test('loads CardModel instances successfully', () async {
        final cards = await CardLoaderService.loadCardsFromJson<CardModel>(
          'test_cards.json',
          CardModel.fromJson,
        );

        expect(cards, hasLength(1));
        expect(cards.first.name, equals('Test Card'));
        expect(cards.first.type, equals('Action'));
      });

      test('loads ShopCardModel instances successfully', () async {
        final cards = await CardLoaderService.loadCardsFromJson<ShopCardModel>(
          'test_shop_cards.json',
          ShopCardModel.fromJson,
        );

        expect(cards, hasLength(1));
        expect(cards.first.name, equals('Shop Card'));
        expect(cards.first.name, equals('Shop Card'));
        expect(cards.first.cost, equals(10));
      });

      test('handles empty JSON array', () async {
        final cards = await CardLoaderService.loadCardsFromJson<CardModel>(
          'empty.json',
          CardModel.fromJson,
        );

        expect(cards, isEmpty);
      });

      test('throws error for non-existent file', () async {
        expect(
          () => CardLoaderService.loadCardsFromJson<CardModel>(
            'non_existent.json',
            CardModel.fromJson,
          ),
          throwsA(isA<FlutterError>()),
        );
      });

      test('throws error for invalid JSON', () async {
        expect(
          () => CardLoaderService.loadCardsFromJson<CardModel>(
            'invalid.json',
            CardModel.fromJson,
          ),
          throwsA(isA<FormatException>()),
        );
      });

      test('supports generic type loading with custom fromJson', () async {
        // Test with a custom fromJson function
        final cards = await CardLoaderService.loadCardsFromJson<CardModel>(
          'test_cards.json',
          (json) => CardModel.fromJson(json),
        );

        expect(cards, hasLength(1));
        expect(cards.first, isA<CardModel>());
      });
    });

    group('integration with loadCardsFromJsonString', () {
      test('delegates to loadCardsFromJsonString correctly', () {
        const jsonString = '''[
          {
            "id": "direct_card",
            "name": "Direct Card",
            "cardDescription": "Direct JSON card",
            "cost": 3,
            "effects": []
          }
        ]''';

        final cards = loadCardsFromJsonString<CardModel>(
          jsonString,
          CardModel.fromJson,
        );

        expect(cards, hasLength(1));
        expect(cards.first.name, equals('Direct Card'));
        expect(cards.first.name, equals('Direct Card'));
      });
    });

    group('error handling', () {
      test('propagates JSON parsing errors', () {
        expect(
          () => loadCardsFromJsonString<CardModel>(
            'invalid json',
            CardModel.fromJson,
          ),
          throwsA(isA<FormatException>()),
        );
      });

      test('propagates fromJson factory errors', () {
        const jsonString = '''[
          {
            "invalid": "data"
          }
        ]''';

        expect(
          () => loadCardsFromJsonString<CardModel>(
            jsonString,
            CardModel.fromJson,
          ),
          throwsException,
        );
      });
    });
  });
}