part of 'collection_pokemon_card_bloc.dart';

class CollectionPokemonCardEvent {}

final class CollectionPokemonGetCardEvent extends CollectionPokemonCardEvent {
  final String cardId;

  CollectionPokemonGetCardEvent({required this.cardId});
}

final class CollectionPokemonGetCardsByIdsEvent
    extends CollectionPokemonCardEvent {
  final List<String> cardIds;

  CollectionPokemonGetCardsByIdsEvent({required this.cardIds});
}
