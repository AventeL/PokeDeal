import 'package:equatable/equatable.dart';
import 'package:pokedeal/features/collection/domain/models/pokemon_set.dart';

class PokemonSerie extends Equatable {
  final String name;
  final String id;
  final String? logoUrl;
  final List<PokemonSet>? sets;

  const PokemonSerie({
    required this.name,
    required this.id,
    this.logoUrl,
    this.sets,
  });

  factory PokemonSerie.fromJson(Map<String, dynamic> json) {
    return PokemonSerie(
      name: json['name'],
      id: json['id'],
      logoUrl: json['logo'],
      sets:
          json['sets'] != null
              ? (json['sets'] as List<dynamic>?)
                  ?.map((set) => PokemonSet.fromJson(set))
                  .toList()
              : null,
    );
  }

  @override
  List<Object?> get props => [name, id, logoUrl, sets];
}
