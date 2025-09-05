import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';
import 'package:card_battler/game/services/card_loader_service.dart';
import 'package:card_battler/game/models/shared/card_model.dart';
import 'package:card_battler/game/models/shop/shop_card_model.dart';

void main() {
  group('CardLoaderService', () {
    
    group('loadCardsFromJson', () {
      testWidgets('loads CardModel instances successfully', (tester) async {
        // Mock the asset bundle
        tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          const MethodChannel('flutter/assets'),
          (MethodCall methodCall) async {
            if (methodCall.method == 'loadString' && methodCall.arguments == 'test_cards.json') {
              return '''[
                {
                  "name": "Test Card",
                  "type": "Action",
                  "effects": []
                }
              ]''';
            }
            return null;
          },
        );

        final cards = await CardLoaderService.loadCardsFromJson<CardModel>(
          'test_cards.json',
          CardModel.fromJson,
        );

        expect(cards, hasLength(1));
        expect(cards.first.name, equals('Test Card'));
        expect(cards.first.type, equals('Action'));
      });

      testWidgets('loads ShopCardModel instances successfully', (tester) async {
        tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          const MethodChannel('flutter/assets'),
          (MethodCall methodCall) async {
            if (methodCall.method == 'loadString' && methodCall.arguments == 'test_shop_cards.json') {
              return '''[
                {
                  "name": "Shop Card",
                  "type": "Action",
                  "cost": 10,
                  "effects": []
                }
              ]''';
            }
            return null;
          },
        );

        final cards = await CardLoaderService.loadCardsFromJson<ShopCardModel>(
          'test_shop_cards.json',
          ShopCardModel.fromJson,
        );

        expect(cards, hasLength(1));
        expect(cards.first.name, equals('Shop Card'));
        expect(cards.first.cost, equals(10));
      });

      testWidgets('handles empty JSON array', (tester) async {
        tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          const MethodChannel('flutter/assets'),
          (MethodCall methodCall) async {
            if (methodCall.method == 'loadString' && methodCall.arguments == 'empty.json') {
              return '[]';
            }
            return null;
          },
        );

        final cards = await CardLoaderService.loadCardsFromJson<CardModel>(
          'empty.json',
          CardModel.fromJson,
        );

        expect(cards, isEmpty);
      });

      testWidgets('throws error for non-existent file', (tester) async {
        tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          const MethodChannel('flutter/assets'),
          (MethodCall methodCall) async {
            if (methodCall.method == 'loadString') {
              throw PlatformException(
                code: 'flutter/assets',
                message: 'Asset not found: ${methodCall.arguments}',
              );
            }
            return null;
          },
        );

        expect(
          () => CardLoaderService.loadCardsFromJson<CardModel>(
            'non_existent.json',
            CardModel.fromJson,
          ),
          throwsA(isA<PlatformException>()),
        );
      });

      testWidgets('throws error for invalid JSON', (tester) async {
        tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          const MethodChannel('flutter/assets'),
          (MethodCall methodCall) async {
            if (methodCall.method == 'loadString' && methodCall.arguments == 'invalid.json') {
              return 'invalid json content';
            }
            return null;
          },
        );

        expect(
          () => CardLoaderService.loadCardsFromJson<CardModel>(
            'invalid.json',
            CardModel.fromJson,
          ),
          throwsA(isA<FormatException>()),
        );
      });

      testWidgets('supports generic type loading with custom fromJson', (tester) async {
        tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          const MethodChannel('flutter/assets'),
          (MethodCall methodCall) async {
            if (methodCall.method == 'loadString' && methodCall.arguments == 'test_cards.json') {
              return '''[
                {
                  "name": "Test Card",
                  "type": "Action",
                  "effects": []
                }
              ]''';
            }
            return null;
          },
        );

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
            "name": "Direct Card",
            "type": "Action",
            "effects": []
          }
        ]''';

        final cards = loadCardsFromJsonString<CardModel>(
          jsonString,
          CardModel.fromJson,
        );

        expect(cards, hasLength(1));
        expect(cards.first.name, equals('Direct Card'));
        expect(cards.first.type, equals('Action'));
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
            "name": null,
            "type": null,
            "effects": []
          }
        ]''';

        expect(
          () => loadCardsFromJsonString<CardModel>(
            jsonString,
            CardModel.fromJson,
          ),
          throwsA(isA<TypeError>()),
        );
      });
    });
  });
}