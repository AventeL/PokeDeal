import 'package:pokedeal/features/collection/domain/models/pokemon_serie.dart';
import 'package:pokedeal/features/collection/domain/models/pokemon_set_with_cards.dart';

abstract class ICollectionPokemonDataSource {
  Future<List<PokemonSerie>> getSeries();

  Future<PokemonSerie> getSerieWithSets(String serieId);

  Future<PokemonSetWithCards> getSetWithCards(String setId);
}
