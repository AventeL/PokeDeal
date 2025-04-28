import 'package:equatable/equatable.dart';
import 'package:pokedeal/features/collection/domain/models/card/card_variant.dart';
import 'package:pokedeal/features/collection/domain/models/card/energy_card.dart';
import 'package:pokedeal/features/collection/domain/models/card/pokemon_card.dart';
import 'package:pokedeal/features/collection/domain/models/card/pokemon_card_brief.dart';
import 'package:pokedeal/features/collection/domain/models/card/trainer_card.dart';
import 'package:pokedeal/features/collection/domain/models/enum/card_category.dart';
import 'package:pokedeal/features/collection/domain/models/pokemon_set_brief.dart';

class BasePokemonCard extends Equatable {
  final String id;
  final String localId;
  final String name;
  final String? image;
  final CardCategory category;
  final String? illustrator;
  final String? rarity;
  final PokemonSetBrief setBrief;
  final CardVariant variants;

  const BasePokemonCard({
    required this.id,
    required this.localId,
    required this.name,
    this.image,
    required this.category,
    this.illustrator,
    this.rarity,
    required this.setBrief,
    required this.variants,
  });

  factory BasePokemonCard.fromJson(Map<String, dynamic> json) {
    CardCategory category = CardCategoryExtension.fromString(json['category']);
    switch (category) {
      case CardCategory.pokemon:
        return PokemonCard.fromJson(json);
      case CardCategory.trainer:
        return TrainerCard.fromJson(json);
      case CardCategory.energy:
        return EnergyCard.fromJson(json);
    }
  }

  PokemonCardBrief toBrief() {
    return PokemonCardBrief(id: id, localId: localId, name: name, image: image);
  }

  @override
  List<Object?> get props => [
    id,
    localId,
    name,
    image,
    category,
    illustrator,
    rarity,
    setBrief,
    variants,
  ];
}
