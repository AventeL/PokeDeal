part of 'collection_pokemon_card_bloc.dart';

class CollectionPokemonCardState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class CollectionPokemonCardInitial extends CollectionPokemonCardState {}

final class CollectionPokemonCardLoading extends CollectionPokemonCardState {}

final class CollectionPokemonCardError extends CollectionPokemonCardState {
  final String message;

  CollectionPokemonCardError({required this.message});

  @override
  List<Object?> get props => [message];
}

final class CollectionPokemonCardsGet extends CollectionPokemonCardState {
  final BasePokemonCard card;

  CollectionPokemonCardsGet({required this.card});

  @override
  List<Object?> get props => [card];
}

final class CollectionPokemonCardsByIdsGet extends CollectionPokemonCardState {
  final Map<String, BasePokemonCard> cards;

  CollectionPokemonCardsByIdsGet({required this.cards});

  @override
  List<Object?> get props => [cards];
}
