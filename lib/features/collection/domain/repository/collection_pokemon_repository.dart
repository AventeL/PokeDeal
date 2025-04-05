import 'package:pokedeal/features/collection/data/collection_pokemon_data_source_interface.dart';
import 'package:pokedeal/features/collection/domain/models/pokemon_serie.dart';

class CollectionPokemonRepository {
  final ICollectionPokemonDataSource collectionPokemonDataSource;
  List<PokemonSerie> series = [];

  CollectionPokemonRepository({required this.collectionPokemonDataSource});

  Future<List<PokemonSerie>> getSeries() async {
    List<PokemonSerie> series = await collectionPokemonDataSource.getSeries();
    series = series.reversed.toList();
    this.series = series;
    return series;
  }

  Future<List<PokemonSerie>> getSeriesWithSets() async {
    List<PokemonSerie> sets = await collectionPokemonDataSource.getSeries();
    List<PokemonSerie> newList = [];
    for (var serie in sets) {
      newList.add(await collectionPokemonDataSource.getSerieWithSets(serie.id));
    }
    newList = newList.reversed.toList();
    series = newList;
    return newList;
  }
}
