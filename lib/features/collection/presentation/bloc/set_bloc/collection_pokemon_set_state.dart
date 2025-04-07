part of 'collection_pokemon_set_bloc.dart';

class CollectionPokemonSetState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class CollectionPokemonSetInitial extends CollectionPokemonSetState {}

final class CollectionPokemonSetLoading extends CollectionPokemonSetState {}

final class CollectionPokemonSetError extends CollectionPokemonSetState {
  final String message;

  CollectionPokemonSetError({required this.message});

  @override
  List<Object?> get props => [message];
}

final class CollectionPokemonSetWithCardsGet extends CollectionPokemonSetState {
  final PokemonSetWithCards setWithCards;

  CollectionPokemonSetWithCardsGet({required this.setWithCards});

  @override
  List<Object?> get props => [setWithCards];
}
