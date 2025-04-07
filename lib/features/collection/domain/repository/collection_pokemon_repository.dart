import 'package:pokedeal/features/collection/data/collection_pokemon_data_source_interface.dart';
import 'package:pokedeal/features/collection/domain/models/pokemon_serie.dart';
import 'package:pokedeal/features/collection/domain/models/pokemon_serie_brief.dart';
import 'package:pokedeal/features/collection/domain/models/pokemon_set.dart';

class CollectionPokemonRepository {
  final ICollectionPokemonDataSource collectionPokemonDataSource;
  List<PokemonSerieBrief> seriesBriefs = [];
  List<PokemonSerie> series = [];
  Map<String, PokemonSet> setsMap = {};

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
}
