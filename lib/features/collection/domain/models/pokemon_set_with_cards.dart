import 'package:pokedeal/features/collection/domain/models/card_count.dart';
import 'package:pokedeal/features/collection/domain/models/legal.dart';
import 'package:pokedeal/features/collection/domain/models/pokemon_card.dart';
import 'package:pokedeal/features/collection/domain/models/pokemon_set.dart';

class PokemonSetWithCards extends PokemonSet {
  final List<PokemonCard> cards;
  final DateTime? releaseDate;
  final Legal legal;

  const PokemonSetWithCards({
    required super.name,
    required super.id,
    super.logoUrl,
    super.symbolUrl,
    required super.cardCount,
    required this.cards,
    this.releaseDate,
    required this.legal,
  });

  factory PokemonSetWithCards.fromJson(Map<String, dynamic> json) {
    return PokemonSetWithCards(
      name: json['name'],
      id: json['id'],
      logoUrl: json['logo'],
      symbolUrl: json['symbol'],
      cardCount: CardCount.fromJson(json['cardCount']),
      cards:
          (json['cards'] as List<dynamic>)
              .map((card) => PokemonCard.fromJson(card))
              .toList(),
      releaseDate: DateTime.tryParse(json['releaseDate']),
      legal: Legal.fromJson(json['legal']),
    );
  }
}
