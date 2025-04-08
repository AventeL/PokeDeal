import 'package:flutter_test/flutter_test.dart';
import 'package:pokedeal/features/collection/domain/models/card_count.dart';
import 'package:pokedeal/features/collection/domain/models/pokemon_set_brief.dart';

void main() {
  test('PokemonSetBrief has a constructor', () {
    const set = PokemonSetBrief(
      name: 'name',
      id: 'id',
      logoUrl: 'logoUrl',
      symbolUrl: 'symbolUrl',
      cardCount: CardCount(total: 1, official: 200),
    );

    expect(set.name, 'name');
    expect(set.id, 'id');
    expect(set.logoUrl, 'logoUrl');
    expect(set.symbolUrl, 'symbolUrl');
    expect(set.cardCount.total, 1);
    expect(set.cardCount.official, 200);
  });

  test('PokemonSetBrief has a fromJson', () {
    final json = {
      'name': 'name',
      'id': 'id',
      'logo': 'logoUrl',
      'symbol': 'symbolUrl',
      'cardCount': {'total': 100, 'official': 10},
    };

    final set = PokemonSetBrief.fromJson(json);

    expect(set.name, 'name');
    expect(set.id, 'id');
    expect(set.logoUrl, 'logoUrl');
    expect(set.symbolUrl, 'symbolUrl');
    expect(set.cardCount.total, 100);
    expect(set.cardCount.official, 10);
  });
}
