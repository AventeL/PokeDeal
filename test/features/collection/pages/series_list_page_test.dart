import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pokedeal/core/di/injection_container.dart';
import 'package:pokedeal/features/collection/domain/models/card_count.dart';
import 'package:pokedeal/features/collection/domain/models/pokemon_serie.dart';
import 'package:pokedeal/features/collection/domain/models/pokemon_set_brief.dart';
import 'package:pokedeal/features/collection/domain/repository/collection_pokemon_repository.dart';
import 'package:pokedeal/features/collection/presentation/bloc/serie_bloc/collection_pokemon_serie_bloc.dart';
import 'package:pokedeal/features/collection/presentation/pages/series_list_page.dart';
import 'package:pokedeal/features/collection/presentation/widgets/pokemon_serie_card.dart';
import 'package:pokedeal/features/collection/presentation/widgets/pokemon_set_card.dart';

import '../../../mocks/generated_mocks.mocks.dart';

void main() {
  final mockRepository = MockCollectionPokemonRepository();

  List<PokemonSerie> series = [
    PokemonSerie(
      id: "1",
      name: 'Serie 1',
      sets: [
        PokemonSetBrief(
          name: "set1",
          id: "set1",
          cardCount: CardCount(total: 100, official: 100),
        ),
      ],
    ),
    PokemonSerie(id: "2", name: 'Serie 2', sets: []),
    PokemonSerie(id: "3", name: 'Serie 3', sets: []),
  ];

  setUp(() {
    getIt.registerLazySingleton<CollectionPokemonRepository>(
      () => mockRepository,
    );
  });

  tearDown(() {
    getIt.reset();
  });

  testWidgets('SeriesListPage has a Title and a ListView', (
    WidgetTester tester,
  ) async {
    when(mockRepository.series).thenAnswer((_) => series);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BlocProvider(
            create:
                (context) => CollectionPokemonSerieBloc(
                  collectionPokemonRepository:
                      MockCollectionPokemonRepository(),
                )..emit(CollectionPokemonSeriesGet(series: series)),
            child: SeriesListPage(),
          ),
        ),
      ),
    );

    await tester.pump();

    expect(find.text('Ma Collection'), findsOneWidget);
    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(PokemonSerieCard), findsNWidgets(3));
    expect(find.text('Serie 1'), findsOneWidget);

    await tester.tap(find.text('Serie 1'));
    await tester.pumpAndSettle();

    expect(find.byType(PokemonSetCardWidget), findsOneWidget);
    expect(find.text('set1'), findsOneWidget);
  });

  testWidgets(
    'SeriesListPage shows CircularProgressIndicator when state is CollectionPokemonLoading',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlocProvider(
              create:
                  (context) => CollectionPokemonSerieBloc(
                    collectionPokemonRepository:
                        MockCollectionPokemonRepository(),
                  )..emit(CollectionPokemonSerieLoading()),
              child: SeriesListPage(),
            ),
          ),
        ),
      );

      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    },
  );

  testWidgets(
    'SeriesListPage shows an error when state is CollectionPokemonSerieError',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlocProvider(
              create:
                  (context) => CollectionPokemonSerieBloc(
                    collectionPokemonRepository:
                        MockCollectionPokemonRepository(),
                  )..emit(
                    CollectionPokemonSerieError(message: 'An error occurred'),
                  ),
              child: SeriesListPage(),
            ),
          ),
        ),
      );

      await tester.pump();

      expect(find.text('An error occurred'), findsOneWidget);
    },
  );
}
