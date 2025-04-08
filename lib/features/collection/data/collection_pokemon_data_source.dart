import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pokedeal/features/collection/domain/models/card/base_pokemon_card.dart';
import 'package:pokedeal/features/collection/domain/models/pokemon_serie.dart';
import 'package:pokedeal/features/collection/domain/models/pokemon_serie_brief.dart';
import 'package:pokedeal/features/collection/domain/models/pokemon_set.dart';

import 'collection_pokemon_data_source_interface.dart';

class CollectionPokemonDataSource implements ICollectionPokemonDataSource {
  @override
  Future<List<PokemonSerieBrief>> getSeriesBriefs() async {
    try {
      String url = "https://api.tcgdex.net/v2/fr/series";
      List<PokemonSerieBrief> series = [];

      http.Response response = await http.get(Uri.parse(url));

      for (var item in jsonDecode(response.body)) {
        series.add(PokemonSerieBrief.fromJson(item));
      }

      return series;
    } catch (e) {
      throw Exception("Impossible de récupérer les séries");
    }
  }

  @override
  Future<PokemonSerie> getSerie(String serieId) async {
    try {
      String url = "https://api.tcgdex.net/v2/fr/series/$serieId";
      http.Response response = await http.get(Uri.parse(url));
      PokemonSerie serie = PokemonSerie.fromJson(jsonDecode(response.body));
      return serie;
    } catch (e) {
      throw Exception("Impossible de récupérer la série");
    }
  }

  @override
  Future<PokemonSet> getSet(String setId) async {
    String url = "https://api.tcgdex.net/v2/fr/sets/$setId";
    http.Response response = await http.get(Uri.parse(url));
    PokemonSet set = PokemonSet.fromJson(jsonDecode(response.body));

    return set;
  }

  @override
  Future<BasePokemonCard> getCard({required String id}) async {
    String url = "https://api.tcgdex.net/v2/fr/cards/$id";
    http.Response response = await http.get(Uri.parse(url));
    BasePokemonCard card = BasePokemonCard.fromJson(jsonDecode(response.body));

    return card;
  }
}
