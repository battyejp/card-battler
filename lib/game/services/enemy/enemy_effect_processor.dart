import 'package:card_battler/game/models/shared/card_model.dart';
import 'package:card_battler/game/models/enemy/enemy_turn_state.dart';
import 'package:card_battler/game/models/shared/effect_model.dart';
import 'package:card_battler/game/models/team/players_model.dart';

/// Service responsible for processing enemy card effects on players
/// Follows the Single Responsibility Principle by focusing solely on effect processing logic
abstract class EnemyEffectProcessor {
  /// Applies all effects from an enemy card to the players
  void processCardEffects(CardModel card, EnemyTurnState state);
}

/// Default implementation of EnemyEffectProcessor
class DefaultEnemyEffectProcessor implements EnemyEffectProcessor {
  @override
  void processCardEffects(CardModel card, EnemyTurnState state) {
    for (var effect in card.effects) {
      _processEffect(effect, state.playersModel);
    }
  }

  void _processEffect(EffectModel effect, PlayersModel playersModel) {
    switch (effect.type) {
      case EffectType.attack:
        _handleAttackEffect(effect, playersModel);
        break;
      case EffectType.heal:
        _handleHealEffect(effect, playersModel);
        break;
      case EffectType.credits:
        _handleCreditsEffect(effect, playersModel);
        break;
      case EffectType.damageLimit:
        _handleDamageLimitEffect(effect, playersModel);
        break;
      case EffectType.drawCard:
        // DrawCard effects don't affect players directly
        // They are handled by the card draw service for turn continuation logic
        break;
    }
  }

  void _handleAttackEffect(EffectModel effect, PlayersModel playersModel) {
    switch (effect.target) {
      case EffectTarget.activePlayer:
        for (final stats in playersModel.players.where((player) => player.isActive)) {
          stats.health.changeHealth(-effect.value);
        }
        break;
      case EffectTarget.otherPlayers:
        for (final stats in playersModel.players.where((player) => !player.isActive)) {
          stats.health.changeHealth(-effect.value);
        }
        break;
      case EffectTarget.allPlayers:
        for (var stats in playersModel.players) {
          stats.health.changeHealth(-effect.value);
        }
        break;
      case EffectTarget.base:
      case EffectTarget.chosenPlayer:
      case EffectTarget.self:
        // These targets are not applicable for enemy attacks on players
        break;
    }
  }

  void _handleHealEffect(EffectModel effect, PlayersModel playersModel) {
  }

  void _handleCreditsEffect(EffectModel effect, PlayersModel playersModel) {
  }

  void _handleDamageLimitEffect(EffectModel effect, PlayersModel playersModel) {
  }
}