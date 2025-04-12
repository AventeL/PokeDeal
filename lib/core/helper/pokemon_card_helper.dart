import 'package:pokedeal/features/collection/domain/models/card/base_pokemon_card.dart';
import 'package:pokedeal/features/collection/domain/models/enum/variant_value.dart';

class PokemonCardHelper {
  static List<VariantValue> getVariants(BasePokemonCard card) {
    List<VariantValue> variants = [];
    variants.add(VariantValue.normal);
    if (card.variants.firstEdition) variants.add(VariantValue.firstEdition);
    if (card.variants.holo) variants.add(VariantValue.holo);
    if (card.variants.reverse) variants.add(VariantValue.reverse);
    if (card.variants.promo) variants.add(VariantValue.promo);

    return variants;
  }
}
