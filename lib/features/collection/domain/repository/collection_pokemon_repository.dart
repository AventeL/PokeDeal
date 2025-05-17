import 'package:pokedeal/core/di/injection_container.dart';
import 'package:pokedeal/features/authentication/domain/repository/authentication_repository.dart';
import 'package:pokedeal/features/collection/data/collection_pokemon_data_source_interface.dart';
import 'package:pokedeal/features/collection/domain/models/card/base_pokemon_card.dart';
import 'package:pokedeal/features/collection/domain/models/card/user_card_collection.dart';
import 'package:pokedeal/features/collection/domain/models/enum/variant_value.dart';
import 'package:pokedeal/features/collection/domain/models/pokemon_serie.dart';
import 'package:pokedeal/features/collection/domain/models/pokemon_serie_brief.dart';
import 'package:pokedeal/features/collection/domain/models/pokemon_set.dart';

class CollectionPokemonRepository {
  final ICollectionPokemonDataSource collectionPokemonDataSource;
  List<PokemonSerieBrief> seriesBriefs = [];
  List<PokemonSerie> series = [];
  Map<String, PokemonSet> setsMap = {};
  Map<String, BasePokemonCard> cardsMap = {};
  Map<String, List<UserCardCollection>> userCardsBySetIdMap = {};

  CollectionPokemonRepository({required this.collectionPokemonDataSource});

  Future<List<PokemonSerieBrief>> getSeriesBriefs() async {
    if (seriesBriefs.isNotEmpty) {
      return seriesBriefs;
    }
    List<PokemonSerieBrief> series =
        await collectionPokemonDataSource.getSeriesBriefs();
    series = series.reversed.toList();
    seriesBriefs.addAll(series);
    return series;
  }

  Future<List<PokemonSerie>> getSeriesWithSets() async {
    List<PokemonSerieBrief> seriesBriefs = await getSeriesBriefs();
    List<PokemonSerie> newList = [];
    for (var serie in seriesBriefs) {
      newList.add(await collectionPokemonDataSource.getSerie(serie.id));
    }

    series.addAll(newList);
    return newList;
  }

  Future<PokemonSet> getSetWithCards({required String setId}) async {
    PokemonSet setWithCards;
    if (setsMap.containsKey(setId)) {
      return setsMap[setId]!;
    } else {
      setWithCards = await collectionPokemonDataSource.getSet(setId);
      setsMap[setId] = setWithCards;
    }
    return setWithCards;
  }

  Future<BasePokemonCard> getCard({required String id}) async {
    BasePokemonCard card;
    if (cardsMap.containsKey(id)) {
      return cardsMap[id]!;
    }
    card = await collectionPokemonDataSource.getCard(id: id);
    cardsMap[id] = card;
    return card;
  }

  Future<List<UserCardCollection>> getUserCollection({
    required String userId,
    String? cardId,
    String? setId,
  }) async {
    if (setId != null &&
        cardId == null &&
        userId == getIt<AuthenticationRepository>().userProfile!.id) {
      if (userCardsBySetIdMap.containsKey(setId)) {
        return userCardsBySetIdMap[setId]!;
      }
    }

    List<UserCardCollection> cards = await collectionPokemonDataSource
        .getUserCollection(userId: userId, cardId: cardId, setId: setId);

    if (setId != null &&
        cardId == null &&
        userId == getIt<AuthenticationRepository>().userProfile!.id) {
      userCardsBySetIdMap[setId] = cards;
    }
    cards.sort((a, b) => b.quantity.compareTo(a.quantity));

    return cards;
  }

  Future<UserCardCollection> addCardToUserCollection({
    required String id,
    required int quantity,
    required VariantValue variant,
    required String setId,
  }) async {
    UserCardCollection newUserCardCollection = await collectionPokemonDataSource
        .addCardToUserCollection(
          id: id,
          quantity: quantity,
          variant: variant,
          setId: setId,
        );

    if (userCardsBySetIdMap.containsKey(setId)) {
      List<UserCardCollection> userCards = userCardsBySetIdMap[setId]!;
      int index = userCards.indexWhere(
        (card) => card.id == newUserCardCollection.id,
      );

      if (index != -1) {
        userCards[index] = newUserCardCollection;
      } else {
        userCards.add(newUserCardCollection);
      }
    }
    return newUserCardCollection;
  }

  Future<List<PokemonSet>> getSetsFromUserCards({
    required List<UserCardCollection> userCards,
  }) async {
    List<PokemonSet> setsToReturn = [];
    for (var userCard in userCards) {
      if (!setsMap.containsKey(userCard.setId)) {
        PokemonSet set = await collectionPokemonDataSource.getSet(
          userCard.setId,
        );
        setsMap[userCard.setId] = set;
      }
      if (!setsToReturn.contains(setsMap[userCard.setId]!)) {
        setsToReturn.add(setsMap[userCard.setId]!);
      }
    }
    return setsToReturn;
  }

  Future<List<PokemonSerie>> getSeriesFromSets({
    required List<PokemonSet> sets,
  }) async {
    List<PokemonSerie> seriesToReturn = [];
    for (var set in sets) {
      PokemonSerie serieToAdd = series.firstWhere(
        (PokemonSerie serie) => serie.id == set.serieBrief.id,
      );

      if (!seriesToReturn.contains(serieToAdd)) {
        seriesToReturn.add(serieToAdd);
      }
    }
    return seriesToReturn;
  }

  Future<List<BasePokemonCard>> getCardsDetailsFromUserCards({
    required List<UserCardCollection> userCards,
  }) async {
    List<BasePokemonCard> cards = [];
    for (var userCard in userCards) {
      if (!cardsMap.containsKey(userCard.cardId)) {
        BasePokemonCard card = await collectionPokemonDataSource.getCard(
          id: userCard.cardId,
        );
        cardsMap[userCard.cardId] = card;
      }
      cards.add(cardsMap[userCard.cardId]!);
    }
    return cards;
  }

  Future<Map<String, BasePokemonCard>> getCardByIds({
    required List<String> ids,
  }) async {
    Map<String, BasePokemonCard> cards = {};
    for (var id in ids) {
      cards[id] = await getCard(id: id);
    }
    return cards;
  }
  
  Future<void> deleteCardFromUserCollection({
    required String id,
    required int quantity,
    required VariantValue variant,
    required String setId,
  }) async {
    await collectionPokemonDataSource.deleteCardFromUserCollection(
      id: id,
      quantity: quantity,
      variant: variant,
      setId: setId,
    );
  }
}
