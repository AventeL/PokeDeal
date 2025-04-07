import 'package:equatable/equatable.dart';

class PokemonSerieBrief extends Equatable {
  final String id;
  final String name;

  const PokemonSerieBrief({required this.name, required this.id});

  factory PokemonSerieBrief.fromJson(Map<String, dynamic> json) {
    return PokemonSerieBrief(name: json['name'], id: json['id']);
  }

  @override
  List<Object?> get props => [name, id];
}
