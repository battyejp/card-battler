import 'package:card_battler/game/models/enemy/enemies_model.dart';
import 'package:card_battler/game/models/player/player_model.dart';
import 'package:card_battler/game/models/shop/shop_model.dart';
import 'package:card_battler/game/models/team/team_model.dart';
import 'package:card_battler/game/models/shared/reactive_model.dart';

class PlayerTurnModel with ReactiveModel<PlayerTurnModel> {
  final PlayerModel playerModel;
  final TeamModel teamModel;
  final EnemiesModel enemiesModel;
  final ShopModel shopModel;
  
  bool _cardsDrawn = false;
  
  PlayerTurnModel({
    required this.playerModel,
    required this.teamModel,
    required this.enemiesModel,
    required this.shopModel,
  });
  
  bool get cardsDrawn => _cardsDrawn;
  
  void setCardsDrawn(bool drawn) {
    if (_cardsDrawn != drawn) {
      _cardsDrawn = drawn;
      notifyChange();
    }
  }
}