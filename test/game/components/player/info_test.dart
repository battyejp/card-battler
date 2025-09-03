import 'package:flame/components.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:card_battler/game/components/player/info.dart';
import 'package:card_battler/game/components/shared/health.dart';
import 'package:card_battler/game/components/shared/value_image_label.dart';
import 'package:card_battler/game/models/player/info_model.dart';
import 'package:card_battler/game/models/shared/health_model.dart';
import 'package:card_battler/game/models/shared/value_image_label_model.dart';

void main() {
  group('Info', () {
    InfoModel createTestInfoModel() {
      return InfoModel(
        attack: ValueImageLabelModel(value: 50, label: 'Attack'),
        credits: ValueImageLabelModel(value: 25, label: 'Credits'),
        healthModel: HealthModel(maxHealth: 100),
        name: 'TestPlayer',
      );
    }

    testWithFlameGame('Info can be created and added to game', (game) async {
      final info = Info(createTestInfoModel())..size = Vector2(300, 50);

      await game.ensureAdd(info);

      expect(info.size, equals(Vector2(300, 50)));
    });

    testWithFlameGame('Info extends PositionComponent', (game) async {
      final info = Info(createTestInfoModel());

      expect(info, isA<PositionComponent>());
    });

    testWithFlameGame('Info can be positioned', (game) async {
      final info = Info(createTestInfoModel())
        ..size = Vector2(300, 50)
        ..position = Vector2(50, 10);

      await game.ensureAdd(info);

      expect(info.position, equals(Vector2(50, 10)));
      expect(info.size, equals(Vector2(300, 50)));
    });

    testWithFlameGame('Info initializes with InfoModel', (game) async {
      final info = Info(createTestInfoModel())..size = Vector2(300, 50);

      await game.ensureAdd(info);

      // Should have 3 child components (3 sections)
      expect(info.children.whereType<PositionComponent>().length, equals(3));
    });

    testWithFlameGame('Info creates three labeled sections', (game) async {
      final info = Info(createTestInfoModel())..size = Vector2(300, 50);

      await game.ensureAdd(info);

      // Should have 3 PositionComponent sections
      final sections = info.children.whereType<PositionComponent>().toList();
      expect(sections.length, equals(3));
      
      // First section should contain a Health component
      expect(sections[0].children.whereType<Health>().length, equals(1));
      
      // Second and third sections should contain ValueImageLabel components
      expect(sections[1].children.whereType<ValueImageLabel>().length, equals(1));
      expect(sections[2].children.whereType<ValueImageLabel>().length, equals(1));
    });

    testWithFlameGame('Info sections are properly sized and positioned', (game) async {
      final info = Info(createTestInfoModel())..size = Vector2(300, 50);

      await game.ensureAdd(info);

      final sections = info.children.whereType<PositionComponent>().toList();
      
      // Each section should be 1/3 of the total width
      final expectedWidth = 300 / 3;
      for (final section in sections) {
        expect(section.size.x, equals(expectedWidth));
        expect(section.size.y, equals(50));
      }
      
      // Check positioning - sections should be side by side
      expect(sections[0].position, equals(Vector2(0, 0)));
      expect(sections[1].position, equals(Vector2(expectedWidth, 0)));
      expect(sections[2].position, equals(Vector2(expectedWidth * 2, 0)));
    });

    testWithFlameGame('Info sections have debug colors', (game) async {
      final info = Info(createTestInfoModel())..size = Vector2(300, 50);

      await game.ensureAdd(info);

      final sections = info.children.whereType<PositionComponent>().toList();
      
      // Verify each section has a debug color
      for (final section in sections) {
        expect(section.debugColor, isNotNull);
      }
    });

    testWithFlameGame('Info contains health, attack, and credits labels', (game) async {
      final info = Info(createTestInfoModel())..size = Vector2(300, 50);

      await game.ensureAdd(info);

      final sections = info.children.whereType<PositionComponent>().toList();
      
      // First section has Health component
      final healthComponent = sections[0].children.whereType<Health>().first;
      expect(healthComponent, isNotNull);
      
      // Second and third sections have ValueImageLabel components
      final attackLabel = sections[1].children.whereType<ValueImageLabel>().first;
      final creditsLabel = sections[2].children.whereType<ValueImageLabel>().first;
      
      expect(attackLabel, isNotNull);
      expect(creditsLabel, isNotNull);
      
      // Verify components are loaded
      await game.ready();
      
      // Check that the ValueImageLabel components have text components
      expect(attackLabel.children.whereType<TextComponent>().length, greaterThan(0));
      expect(creditsLabel.children.whereType<TextComponent>().length, greaterThan(0));
    });

    testWithFlameGame('Info layout adapts to different sizes', (game) async {
      final info = Info(createTestInfoModel())..size = Vector2(600, 100);

      await game.ensureAdd(info);

      final sections = info.children.whereType<PositionComponent>().toList();
      
      // Each section should be 1/3 of the new width
      final expectedWidth = 600 / 3;
      for (final section in sections) {
        expect(section.size.x, equals(expectedWidth));
        expect(section.size.y, equals(100));
      }
    });
  });
}