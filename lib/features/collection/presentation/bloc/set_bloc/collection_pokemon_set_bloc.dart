import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pokedeal/features/collection/domain/models/pokemon_set.dart';
import 'package:pokedeal/features/collection/domain/repository/collection_pokemon_repository.dart';

part 'collection_pokemon_set_event.dart';
part 'collection_pokemon_set_state.dart';

class CollectionPokemonSetBloc
    extends Bloc<CollectionPokemonSetEvent, CollectionPokemonSetState> {
  final CollectionPokemonRepository collectionPokemonRepository;

  CollectionPokemonSetBloc({required this.collectionPokemonRepository})
    : super(CollectionPokemonSetInitial()) {
    on<CollectionPokemonGetSetWithCardsEvent>(
      _onCollectionPokemonGetSetWithCardsEvent,
    );
  }

  Future<void> _onCollectionPokemonGetSetWithCardsEvent(
    CollectionPokemonGetSetWithCardsEvent event,
    Emitter<CollectionPokemonSetState> emit,
  ) async {
    try {
      emit(CollectionPokemonSetLoading());
      PokemonSet setWithCards = await collectionPokemonRepository
          .getSetWithCards(setId: event.setId);
      emit(CollectionPokemonSetWithCardsGet(setWithCards: setWithCards));
    } catch (e) {
      emit(CollectionPokemonSetError(message: e.toString()));
    }
  }
}
