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
  List<UserCardCollection> userCardsCollection = [];

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
    List<UserCardCollection> cards = await collectionPokemonDataSource
        .getUserCollection(userId: userId, cardId: cardId, setId: setId);

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
    if (userCardsCollection.isNotEmpty) {
      for (var card in userCardsCollection) {
        if (card.cardId == newUserCardCollection.cardId &&
            card.setId == newUserCardCollection.setId &&
            card.variant == newUserCardCollection.variant) {
          userCardsCollection.remove(card);
          break;
        }
      }
    }

    userCardsCollection.add(newUserCardCollection);
    return newUserCardCollection;
  }
}
