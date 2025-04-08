import 'package:flutter_test/flutter_test.dart';
import 'package:pokedeal/features/collection/domain/models/pokemon_serie.dart';

void main() {
  test('PokemonSerie has a constructor', () {
    PokemonSerie serie = const PokemonSerie(
      name: 'name',
      id: 'id',
      logoUrl: 'logoUrl',
      sets: [],
    );

    expect(serie.name, 'name');
    expect(serie.id, 'id');
    expect(serie.logoUrl, 'logoUrl');
    expect(serie.sets, []);
  });

  test('PokemonSerie has a fromJson', () {
    final json = {
      'name': 'name',
      'id': 'id',
      'logo': 'logoUrl',
      'sets': [
        {
          'name': 'name',
          'id': 'id',
          'logo': 'logoUrl',
          'symbol': 'symbolUrl',
          'cardCount': {'total': 1, 'holo': 2, 'reverseHolo': 3, 'nonHolo': 4},
        },
        {
          'name': 'name2',
          'id': 'id2',
          'logo': 'logoUrl2',
          'symbol': 'symbolUrl2',
          'cardCount': {'total': 5, 'holo': 6, 'reverseHolo': 7, 'nonHolo': 8},
        },
      ],
    };

    final serie = PokemonSerie.fromJson(json);

    expect(serie.name, 'name');
    expect(serie.id, 'id');
    expect(serie.logoUrl, 'logoUrl');
    expect(serie.sets.length, 2);
  });
}
