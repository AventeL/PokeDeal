import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pokedeal/features/collection/data/collection_pokemon_data_source_interface.dart';
import 'package:pokedeal/features/collection/domain/models/card_count.dart';
import 'package:pokedeal/features/collection/domain/models/legal.dart';
import 'package:pokedeal/features/collection/domain/models/pokemon_card.dart';
import 'package:pokedeal/features/collection/domain/models/pokemon_serie.dart';
import 'package:pokedeal/features/collection/domain/models/pokemon_set.dart';
import 'package:pokedeal/features/collection/domain/models/pokemon_set_with_cards.dart';
import 'package:pokedeal/features/collection/domain/repository/collection_pokemon_repository.dart';

import '../../../mocks/generated_mocks.mocks.dart';

void main() {
  late ICollectionPokemonDataSource dataSource;
  late CollectionPokemonRepository repository;

  setUp(() {
    dataSource = MockICollectionPokemonDataSource();
    repository = CollectionPokemonRepository(
      collectionPokemonDataSource: dataSource,
    );
  });

  final mockSeries = [
    PokemonSerie(
      id: '1',
      name: 'Serie 1',
      sets: [
        PokemonSet(
          name: 'set1',
          id: 'idSet1',
          cardCount: CardCount(total: 100, official: 100),
        ),
      ],
    ),
    PokemonSerie(
      id: '2',
      name: 'Serie 2',
      sets: [
        PokemonSet(
          name: 'set2',
          id: 'idSet2',
          cardCount: CardCount(total: 200, official: 200),
        ),
      ],
    ),
  ];

  group('getSeries', () {
    test('getSeries returns a list of PokemonSerie', () async {
      when(dataSource.getSeries()).thenAnswer((_) async => mockSeries);

      final result = await repository.getSeries();

      expect(result, isA<List<PokemonSerie>>());
      expect(result.length, 2);
      expect(result, mockSeries.reversed.toList());
    });

    test('getSeries returns an empty list when no series are found', () async {
      when(dataSource.getSeries()).thenAnswer((_) async => []);

      final result = await repository.getSeries();

      expect(result, isA<List<PokemonSerie>>());
      expect(result.isEmpty, true);
    });
  });

  group('getSeriesWithSets', () {
    test(
      'getSeriesWithSets returns a list of PokemonSerie with sets',
      () async {
        when(dataSource.getSeries()).thenAnswer((_) async => mockSeries);
        when(
          dataSource.getSerieWithSets('1'),
        ).thenAnswer((_) async => mockSeries[0]);
        when(
          dataSource.getSerieWithSets('2'),
        ).thenAnswer((_) async => mockSeries[1]);

        final result = await repository.getSeriesWithSets();

        expect(result, isA<List<PokemonSerie>>());
        verify(dataSource.getSeries()).called(1);
        verify(dataSource.getSerieWithSets('1')).called(1);
        verify(dataSource.getSerieWithSets('2')).called(1);
        verifyNever(dataSource.getSerieWithSets('3'));
        expect(result.length, 2);
        expect(result, mockSeries.reversed.toList());
      },
    );
  });

  group('getSeriesWithSets', () {
    test('getSeriesWithSets returns [] if no series are found', () async {
      when(dataSource.getSeries()).thenAnswer((_) async => []);

      final result = await repository.getSeriesWithSets();

      expect(result, isA<List<PokemonSerie>>());
      expect(result.isEmpty, true);
    });
  });

  group('getSetWithCards', () {
    final mockSetWithCards = PokemonSetWithCards(
      name: 'Set 1',
      id: 'set1',
      cardCount: CardCount(total: 100, official: 100),
      cards: [
        PokemonCard(
          id: '1',
          image: 'image1',
          localId: 'local1',
          name: 'Card 1',
        ),
        PokemonCard(
          id: '2',
          image: 'image2',
          localId: 'local2',
          name: 'Card 2',
        ),
      ],
      releaseDate: DateTime(2021, 1, 1),
      legal: Legal(standard: true, expanded: true),
    );

    group('getSetWithCards', () {
      test('returns PokemonSetWithCards when set is found', () async {
        when(
          dataSource.getSetWithCards('set1'),
        ).thenAnswer((_) async => mockSetWithCards);

        final result = await repository.getSetWithCards(setId: 'set1');

        expect(result, isA<PokemonSetWithCards>());
        expect(result.id, 'set1');
        expect(result.cards.length, 2);
        verify(dataSource.getSetWithCards('set1')).called(1);
      });

      test(
        'returns cached PokemonSetWithCards when set is already cached',
        () async {
          repository.setsDetails['set1'] = mockSetWithCards;

          final result = await repository.getSetWithCards(setId: 'set1');

          expect(result, isA<PokemonSetWithCards>());
          expect(result.id, 'set1');
          expect(result.cards.length, 2);
          verifyNever(dataSource.getSetWithCards('set1'));
        },
      );
    });
  });
}
