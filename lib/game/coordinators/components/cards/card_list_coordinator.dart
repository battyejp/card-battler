import 'package:card_battler/game/coordinators/components/cards/card_coordinator.dart';

class CardListCoordinator<T extends CardCoordinator> {
  //TODO could this jusy inherit a List<CardCoordinator>?
  final List<T> _cardCoordinators;

  CardListCoordinator({required List<T> cardCoordinators})
    : _cardCoordinators = cardCoordinators;

  List<T> get cardCoordinators => _cardCoordinators;
}
