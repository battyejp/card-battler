import 'package:card_battler/game/models/card/card_list_model.dart';
import 'package:card_battler/game/models/card/card_model.dart';
import 'package:card_battler/game/models/enemy/enemy_model.dart';

class EnemiesModel {
  const EnemiesModel({
    required this.enemies,
    required this.playedCards,
    required this.deckCards,
  });

  final List<EnemyModel> enemies;
  final CardListModel<CardModel> playedCards;
  final CardListModel<CardModel> deckCards;
}
