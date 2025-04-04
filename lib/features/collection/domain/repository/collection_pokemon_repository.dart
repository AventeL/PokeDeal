import 'package:pokedeal/features/collection/data/collection_pokemon_data_source_interface.dart';
import 'package:pokedeal/features/collection/domain/models/pokemon_serie.dart';

class CollectionPokemonRepository {
  final ICollectionPokemonDataSource collectionPokemonDataSource;

  CollectionPokemonRepository({required this.collectionPokemonDataSource});

  Future<List<PokemonSerie>> getSeries() async {
    List<PokemonSerie> series = await collectionPokemonDataSource.getSeries();
    series = series.reversed.toList();
    return series;
  }
}
