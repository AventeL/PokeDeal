import 'package:pokedeal/features/collection/domain/models/pokemon_serie.dart';

abstract class ICollectionPokemonDataSource {
  Future<List<PokemonSerie>> getSeries();
}
