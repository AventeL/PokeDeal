import 'package:equatable/equatable.dart';
import 'package:pokedeal/features/collection/domain/models/card/pokemon_card_brief.dart';
import 'package:pokedeal/features/collection/domain/models/card_count.dart';
import 'package:pokedeal/features/collection/domain/models/legal.dart';
import 'package:pokedeal/features/collection/domain/models/pokemon_serie_brief.dart';
import 'package:pokedeal/features/collection/domain/models/pokemon_set_brief.dart';

class PokemonSet extends Equatable {
  final List<PokemonCardBrief> cards;
  final DateTime? releaseDate;
  final Legal legal;
  final String name;
  final String id;
  final String? logoUrl;
  final String? symbolUrl;
  final CardCount cardCount;
  final PokemonSerieBrief serieBrief;

  const PokemonSet({
    required this.name,
    required this.id,
    this.logoUrl,
    this.symbolUrl,
    required this.cardCount,
    required this.cards,
    this.releaseDate,
    required this.legal,
    required this.serieBrief,
  });

  factory PokemonSet.fromJson(Map<String, dynamic> json) {
    return PokemonSet(
      name: json['name'],
      id: json['id'],
      logoUrl: json['logo'],
      symbolUrl: json['symbol'],
      cardCount: CardCount.fromJson(json['cardCount']),
      cards:
          (json['cards'] as List<dynamic>)
              .map((card) => PokemonCardBrief.fromJson(card))
              .toList(),
      releaseDate: DateTime.tryParse(json['releaseDate']),
      legal: Legal.fromJson(json['legal']),
      serieBrief: PokemonSerieBrief.fromJson(json['serie']),
    );
  }

  PokemonSetBrief toBrief() {
    return PokemonSetBrief(
      name: name,
      id: id,
      logoUrl: logoUrl,
      symbolUrl: symbolUrl,
      cardCount: cardCount,
    );
  }

  @override
  List<Object?> get props => [
    name,
    id,
    logoUrl,
    symbolUrl,
    cardCount,
    cards,
    releaseDate,
    legal,
  ];
}
