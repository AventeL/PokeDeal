import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pokedeal/core/di/injection_container.dart';
import 'package:pokedeal/features/authentication/domain/repository/authentication_repository.dart';
import 'package:pokedeal/features/collection/domain/models/card/base_pokemon_card.dart';
import 'package:pokedeal/features/collection/domain/models/card/user_card_collection.dart';
import 'package:pokedeal/features/collection/domain/models/enum/variant_value.dart';
import 'package:pokedeal/features/collection/domain/models/pokemon_serie.dart';
import 'package:pokedeal/features/collection/domain/models/pokemon_set.dart';
import 'package:pokedeal/features/collection/domain/repository/collection_pokemon_repository.dart';

part 'user_collection_event.dart';
part 'user_collection_state.dart';

class UserCollectionBloc
    extends Bloc<UserCollectionEvent, UserCollectionState> {
  final CollectionPokemonRepository collectionPokemonRepository;

  UserCollectionBloc({required this.collectionPokemonRepository})
    : super(UserCollectionInitial()) {
    on<UserCollectionLoadSetEvent>(onUserCollectionLoadSetEvent);
    on<UserCollectionLoadCardEvent>(onUserCollectionLoadCardEvent);
    on<UserCollectionAddCardEvent>(onUserCollectionAddCardEvent);
    on<UserCollectionLoadAllEvent>(onUserCollectionLoadAllEvent);
    on<UserCollectionDeleteCardEvent>(onUserCollectionDeleteCardEvent);
  }

  Future<void> onUserCollectionLoadSetEvent(
    UserCollectionLoadSetEvent event,
    Emitter<UserCollectionState> emit,
  ) async {
    emit(UserCollectionLoading());
    try {
      List<UserCardCollection> cards = await collectionPokemonRepository
          .getUserCollection(userId: event.userId, setId: event.setId);

      emit(UserCollectionSetLoaded(userCardsCollection: cards));
    } catch (e) {
      emit(UserCollectionError(message: e.toString()));
    }
  }

  Future<void> onUserCollectionLoadCardEvent(
    UserCollectionLoadCardEvent event,
    Emitter<UserCollectionState> emit,
  ) async {
    emit(UserCollectionLoading());
    try {
      List<UserCardCollection> cards = await collectionPokemonRepository
          .getUserCollection(userId: event.userId, cardId: event.cardId);

      emit(UserCollectionCardLoaded(userCardsCollection: cards));
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
          UserCollectionLoadCardEvent(
            userId: getIt<AuthenticationRepository>().userProfile!.id,
            cardId: event.pokemonCardId,
          ),
        );
      }
    } catch (e) {
      emit(UserCollectionError(message: e.toString()));
    }
  }

  Future<void> onUserCollectionLoadAllEvent(
    UserCollectionLoadAllEvent event,
    Emitter<UserCollectionState> emit,
  ) async {
    emit(UserCollectionLoading());
    try {
      List<UserCardCollection> cards = await collectionPokemonRepository
          .getUserCollection(userId: event.userId);

      List<PokemonSet> sets = await collectionPokemonRepository
          .getSetsFromUserCards(userCards: cards);

      List<PokemonSerie> series = await collectionPokemonRepository
          .getSeriesFromSets(sets: sets);

      List<BasePokemonCard> listOfCards = await collectionPokemonRepository
          .getCardsDetailsFromUserCards(userCards: cards);

      emit(
        UserCollectionAllLoaded(
          userCardsCollection: cards,
          setsCollection: sets,
          seriesCollection: series,
          listOfCards: listOfCards,
        ),
      );
    } catch (e) {
      emit(UserCollectionError(message: e.toString()));
    }
  }

  Future<void> onUserCollectionDeleteCardEvent(
    UserCollectionDeleteCardEvent event,
    Emitter<UserCollectionState> emit,
  ) async {
    emit(UserCollectionLoading());
    try {
      await collectionPokemonRepository.deleteCardFromUserCollection(
        id: event.pokemonCardId,
        quantity: event.quantity,
        variant: event.variant,
        setId: event.setId,
      );
      emit(
        UserCollectionStateCardDeleted(
          cardId: event.pokemonCardId,
          userId: event.setId,
        ),
      );
      if (event.needRefresh) {
        add(
          UserCollectionLoadCardEvent(
            userId: getIt<AuthenticationRepository>().userProfile!.id,
            cardId: event.pokemonCardId,
          ),
        );
      }
    } catch (e) {
      emit(UserCollectionError(message: e.toString()));
    }
  }
}
