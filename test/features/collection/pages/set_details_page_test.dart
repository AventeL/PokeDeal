import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pokedeal/core/di/injection_container.dart';
import 'package:pokedeal/features/collection/domain/models/card_count.dart';
import 'package:pokedeal/features/collection/domain/models/pokemon_set.dart';
import 'package:pokedeal/features/collection/domain/repository/collection_pokemon_repository.dart';
import 'package:pokedeal/features/collection/presentation/bloc/set_bloc/collection_pokemon_set_bloc.dart';
import 'package:pokedeal/features/collection/presentation/pages/set_details_page.dart';

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
                setInfo: PokemonSet(
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
                setInfo: PokemonSet(
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
}
