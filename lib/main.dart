import 'package:flutter/material.dart';
import 'card_battler_app.dart';
import 'services/platform_configuration_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PlatformConfigurationService.configureForGame();
  runApp(const CardBattlerApp());
}
