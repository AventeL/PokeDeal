import 'package:flutter_test/flutter_test.dart';
import 'package:pokedeal/features/collection/domain/models/card/pokemon_card_brief.dart';

void main() {
  test('PokemonCardBrief has a constructor', () {
    const pokemonCardBrief = PokemonCardBrief(
      id: '123',
      image: 'https://example.com/image.png',
      localId: 'local123',
      name: 'Pikachu',
    );

    expect(pokemonCardBrief.id, '123');
    expect(pokemonCardBrief.image, 'https://example.com/image.png');
    expect(pokemonCardBrief.localId, 'local123');
    expect(pokemonCardBrief.name, 'Pikachu');
  });

  test('PokemonCardBrief has a fromJson', () {
    final json = {'id': '123', 'localId': 'local123', 'name': 'Pikachu'};

    final pokemonCardBrief = PokemonCardBrief.fromJson(json);

    expect(pokemonCardBrief.id, '123');
    expect(pokemonCardBrief.image, null);
    expect(pokemonCardBrief.localId, 'local123');
    expect(pokemonCardBrief.name, 'Pikachu');
  });
}
