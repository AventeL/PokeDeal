import 'package:equatable/equatable.dart';

class PokemonCard extends Equatable {
  final String id;
  final String? image;
  final String localId;
  final String name;

  const PokemonCard({
    required this.id,
    required this.image,
    required this.localId,
    required this.name,
  });

  factory PokemonCard.fromJson(Map<String, dynamic> json) {
    return PokemonCard(
      id: json['id'],
      image: json['image'],
      localId: json['localId'],
      name: json['name'],
    );
  }

  @override
  List<Object?> get props => [id, image, localId, name];
}
