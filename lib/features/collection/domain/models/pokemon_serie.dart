import 'package:equatable/equatable.dart';

class PokemonSerie extends Equatable {
  final String name;
  final String id;
  final String? logoUrl;

  const PokemonSerie({required this.name, required this.id, this.logoUrl});

  factory PokemonSerie.fromJson(Map<String, dynamic> json) {
    return PokemonSerie(
      name: json['name'],
      id: json['id'],
      logoUrl: json['logo'],
    );
  }

  @override
  List<Object?> get props => [name, id, logoUrl];
}
