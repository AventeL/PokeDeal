import 'package:equatable/equatable.dart';
import 'package:pokedeal/features/collection/domain/models/pokemon_serie_brief.dart';
import 'package:pokedeal/features/collection/domain/models/pokemon_set_brief.dart';

class PokemonSerie extends Equatable {
  final String name;
  final String id;
  final String? logoUrl;
  final List<PokemonSetBrief> sets;
  final PokemonSerieBrief serieBrief;

  const PokemonSerie({
    required this.name,
    required this.id,
    this.logoUrl,
    required this.sets,
    required this.serieBrief,
  });

  factory PokemonSerie.fromJson(Map<String, dynamic> json) {
    return PokemonSerie(
      name: json['name'],
      id: json['id'],
      logoUrl: json['logo'],
      serieBrief: PokemonSerieBrief.fromJson(json['serie']),
      sets:
          (json['sets'] as List<dynamic>?)!
              .map((set) => PokemonSetBrief.fromJson(set))
              .toList()
              .reversed
              .toList(),
    );
  }

  @override
  List<Object?> get props => [name, id, logoUrl, sets];
}
