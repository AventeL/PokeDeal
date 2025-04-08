import 'package:flutter_test/flutter_test.dart';
import 'package:pokedeal/features/collection/domain/models/pokemon_serie_brief.dart';

void main() {
  test('PokemonSerieBrief has a constructor', () {
    PokemonSerieBrief serie = PokemonSerieBrief(id: '123', name: 'Test Serie');
    expect(serie.id, '123');
    expect(serie.name, 'Test Serie');
  });

  test('PokemonSerieBrief has a fromJson', () {
    PokemonSerieBrief serie = PokemonSerieBrief.fromJson({
      'id': '456',
      'name': 'Another Serie',
    });
    expect(serie.id, '456');
    expect(serie.name, 'Another Serie');
  });
}
