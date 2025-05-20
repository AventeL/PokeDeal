import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pokedeal/core/di/injection_container.dart';
import 'package:pokedeal/features/collection/domain/repository/collection_pokemon_repository.dart';
import 'package:pokedeal/features/collection/presentation/bloc/serie_bloc/collection_pokemon_serie_bloc.dart';
import 'package:pokedeal/features/collection/presentation/pages/series_list_page.dart';
import 'package:pokedeal/features/home/presentation/pages/home_page.dart';
import 'package:pokedeal/features/home/presentation/widgets/custom_bottom_navigation_bar.dart';

import '../../../mocks/generated_mocks.mocks.dart';

void main() {
  group('HomePage Tests', () {
    late MockCollectionPokemonRepository mockRepository;

    setUp(() {
      mockRepository = MockCollectionPokemonRepository();

      getIt.registerLazySingleton<CollectionPokemonRepository>(
            () => mockRepository,
      );
    });
    testWidgets('Affiche la home page', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MultiBlocProvider(
            providers: [
              BlocProvider<CollectionPokemonSerieBloc>(
                create:
                    (_) =>
                CollectionPokemonSerieBloc(
                  collectionPokemonRepository: mockRepository,
                )
                  ..add(CollectionPokemonGetSeriesEvent()),
              ),
            ],
            child: HomePage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(CustomBottomNavigationBar), findsOneWidget);
      expect(find.byType(SeriesListPage), findsOneWidget);
    });
  });
}
