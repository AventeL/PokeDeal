import 'package:equatable/equatable.dart';
import 'package:pokedeal/features/collection/domain/models/card_count.dart';

class PokemonSetBrief extends Equatable {
  final String name;
  final String id;
  final String? logoUrl;
  final String? symbolUrl;
  final CardCount cardCount;

  set sets(List<PokemonSetBrief>? sets) => this.sets = sets;

  const PokemonSetBrief({
    required this.name,
    required this.id,
    this.logoUrl,
    this.symbolUrl,
    required this.cardCount,
  });

  factory PokemonSetBrief.fromJson(Map<String, dynamic> json) {
    return PokemonSetBrief(
      name: json['name'],
      id: json['id'],
      logoUrl: json['logo'],
      symbolUrl: json['symbol'],
      cardCount: CardCount.fromJson(json['cardCount']),
    );
  }

  @override
  List<Object?> get props => [name, id, logoUrl, symbolUrl, cardCount];
}
