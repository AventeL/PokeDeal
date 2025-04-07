import 'package:pokedeal/features/collection/domain/models/card/base_pokemon_card.dart';
import 'package:pokedeal/features/collection/domain/models/card/card_variant.dart';
import 'package:pokedeal/features/collection/domain/models/enum/card_category.dart';
import 'package:pokedeal/features/collection/domain/models/pokemon_set_brief.dart';

class EnergyCard extends BasePokemonCard {
  final String energyType;
  final String effect;

  const EnergyCard({
    required super.id,
    required super.localId,
    required super.name,
    required super.category,
    required super.setBrief,
    required super.variants,
    super.image,
    super.illustrator,
    super.rarity,
    required this.energyType,
    required this.effect,
  });

  factory EnergyCard.fromJson(Map<String, dynamic> json) {
    return EnergyCard(
      id: json['id'],
      localId: json['localId'].toString(),
      name: json['name'],
      image: json['image'],
      category: CardCategory.energy,
      illustrator: json['illustrator'],
      rarity: json['rarity'],
      setBrief: PokemonSetBrief.fromJson(json['set']),
      variants: CardVariant.fromJson(json['variants']),
      energyType: json['energyType'],
      effect: json['effect'],
    );
  }
}
