import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pokedeal/core/di/injection_container.dart';
import 'package:pokedeal/features/authentication/domain/models/user_profile.dart';
import 'package:pokedeal/features/authentication/domain/repository/authentication_repository.dart';
import 'package:pokedeal/features/collection/data/collection_pokemon_data_source_interface.dart';
import 'package:pokedeal/features/collection/domain/models/card/base_pokemon_card.dart';
import 'package:pokedeal/features/collection/domain/models/card/card_variant.dart';
import 'package:pokedeal/features/collection/domain/models/card/pokemon_card_brief.dart';
import 'package:pokedeal/features/collection/domain/models/card/user_card_collection.dart';
import 'package:pokedeal/features/collection/domain/models/card_count.dart';
import 'package:pokedeal/features/collection/domain/models/enum/card_category.dart';
import 'package:pokedeal/features/collection/domain/models/enum/variant_value.dart';
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
  late AuthenticationRepository authenticationRepository;

  setUp(() {
    dataSource = MockICollectionPokemonDataSource();
    repository = CollectionPokemonRepository(
      collectionPokemonDataSource: dataSource,
    );
    authenticationRepository = MockAuthenticationRepository();
    getIt.registerSingleton<AuthenticationRepository>(authenticationRepository);

    when(authenticationRepository.userProfile).thenReturn(
      UserProfile(
        id: 'userId',
        email: 'mail',
        pseudo: 'pseudo',
        createdAt: DateTime.now(),
      ),
    );
  });

  tearDown(() {
    getIt.reset();
  });

  final mockSeriesBriefs = [
    PokemonSerieBrief(name: 'name1', id: 'id1'),
    PokemonSerieBrief(name: 'name2', id: 'id2'),
  ];

  final mockSeries = [
    PokemonSerie(id: "1", name: 'Serie 1', sets: []),
    PokemonSerie(id: "2", name: 'Serie 2', sets: []),
  ];

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

  final mockUserCardCollection = UserCardCollection(
    id: '1',
    userId: 'userId',
    quantity: 2,
    cardId: 'cardId',
    setId: 'setId',
    variant: VariantValue.holo,
  );

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

    test('getSeriesWithSets returns [] if no series are found', () async {
      when(dataSource.getSeriesBriefs()).thenAnswer((_) async => []);

      final result = await repository.getSeriesWithSets();

      expect(result, isA<List<PokemonSerie>>());
      expect(result.isEmpty, true);
    });
  });

  group('getSetWithCards', () {
    test('returns PokemonSetWithCards when set is found', () async {
      when(dataSource.getSet('set1')).thenAnswer((_) async => mockSetWithCards);

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

  group('getCard', () {
    final mockCard = BasePokemonCard(
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

  group('getUserCollection', () {
    test('returns a list of user card collections when successful', () async {
      when(
        dataSource.getUserCollection(
          userId: 'userId',
          cardId: 'cardId',
          setId: 'setId',
        ),
      ).thenAnswer((_) async => [mockUserCardCollection]);

      final result = await repository.getUserCollection(
        userId: 'userId',
        cardId: 'cardId',
        setId: 'setId',
      );

      expect(result, isA<List<UserCardCollection>>());
      expect(result.length, 1);
      expect(result[0], mockUserCardCollection);
      verify(
        dataSource.getUserCollection(
          userId: 'userId',
          cardId: 'cardId',
          setId: 'setId',
        ),
      ).called(1);
    });

    test(
      'returns an empty list when no user card collections are found',
      () async {
        when(
          dataSource.getUserCollection(
            userId: 'userId',
            cardId: 'cardId',
            setId: 'setId',
          ),
        ).thenAnswer((_) async => []);

        final result = await repository.getUserCollection(
          userId: 'userId',
          cardId: 'cardId',
          setId: 'setId',
        );

        expect(result, isA<List<UserCardCollection>>());
        expect(result.isEmpty, true);
        verify(
          dataSource.getUserCollection(
            userId: 'userId',
            cardId: 'cardId',
            setId: 'setId',
          ),
        ).called(1);
      },
    );

    test('returns cached user card collection when already in map', () async {
      repository.userCardsBySetIdMap.addEntries([
        MapEntry('setId', [mockUserCardCollection]),
      ]);

      final result = await repository.getUserCollection(
        userId: 'userId',
        setId: 'setId',
      );

      expect(result, [mockUserCardCollection]);

      verifyZeroInteractions(dataSource);
    });
  });

  group('addCardToUserCollection', () {
    test('adds a card to user collection when successful', () async {
      when(
        dataSource.addCardToUserCollection(
          id: 'cardId',
          quantity: 2,
          variant: VariantValue.holo,
          setId: 'setId',
        ),
      ).thenAnswer((_) async => mockUserCardCollection);

      final result = await repository.addCardToUserCollection(
        id: 'cardId',
        quantity: 2,
        variant: VariantValue.holo,
        setId: 'setId',
      );

      expect(result, isA<UserCardCollection>());
      expect(result, mockUserCardCollection);
      verify(
        dataSource.addCardToUserCollection(
          id: 'cardId',
          quantity: 2,
          variant: VariantValue.holo,
          setId: 'setId',
        ),
      ).called(1);
    });

    test(
      'removes existing card if already in the collection and adds the new one',
      () async {
        final newCard = UserCardCollection(
          id: '2',
          userId: 'userId',
          quantity: 1,
          cardId: 'cardId',
          setId: 'setId',
          variant: VariantValue.holo,
        );

        when(
          dataSource.addCardToUserCollection(
            id: 'cardId',
            quantity: 1,
            variant: VariantValue.reverse,
            setId: 'setId',
          ),
        ).thenAnswer((_) async => newCard);

        final result = await repository.addCardToUserCollection(
          id: 'cardId',
          quantity: 1,
          variant: VariantValue.reverse,
          setId: 'setId',
        );

        expect(result, isA<UserCardCollection>());
        expect(result, newCard);
        verify(
          dataSource.addCardToUserCollection(
            id: 'cardId',
            quantity: 1,
            variant: VariantValue.reverse,
            setId: 'setId',
          ),
        ).called(1);
      },
    );
  });

  group('getSetsFromUserCards', () {
    final mockUserCards = [
      UserCardCollection(
        id: '1',
        userId: 'userId',
        quantity: 1,
        cardId: 'card1',
        setId: 'set1',
        variant: VariantValue.normal,
      ),
      UserCardCollection(
        id: '2',
        userId: 'userId',
        quantity: 1,
        cardId: 'card2',
        setId: 'set2',
        variant: VariantValue.normal,
      ),
    ];

    final mockSet1 = PokemonSet(
      name: 'Set 1',
      id: 'set1',
      serieBrief: PokemonSerieBrief(id: 'serie1', name: 'Serie 1'),
      cardCount: CardCount(total: 100, official: 100),
      cards: [],
      releaseDate: DateTime(2021, 1, 1),
      legal: Legal(standard: true, expanded: true),
    );

    final mockSet2 = PokemonSet(
      name: 'Set 2',
      id: 'set2',
      serieBrief: PokemonSerieBrief(id: 'serie2', name: 'Serie 2'),
      cardCount: CardCount(total: 150, official: 150),
      cards: [],
      releaseDate: DateTime(2022, 1, 1),
      legal: Legal(standard: false, expanded: true),
    );

    test('returns list of PokemonSet when successful', () async {
      when(dataSource.getSet('set1')).thenAnswer((_) async => mockSet1);
      when(dataSource.getSet('set2')).thenAnswer((_) async => mockSet2);

      final result = await repository.getSetsFromUserCards(
        userCards: mockUserCards,
      );

      expect(result, isA<List<PokemonSet>>());
      expect(result.length, 2);
      expect(result, containsAll([mockSet1, mockSet2]));
      verify(dataSource.getSet('set1')).called(1);
      verify(dataSource.getSet('set2')).called(1);
    });

    test('returns cached sets if already present', () async {
      repository.setsMap['set1'] = mockSet1;
      repository.setsMap['set2'] = mockSet2;

      final result = await repository.getSetsFromUserCards(
        userCards: mockUserCards,
      );

      expect(result, containsAll([mockSet1, mockSet2]));
      verifyNever(dataSource.getSet('set1'));
      verifyNever(dataSource.getSet('set2'));
    });
  });

  group('getSeriesFromSets', () {
    final mockSets = [
      PokemonSet(
        name: 'Set 1',
        id: 'set1',
        serieBrief: PokemonSerieBrief(id: 'serie1', name: 'Serie 1'),
        cardCount: CardCount(total: 100, official: 100),
        cards: [],
        releaseDate: DateTime(2021, 1, 1),
        legal: Legal(standard: true, expanded: true),
      ),
      PokemonSet(
        name: 'Set 2',
        id: 'set2',
        serieBrief: PokemonSerieBrief(id: 'serie2', name: 'Serie 2'),
        cardCount: CardCount(total: 150, official: 150),
        cards: [],
        releaseDate: DateTime(2022, 1, 1),
        legal: Legal(standard: false, expanded: true),
      ),
    ];

    final serie1 = PokemonSerie(id: 'serie1', name: 'Serie 1', sets: []);
    final serie2 = PokemonSerie(id: 'serie2', name: 'Serie 2', sets: []);

    setUp(() {
      repository.series.addAll([serie1, serie2]);
    });

    tearDown(() {
      repository.series.clear();
    });

    test('returns list of PokemonSerie matching the sets', () async {
      final result = await repository.getSeriesFromSets(sets: mockSets);

      expect(result, isA<List<PokemonSerie>>());
      expect(result.length, 2);
      expect(result, containsAll([serie1, serie2]));
    });
  });

  group('getSeriesFromSets', () {
    final mockSets = [
      PokemonSet(
        name: 'Set 1',
        id: 'set1',
        serieBrief: PokemonSerieBrief(id: 'serie1', name: 'Serie 1'),
        cardCount: CardCount(total: 100, official: 100),
        cards: [],
        releaseDate: DateTime(2021, 1, 1),
        legal: Legal(standard: true, expanded: true),
      ),
      PokemonSet(
        name: 'Set 2',
        id: 'set2',
        serieBrief: PokemonSerieBrief(id: 'serie2', name: 'Serie 2'),
        cardCount: CardCount(total: 150, official: 150),
        cards: [],
        releaseDate: DateTime(2022, 1, 1),
        legal: Legal(standard: false, expanded: true),
      ),
    ];

    final serie1 = PokemonSerie(id: 'serie1', name: 'Serie 1', sets: []);
    final serie2 = PokemonSerie(id: 'serie2', name: 'Serie 2', sets: []);

    setUp(() {
      repository.series.addAll([serie1, serie2]);
    });

    tearDown(() {
      repository.series.clear();
    });

    test('returns list of PokemonSerie matching the sets', () async {
      final result = await repository.getSeriesFromSets(sets: mockSets);

      expect(result, isA<List<PokemonSerie>>());
      expect(result.length, 2);
      expect(result, containsAll([serie1, serie2]));
    });
  });
}
