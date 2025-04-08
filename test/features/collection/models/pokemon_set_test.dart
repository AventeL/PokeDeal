import 'package:flutter_test/flutter_test.dart';
import 'package:pokedeal/features/collection/domain/models/card_count.dart';
import 'package:pokedeal/features/collection/domain/models/legal.dart';
import 'package:pokedeal/features/collection/domain/models/pokemon_serie_brief.dart';
import 'package:pokedeal/features/collection/domain/models/pokemon_set.dart';

void main() {
  test('PokemonSet has a constructor', () {
    final set = PokemonSet(
      name: 'name',
      id: 'id',
      logoUrl: 'logoUrl',
      symbolUrl: 'symbolUrl',
      cardCount: CardCount(total: 1, official: 200),
      cards: [],
      releaseDate: DateTime(2023, 10, 1),
      legal: Legal(expanded: true, standard: false),
      serieBrief: PokemonSerieBrief(name: 'name', id: 'id'),
    );

    expect(set.name, 'name');
    expect(set.id, 'id');
    expect(set.logoUrl, 'logoUrl');
    expect(set.symbolUrl, 'symbolUrl');
    expect(set.cardCount.total, 1);
    expect(set.cardCount.official, 200);
    expect(set.cards, []);
    expect(set.releaseDate, DateTime(2023, 10, 1));
    expect(set.legal.expanded, true);
    expect(set.legal.standard, false);
    expect(set.serieBrief.name, 'name');
    expect(set.serieBrief.id, 'id');
  });

  test('PokemonSet has a fromJson', () {
    final json = {
      'name': 'name',
      'id': 'id',
      'logo': 'logoUrl',
      'symbol': 'symbolUrl',
      'cardCount': {'total': 100, 'official': 10},
      'cards': [],
      'releaseDate': '2023-10-01',
      'legal': {'expanded': true, 'standard': false},
      'serie': {'name': 'name', 'id': 'id'},
    };

    final set = PokemonSet.fromJson(json);

    expect(set.name, 'name');
    expect(set.id, 'id');
    expect(set.logoUrl, 'logoUrl');
    expect(set.symbolUrl, 'symbolUrl');
    expect(set.cardCount.total, 100);
    expect(set.cardCount.official, 10);
    expect(set.cards, []);
    expect(set.releaseDate, DateTime(2023, 10, 1));
    expect(set.legal.expanded, true);
    expect(set.legal.standard, false);
    expect(set.serieBrief.name, 'name');
    expect(set.serieBrief.id, 'id');
  });
}
