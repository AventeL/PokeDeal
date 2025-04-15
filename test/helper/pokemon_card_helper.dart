import 'package:flutter_test/flutter_test.dart';
import 'package:pokedeal/core/helper/pokemon_card_helper.dart';
import 'package:pokedeal/features/collection/domain/models/card/base_pokemon_card.dart';
import 'package:pokedeal/features/collection/domain/models/card/card_variant.dart';
import 'package:pokedeal/features/collection/domain/models/card_count.dart';
import 'package:pokedeal/features/collection/domain/models/enum/card_category.dart';
import 'package:pokedeal/features/collection/domain/models/enum/variant_value.dart';
import 'package:pokedeal/features/collection/domain/models/pokemon_set_brief.dart';

void main() {
  test('should return variants based on card properties', () {
    final cardVariant = CardVariant(
      firstEdition: true,
      holo: true,
      reverse: false,
      promo: true,
      normal: true,
    );
    final card = BasePokemonCard(
      id: '1',
      localId: '1',
      name: 'Pikachu',
      category: CardCategory.pokemon,
      setBrief: PokemonSetBrief(
        id: 'set1',
        name: 'Set 1',
        cardCount: CardCount(total: 100, official: 100),
      ),
      variants: cardVariant,
    );

    final variants = PokemonCardHelper.getVariants(card);

    expect(variants, [
      VariantValue.normal,
      VariantValue.firstEdition,
      VariantValue.holo,
      VariantValue.promo,
    ]);
  });
}
