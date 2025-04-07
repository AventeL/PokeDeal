part of 'collection_pokemon_serie_bloc.dart';

class CollectionPokemonSerieState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class CollectionPokemonSerieInitial extends CollectionPokemonSerieState {}

final class CollectionPokemonSerieLoading extends CollectionPokemonSerieState {}

final class CollectionPokemonSerieError extends CollectionPokemonSerieState {
  final String message;

  CollectionPokemonSerieError({required this.message});

  @override
  List<Object?> get props => [message];
}

final class CollectionPokemonSeriesGet extends CollectionPokemonSerieState {
  final List<PokemonSerie> series;

  CollectionPokemonSeriesGet({required this.series});

  @override
  List<Object?> get props => [series];
}
