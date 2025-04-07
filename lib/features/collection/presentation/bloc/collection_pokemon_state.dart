part of 'collection_pokemon_bloc.dart';

class CollectionPokemonState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class CollectionPokemonInitial extends CollectionPokemonState {}

final class CollectionPokemonLoading extends CollectionPokemonState {}

final class CollectionPokemonError extends CollectionPokemonState {
  final String message;

  CollectionPokemonError({required this.message});

  @override
  List<Object?> get props => [message];
}

final class CollectionPokemonSeriesGet extends CollectionPokemonState {
  final List<PokemonSerie> series;

  CollectionPokemonSeriesGet({required this.series});

  @override
  List<Object?> get props => [series];
}
