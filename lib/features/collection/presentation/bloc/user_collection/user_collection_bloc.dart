import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pokedeal/core/di/injection_container.dart';
import 'package:pokedeal/features/authentication/domain/repository/authentication_repository.dart';
import 'package:pokedeal/features/collection/domain/models/card/user_card_collection.dart';
import 'package:pokedeal/features/collection/domain/models/enum/variant_value.dart';
import 'package:pokedeal/features/collection/domain/repository/collection_pokemon_repository.dart';

part 'user_collection_event.dart';
part 'user_collection_state.dart';

class UserCollectionBloc
    extends Bloc<UserCollectionEvent, UserCollectionState> {
  final CollectionPokemonRepository collectionPokemonRepository;

  UserCollectionBloc({required this.collectionPokemonRepository})
    : super(UserCollectionInitial()) {
    on<UserCollectionLoadEvent>(onUserCollectionLoadEvent);
    on<UserCollectionAddCardEvent>(onUserCollectionAddCardEvent);
  }

  Future<void> onUserCollectionLoadEvent(
    UserCollectionLoadEvent event,
    Emitter<UserCollectionState> emit,
  ) async {
    emit(UserCollectionLoading());
    try {
      List<UserCardCollection> cards = await collectionPokemonRepository
          .getUserCollection(
            userId: event.userId,
            cardId: event.cardId,
            setId: event.setId,
          );

      emit(UserCollectionLoaded(userCardsCollection: cards));
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
        variant: event.variant,
        setId: event.setId,
      );
      emit(UserCollectionStateCardAdded());
      if (event.needRefresh) {
        add(
          UserCollectionLoadEvent(
            userId: getIt<AuthenticationRepository>().userProfile!.id,
            cardId: event.pokemonCardId,
            setId: event.setId,
          ),
        );
      }
    } catch (e) {
      emit(UserCollectionError(message: e.toString()));
    }
  }
}
