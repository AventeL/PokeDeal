import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pokedeal/core/di/injection_container.dart';
import 'package:pokedeal/features/collection/domain/models/card/pokemon_card_brief.dart';
import 'package:pokedeal/features/collection/domain/models/card_count.dart';
import 'package:pokedeal/features/collection/domain/models/legal.dart';
import 'package:pokedeal/features/collection/domain/models/pokemon_serie_brief.dart';
import 'package:pokedeal/features/collection/domain/models/pokemon_set.dart';
import 'package:pokedeal/features/collection/domain/models/pokemon_set_brief.dart';
import 'package:pokedeal/features/collection/domain/repository/collection_pokemon_repository.dart';
import 'package:pokedeal/features/collection/presentation/bloc/set_bloc/collection_pokemon_set_bloc.dart';
import 'package:pokedeal/features/collection/presentation/pages/set_details_page.dart';
import 'package:pokedeal/features/collection/presentation/widgets/pokemon_card_unavailable_widget.dart';
import 'package:pokedeal/features/collection/presentation/widgets/pokemon_card_widget.dart';

import '../../../mocks/generated_mocks.mocks.dart';

void main() {
  final mockRepository = MockCollectionPokemonRepository();
  final mockBloc = MockCollectionPokemonSetBloc();

  setUp(() {
    getIt.registerLazySingleton<CollectionPokemonRepository>(
      () => mockRepository,
    );
    getIt.registerLazySingleton<CollectionPokemonSetBloc>(() => mockBloc);
  });

  tearDown(() {
    getIt.reset();
  });

  testWidgets(
    'SetDetailsPage shows CircularProgressIndicator when state is CollectionPokemonSetLoading',
    (WidgetTester tester) async {
      when(mockBloc.state).thenReturn(CollectionPokemonSetLoading());

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlocProvider<CollectionPokemonSetBloc>(
              create: (context) => mockBloc,
              child: SetDetailsPage(
                setInfo: PokemonSetBrief(
                  name: 'Set 1',
                  id: 'set1',
                  cardCount: CardCount(total: 100, official: 100),
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    },
  );

  testWidgets(
    'SetDetailsPage shows error message when state is CollectionPokemonSetError',
    (WidgetTester tester) async {
      when(
        mockBloc.state,
      ).thenReturn(CollectionPokemonSetError(message: 'An error occurred'));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlocProvider<CollectionPokemonSetBloc>(
              create: (context) => mockBloc,
              child: SetDetailsPage(
                setInfo: PokemonSetBrief(
                  name: 'Set 1',
                  id: 'set1',
                  cardCount: CardCount(total: 100, official: 100),
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.text('An error occurred'), findsOneWidget);
    },
  );

  testWidgets(
    'SetDetailsPage shows set details when state is CollectionPokemonSetWithCardsGet',
    (WidgetTester tester) async {
      when(mockBloc.state).thenReturn(
        CollectionPokemonSetWithCardsGet(
          setWithCards: PokemonSet(
            serieBrief: PokemonSerieBrief(name: 'Serie 1', id: 'serie1'),
            name: 'Set 1',
            id: 'set1',
            cards: [
              PokemonCardBrief(
                name: 'Card 1',
                id: 'card1',
                image: 'https://example.com/card1.png',
                localId: 'card1',
              ),
              PokemonCardBrief(
                name: 'Card 2',
                id: 'card2',
                localId: 'card2',
                image: null,
              ),
            ],
            cardCount: CardCount(total: 100, official: 100),
            legal: Legal(expanded: false, standard: false),
          ),
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlocProvider<CollectionPokemonSetBloc>(
              create: (context) => mockBloc,
              child: SetDetailsPage(
                setInfo: PokemonSetBrief(
                  name: 'Set 1',
                  id: 'set1',
                  cardCount: CardCount(total: 100, official: 100),
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(PokemonCardWidget), findsOneWidget);
      expect(find.byType(PokemonCardUnavailableWidget), findsOneWidget);
    },
  );

  testWidgets('SetDetailsPage shows a text when there are no cards available', (
    WidgetTester tester,
  ) async {
    when(mockBloc.state).thenReturn(
      CollectionPokemonSetWithCardsGet(
        setWithCards: PokemonSet(
          serieBrief: PokemonSerieBrief(name: 'Serie 1', id: 'serie1'),
          name: 'Set 1',
          id: 'set1',
          cards: [],
          cardCount: CardCount(total: 100, official: 100),
          legal: Legal(expanded: false, standard: false),
        ),
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BlocProvider<CollectionPokemonSetBloc>(
            create: (context) => mockBloc,
            child: SetDetailsPage(
              setInfo: PokemonSetBrief(
                name: 'Set 1',
                id: 'set1',
                cardCount: CardCount(total: 100, official: 100),
              ),
            ),
          ),
        ),
      ),
    );
    expect(
      find.text('Les cartes pour Set 1 ne sont pas encore disponibles'),
      findsOneWidget,
    );
  });
}
