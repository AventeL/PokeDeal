import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pokedeal/features/collection/domain/models/pokemon_serie.dart';
import 'package:pokedeal/features/collection/presentation/bloc/collection_pokemon_bloc.dart';
import 'package:pokedeal/features/collection/presentation/pages/series_list_page.dart';
import 'package:pokedeal/features/collection/presentation/widgets/pokemon_serie_card.dart';

import '../../../mocks/generated_mocks.mocks.dart';

void main() {
  List<PokemonSerie> series = [
    PokemonSerie(id: "1", name: 'Serie 1'),
    PokemonSerie(id: "2", name: 'Serie 2'),
    PokemonSerie(id: "3", name: 'Serie 3'),
  ];

  testWidgets(
    'SeriesListPage has a Title and a ListView when state is CollectionPokemonSeriesGet',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlocProvider(
              create:
                  (context) => CollectionPokemonBloc(
                    collectionPokemonRepository:
                        MockCollectionPokemonRepository(),
                  )..emit(CollectionPokemonSeriesGet(series: series)),
              child: SeriesListPage(),
            ),
          ),
        ),
      );

      expect(find.text('Liste des séries'), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(PokemonSerieCard), findsNWidgets(3));
      expect(find.text('Serie 1'), findsOneWidget);
    },
  );

  testWidgets(
    'SeriesListPage shows CircularProgressIndicator when state is CollectionPokemonLoading',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlocProvider(
              create:
                  (context) => CollectionPokemonBloc(
                    collectionPokemonRepository:
                        MockCollectionPokemonRepository(),
                  )..emit(CollectionPokemonLoading()),
              child: SeriesListPage(),
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    },
  );

  testWidgets(
    'SeriesListPage shows EmptySpace when state is CollectionPokemonEmpty',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlocProvider(
              create:
                  (context) => CollectionPokemonBloc(
                    collectionPokemonRepository:
                        MockCollectionPokemonRepository(),
                  ),
              child: SeriesListPage(),
            ),
          ),
        ),
      );

      expect(find.text('Aucune série trouvée'), findsOneWidget);
    },
  );
}
