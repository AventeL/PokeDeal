import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pokedeal/features/collection/domain/models/pokemon_serie.dart';

import 'collection_pokemon_data_source_interface.dart';

class CollectionPokemonDataSource implements ICollectionPokemonDataSource {
  @override
  Future<List<PokemonSerie>> getSeries() async {
    try {
      String url = "https://api.tcgdex.net/v2/fr/series";
      List<PokemonSerie> series = [];

      http.Response response = await http.get(Uri.parse(url));

      for (var item in jsonDecode(response.body)) {
        series.add(PokemonSerie.fromJson(item));
      }

      return series;
    } catch (e) {
      throw Exception("Impossible de récupérer les séries");
    }
  }

  @override
  Future<PokemonSerie> getSerieWithSets(String serieId) async {
    try {
      String url = "https://api.tcgdex.net/v2/fr/series/$serieId";
      http.Response response = await http.get(Uri.parse(url));
      PokemonSerie serie = PokemonSerie.fromJson(jsonDecode(response.body));

      return serie;
    } catch (e) {
      throw Exception("Impossible de récupérer la série");
    }
  }
}
