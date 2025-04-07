import 'package:equatable/equatable.dart';

class PokemonCardBrief extends Equatable {
  final String id;
  final String? image;
  final String localId;
  final String name;

  const PokemonCardBrief({
    required this.id,
    this.image,
    required this.localId,
    required this.name,
  });

  factory PokemonCardBrief.fromJson(Map<String, dynamic> json) {
    return PokemonCardBrief(
      id: json['id'],
      image: json['image'],
      localId: json['localId'],
      name: json['name'],
    );
  }

  @override
  List<Object?> get props => [id, image, localId, name];
}
