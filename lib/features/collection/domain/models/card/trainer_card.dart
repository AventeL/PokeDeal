import 'package:pokedeal/features/collection/domain/models/card/base_pokemon_card.dart';
import 'package:pokedeal/features/collection/domain/models/card/card_variant.dart';
import 'package:pokedeal/features/collection/domain/models/enum/card_category.dart';
import 'package:pokedeal/features/collection/domain/models/pokemon_set_brief.dart';

class TrainerCard extends BasePokemonCard {
  final String effect;
  final String? trainerType;

  const TrainerCard({
    required super.id,
    required super.localId,
    required super.name,
    required super.category,
    required super.setBrief,
    required super.variants,
    super.image,
    super.illustrator,
    super.rarity,
    required this.effect,
    this.trainerType,
  });

  factory TrainerCard.fromJson(Map<String, dynamic> json) {
    return TrainerCard(
      id: json['id'],
      localId: json['localId'].toString(),
      name: json['name'],
      image: json['image'],
      category: CardCategory.trainer,
      illustrator: json['illustrator'],
      rarity: json['rarity'],
      setBrief: PokemonSetBrief.fromJson(json['set']),
      variants: CardVariant.fromJson(json['variants']),
      effect: json['effect'],
      trainerType: json['trainerType'],
    );
  }
}
