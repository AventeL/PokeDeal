part of 'collection_pokemon_set_bloc.dart';

class CollectionPokemonSetEvent {}

final class CollectionPokemonGetSetWithCardsEvent
    extends CollectionPokemonSetEvent {
  final String setId;

  CollectionPokemonGetSetWithCardsEvent({required this.setId});
}
