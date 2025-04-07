import 'package:pokedeal/features/collection/data/collection_pokemon_data_source_interface.dart';
import 'package:pokedeal/features/collection/domain/models/pokemon_serie.dart';
import 'package:pokedeal/features/collection/domain/models/pokemon_serie_brief.dart';
import 'package:pokedeal/features/collection/domain/models/pokemon_set.dart';

class CollectionPokemonRepository {
  final ICollectionPokemonDataSource collectionPokemonDataSource;
  List<PokemonSerie> series = [];
  Map<String, PokemonSet> setsDetails = {};

  CollectionPokemonRepository({required this.collectionPokemonDataSource});

  Future<List<PokemonSerieBrief>> getSeriesBriefs() async {
    List<PokemonSerieBrief> series =
        await collectionPokemonDataSource.getSeriesBriefs();
    series = series.reversed.toList();

    return series;
  }

  Future<List<PokemonSerie>> getSeriesWithSets() async {
    List<PokemonSerieBrief> sets =
        await collectionPokemonDataSource.getSeriesBriefs();
    List<PokemonSerie> newList = [];
    for (var serie in sets) {
      newList.add(await collectionPokemonDataSource.getSerie(serie.id));
    }
    newList = newList.reversed.toList();
    series = newList;
    return newList;
  }

  Future<PokemonSet> getSetWithCards({required String setId}) async {
    PokemonSet setWithCards;
    if (setsDetails.containsKey(setId)) {
      return setsDetails[setId]!;
    } else {
      setWithCards = await collectionPokemonDataSource.getSet(setId);
      setsDetails[setId] = setWithCards;
    }
    return setWithCards;
  }
}
