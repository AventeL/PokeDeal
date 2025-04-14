import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pokedeal/core/di/injection_container.dart';
import 'package:pokedeal/features/collection/domain/models/card/base_pokemon_card.dart';
import 'package:pokedeal/features/collection/domain/models/card/user_card_collection.dart';
import 'package:pokedeal/features/collection/domain/models/enum/variant_value.dart';
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

  @override
  Future<List<UserCardCollection>> getUserCollection({
    required String userId,
    String? cardId,
    String? setId,
  }) async {
    List<UserCardCollection> cards = [];

    var query = supabaseClient
        .from('user_cards')
        .select()
        .eq('user_id', userId);

    if (cardId != null) {
      query = query.eq('card_id', cardId);
    }

    if (setId != null) {
      query = query.eq('set_id', setId);
    }

    final response = await query;

    for (var item in response) {
      cards.add(UserCardCollection.fromJson(item));
    }

    return cards;
  }

  @override
  Future<UserCardCollection> addCardToUserCollection({
    required String id,
    required int quantity,
    required VariantValue variant,
    required String setId,
  }) async {
    final response =
        await supabaseClient
            .rpc(
              'increment_or_insert_card',
              params: {
                'p_card_id': id,
                'p_quantity': quantity,
                'p_variant': variant.getFullName,
                'p_set_id': setId,
              },
            )
            .single();

    return UserCardCollection.fromJson(response);
  }
}
