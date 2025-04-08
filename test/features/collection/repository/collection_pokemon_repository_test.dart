import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pokedeal/features/collection/data/collection_pokemon_data_source_interface.dart';
import 'package:pokedeal/features/collection/domain/models/card/base_pokemon_card.dart';
import 'package:pokedeal/features/collection/domain/models/card/card_variant.dart';
import 'package:pokedeal/features/collection/domain/models/card/pokemon_card_brief.dart';
import 'package:pokedeal/features/collection/domain/models/card_count.dart';
import 'package:pokedeal/features/collection/domain/models/enum/card_category.dart';
import 'package:pokedeal/features/collection/domain/models/legal.dart';
import 'package:pokedeal/features/collection/domain/models/pokemon_serie.dart';
import 'package:pokedeal/features/collection/domain/models/pokemon_serie_brief.dart';
import 'package:pokedeal/features/collection/domain/models/pokemon_set.dart';
import 'package:pokedeal/features/collection/domain/models/pokemon_set_brief.dart';
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

  final mockSeriesBriefs = [
    PokemonSerieBrief(name: 'name1', id: 'id1'),
    PokemonSerieBrief(name: 'name2', id: 'id2'),
  ];

  final mockSeries = [
    PokemonSerie(id: "1", name: 'Serie 1', sets: []),
    PokemonSerie(id: "2", name: 'Serie 2', sets: []),
  ];

  group('getSeriesBriefs', () {
    test('getSeriesBriefs returns a list of PokemonSerieBriefs', () async {
      when(
        dataSource.getSeriesBriefs(),
      ).thenAnswer((_) async => mockSeriesBriefs);

      final result = await repository.getSeriesBriefs();

      expect(result, isA<List<PokemonSerieBrief>>());
      expect(result.length, 2);
      expect(result, mockSeriesBriefs.reversed.toList());
    });

    test(
      'getSeriesBriefs returns an empty list when no series are found',
      () async {
        when(dataSource.getSeriesBriefs()).thenAnswer((_) async => []);

        final result = await repository.getSeriesBriefs();

        expect(result, isA<List<PokemonSerieBrief>>());
        expect(result.isEmpty, true);
      },
    );
  });

  group('getSeriesWithSets', () {
    test(
      'getSeriesWithSets returns a list of PokemonSerie with sets',
      () async {
        when(
          dataSource.getSeriesBriefs(),
        ).thenAnswer((_) async => mockSeriesBriefs);
        when(dataSource.getSerie('1')).thenAnswer((_) async => mockSeries[0]);
        when(dataSource.getSerie('2')).thenAnswer((_) async => mockSeries[1]);

        final result = await repository.getSeriesWithSets();

        expect(result, isA<List<PokemonSerie>>());
        verify(dataSource.getSeriesBriefs()).called(1);
        verify(dataSource.getSerie('id1')).called(1);
        verify(dataSource.getSerie('id2')).called(1);
        verifyNever(dataSource.getSerie('3'));
        expect(result.length, 2);
      },
    );
  });

  group('getSeriesWithSets', () {
    test('getSeriesWithSets returns [] if no series are found', () async {
      when(dataSource.getSeriesBriefs()).thenAnswer((_) async => []);

      final result = await repository.getSeriesWithSets();

      expect(result, isA<List<PokemonSerie>>());
      expect(result.isEmpty, true);
    });
  });

  group('getSetWithCards', () {
    final mockSetWithCards = PokemonSet(
      name: 'Set 1',
      id: 'set1',
      serieBrief: PokemonSerieBrief(id: 'serie1', name: 'Serie 1'),
      cardCount: CardCount(total: 100, official: 100),
      cards: [
        PokemonCardBrief(
          id: '1',
          image: 'image1',
          localId: 'local1',
          name: 'Card 1',
        ),
        PokemonCardBrief(
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
          dataSource.getSet('set1'),
        ).thenAnswer((_) async => mockSetWithCards);

        final result = await repository.getSetWithCards(setId: 'set1');

        expect(result, isA<PokemonSet>());
        expect(result.id, 'set1');
        expect(result.cards.length, 2);
        verify(dataSource.getSet('set1')).called(1);
      });

      test(
        'returns cached PokemonSetWithCards when set is already cached',
        () async {
          repository.setsMap['set1'] = mockSetWithCards;

          final result = await repository.getSetWithCards(setId: 'set1');

          expect(result, isA<PokemonSet>());
          expect(result.id, 'set1');
          expect(result.cards.length, 2);
          verifyNever(dataSource.getSet('set1'));
        },
      );
    });
  });

  group('getCard', () {
    BasePokemonCard mockCard = BasePokemonCard(
      localId: '1',
      category: CardCategory.trainer,
      illustrator: 'Illustrator Name',
      id: 'cardId',
      name: 'Card Name',
      image: 'https://example.com/card.png',
      setBrief: PokemonSetBrief(
        id: 'setId',
        name: 'Set Name',
        symbolUrl: 'https://example.com/card.png',
        cardCount: CardCount(total: 100, official: 50),
      ),
      variants: CardVariant(
        firstEdition: true,
        holo: false,
        reverse: false,
        promo: false,
        normal: true,
      ),
    );

    test('returns PokemonCard when card is found', () async {
      when(dataSource.getCard(id: 'cardId')).thenAnswer((_) async => mockCard);

      final result = await repository.getCard(id: 'cardId');

      expect(result, isA<BasePokemonCard>());
      expect(result.id, 'cardId');
      verify(dataSource.getCard(id: 'cardId')).called(1);
    });

    test('returns cached PokemonCard when card is already cached', () async {
      repository.cardsMap['cardId'] = mockCard;

      final result = await repository.getCard(id: 'cardId');

      expect(result, isA<BasePokemonCard>());
      expect(result.id, 'cardId');
      verifyNever(dataSource.getCard(id: 'cardId'));
    });
  });
}
