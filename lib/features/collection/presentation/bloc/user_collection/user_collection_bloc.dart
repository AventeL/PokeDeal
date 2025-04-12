import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pokedeal/features/collection/domain/models/card/base_pokemon_card.dart';
import 'package:pokedeal/features/collection/domain/repository/collection_pokemon_repository.dart';

part 'user_collection_event.dart';
part 'user_collection_state.dart';

class UserCollectionBloc
    extends Bloc<UserCollectionEvent, UserCollectionState> {
  final CollectionPokemonRepository collectionPokemonRepository;

  UserCollectionBloc({required this.collectionPokemonRepository})
    : super(UserCollectionInitial()) {
    on<UserCollectionLoadEvent>(onUserCollectionLoadEvent);
  }

  Future<void> onUserCollectionLoadEvent(
    UserCollectionLoadEvent event,
    Emitter<UserCollectionState> emit,
  ) async {
    emit(UserCollectionLoading());
    try {
      List<BasePokemonCard> cards = await collectionPokemonRepository
          .getUserCollection(userId: event.userId);
      emit(UserCollectionLoaded(pokemonCards: cards));
    } catch (e) {
      emit(UserCollectionError(message: e.toString()));
    }
  }

  Future<void> onUserCollectionAddCardEvent(
    UserCollectionAddCardEvent event,
    Emitter<UserCollectionState> emit,
  ) async {
    emit(UserCollectionLoading());
    try {
      await collectionPokemonRepository.addCardToUserCollection(
        id: event.pokemonCardId,
        quantity: event.quantity,
      );
      emit(UserCollectionStateCardAdded());
    } catch (e) {
      emit(UserCollectionError(message: e.toString()));
    }
  }
}
