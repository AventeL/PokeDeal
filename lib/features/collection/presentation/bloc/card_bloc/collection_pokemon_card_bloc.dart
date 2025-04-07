import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pokedeal/features/collection/domain/models/card/base_pokemon_card.dart';
import 'package:pokedeal/features/collection/domain/repository/collection_pokemon_repository.dart';

part 'collection_pokemon_card_event.dart';
part 'collection_pokemon_card_state.dart';

class CollectionPokemonCardBloc
    extends Bloc<CollectionPokemonCardEvent, CollectionPokemonCardState> {
  final CollectionPokemonRepository collectionPokemonRepository;

  CollectionPokemonCardBloc({required this.collectionPokemonRepository})
    : super(CollectionPokemonCardInitial()) {
    on<CollectionPokemonGetCardEvent>(_onCollectionPokemonGetCardEvent);
  }

  Future<void> _onCollectionPokemonGetCardEvent(
    CollectionPokemonGetCardEvent event,
    Emitter<CollectionPokemonCardState> emit,
  ) async {
    try {
      emit(CollectionPokemonCardLoading());
      BasePokemonCard card = await collectionPokemonRepository.getCard(
        id: event.cardId,
      );
      emit(CollectionPokemonCardsGet(card: card));
    } catch (e) {
      emit(CollectionPokemonCardError(message: e.toString()));
    }
  }
}
