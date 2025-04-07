import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pokedeal/features/collection/domain/models/pokemon_serie.dart';
import 'package:pokedeal/features/collection/domain/repository/collection_pokemon_repository.dart';
import 'package:pokedeal/features/collection/presentation/bloc/serie_bloc/collection_pokemon_serie_bloc.dart';

import '../../../mocks/generated_mocks.mocks.dart';

void main() {
  late CollectionPokemonSerieBloc collectionPokemonBloc;
  late CollectionPokemonRepository collectionPokemonRepository;

  setUp(() {
    collectionPokemonRepository = MockCollectionPokemonRepository();
    collectionPokemonBloc = CollectionPokemonSerieBloc(
      collectionPokemonRepository: collectionPokemonRepository,
    );
  });

  tearDown(() {
    collectionPokemonBloc.close();
  });

  group('CollectionPokemonGetSeriesEvent', () {
    void mockGetSeriesWithSets() {
      when(
        collectionPokemonRepository.getSeriesWithSets(),
      ).thenAnswer((_) async => <PokemonSerie>[]);
    }

    void mockGetSeriesWithSetsFail() {
      when(
        collectionPokemonRepository.getSeriesWithSets(),
      ).thenThrow(Exception('Failed to get series'));
    }

    blocTest<CollectionPokemonSerieBloc, CollectionPokemonSerieState>(
      'emits [CollectionPokemonLoading, CollectionPokemonSeriesGet] when successful',
      build: () {
        mockGetSeriesWithSets();
        return collectionPokemonBloc;
      },
      act: (bloc) {
        bloc.add(CollectionPokemonGetSeriesEvent());
      },
      expect:
          () => [
            CollectionPokemonSerieLoading(),
            isA<CollectionPokemonSeriesGet>(),
          ],
      verify: (bloc) {
        verify(collectionPokemonRepository.getSeriesWithSets()).called(1);
      },
    );

    blocTest<CollectionPokemonSerieBloc, CollectionPokemonSerieState>(
      'emits [CollectionPokemonLoading, CollectionPokemonError] when failed',
      build: () {
        mockGetSeriesWithSetsFail();
        return collectionPokemonBloc;
      },
      act: (bloc) {
        bloc.add(CollectionPokemonGetSeriesEvent());
      },
      expect:
          () => [
            CollectionPokemonSerieLoading(),
            isA<CollectionPokemonSerieError>(),
          ],
      verify: (bloc) {
        verify(collectionPokemonRepository.getSeriesWithSets()).called(1);
        expect(
          (bloc.state as CollectionPokemonSerieError).message,
          Exception('Failed to get series').toString(),
        );
      },
    );
  });
}
