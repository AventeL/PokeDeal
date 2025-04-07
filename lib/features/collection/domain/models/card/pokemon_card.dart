import 'package:equatable/equatable.dart';
import 'package:pokedeal/features/collection/domain/models/card/base_pokemon_card.dart';
import 'package:pokedeal/features/collection/domain/models/card/card_variant.dart';
import 'package:pokedeal/features/collection/domain/models/enum/card_category.dart';
import 'package:pokedeal/features/collection/domain/models/pokemon_set_brief.dart';

class PokemonCard extends BasePokemonCard {
  final List<int>? dexId;
  final int? hp;
  final List<String>? types;
  final String? evolveFrom;
  final String? description;
  final String? level;
  final String? stage;
  final String? suffix;
  final PokemonItem? item;

  const PokemonCard({
    required super.id,
    required super.localId,
    required super.name,
    super.image,
    required super.category,
    super.illustrator,
    super.rarity,
    required super.setBrief,
    required super.variants,
    this.dexId,
    this.hp,
    this.types,
    this.evolveFrom,
    this.description,
    this.level,
    this.stage,
    this.suffix,
    this.item,
  });

  factory PokemonCard.fromJson(Map<String, dynamic> json) {
    return PokemonCard(
      id: json['id'],
      localId: json['localId'].toString(),
      name: json['name'],
      image: json['image'],
      category: CardCategory.pokemon,
      illustrator: json['illustrator'],
      rarity: json['rarity'],
      setBrief: PokemonSetBrief.fromJson(json['set']),
      variants: CardVariant.fromJson(json['variants']),
      dexId: (json['dexId'] as List<dynamic>?)?.map((e) => e as int).toList(),
      hp: json['hp'] as int?,
      types:
          (json['types'] as List<dynamic>?)?.map((e) => e as String).toList(),
      evolveFrom: json['evolveFrom'],
      description: json['description'],
      level: json['level'],
      stage: json['stage'],
      suffix: json['suffix'],
      item:
          json['item'] != null
              ? PokemonItem.fromJson(json['item'] as Map<String, dynamic>)
              : null,
    );
  }
}

class PokemonItem extends Equatable {
  final String name;
  final String effect;

  const PokemonItem({required this.name, required this.effect});

  factory PokemonItem.fromJson(Map<String, dynamic> json) {
    return PokemonItem(name: json['name'], effect: json['effect']);
  }

  @override
  List<Object?> get props => [name, effect];
}
