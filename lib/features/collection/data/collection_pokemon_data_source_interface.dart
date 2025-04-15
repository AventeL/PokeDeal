import 'package:pokedeal/features/collection/domain/models/card/base_pokemon_card.dart';
import 'package:pokedeal/features/collection/domain/models/card/user_card_collection.dart';
import 'package:pokedeal/features/collection/domain/models/enum/variant_value.dart';
import 'package:pokedeal/features/collection/domain/models/pokemon_serie.dart';
import 'package:pokedeal/features/collection/domain/models/pokemon_serie_brief.dart';
import 'package:pokedeal/features/collection/domain/models/pokemon_set.dart';

abstract class ICollectionPokemonDataSource {
  Future<List<PokemonSerieBrief>> getSeriesBriefs();

  Future<PokemonSerie> getSerie(String serieId);

  Future<PokemonSet> getSet(String setId);

  Future<BasePokemonCard> getCard({required String id});

  Future<List<UserCardCollection>> getUserCollection({
    required String userId,
    String? cardId,
    String? setId,
  });

  Future<UserCardCollection> addCardToUserCollection({
    required String id,
    required int quantity,
    required VariantValue variant,
    required String setId,
  });
}
