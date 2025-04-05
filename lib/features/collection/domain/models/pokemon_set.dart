import 'package:equatable/equatable.dart';
import 'package:pokedeal/features/collection/domain/models/card_count.dart';

class PokemonSet extends Equatable {
  final String name;
  final String id;
  final String? logoUrl;
  final String? symbolUrl;
  final CardCount cardCount;

  set sets(List<PokemonSet>? sets) => this.sets = sets;

  const PokemonSet({
    required this.name,
    required this.id,
    this.logoUrl,
    this.symbolUrl,
    required this.cardCount,
  });

  factory PokemonSet.fromJson(Map<String, dynamic> json) {
    return PokemonSet(
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
