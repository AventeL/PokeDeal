import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pokedeal/features/collection/domain/repository/collection_pokemon_repository.dart';
import 'package:pokedeal/features/collection/presentation/bloc/collection_pokemon_bloc.dart';

import '../../../mocks/generated_mocks.mocks.dart';

void main() {
  late CollectionPokemonBloc collectionPokemonBloc;
  late CollectionPokemonRepository collectionPokemonRepository;

  setUp(() {
    collectionPokemonRepository = MockCollectionPokemonRepository();
    collectionPokemonBloc = CollectionPokemonBloc(
      collectionPokemonRepository: collectionPokemonRepository,
    );
  });

  tearDown(() {
    collectionPokemonBloc.close();
  });

  group('CollectionPokemonGetSeriesEvent', () {
    void mockGetSeries() {
      when(collectionPokemonRepository.getSeries()).thenAnswer((_) async => []);
    }

    void mockGetSeriesFail() {
      when(
        collectionPokemonRepository.getSeries(),
      ).thenThrow(Exception('Failed to get series'));
    }

    blocTest<CollectionPokemonBloc, CollectionPokemonState>(
      'emits [CollectionPokemonLoading, CollectionPokemonSeriesGet] when successful',
      build: () {
        mockGetSeries();
        return collectionPokemonBloc;
      },
      act: (bloc) {
        bloc.add(CollectionPokemonGetSeriesEvent());
      },
      expect:
          () => [CollectionPokemonLoading(), isA<CollectionPokemonSeriesGet>()],
      verify: (bloc) {
        verify(collectionPokemonRepository.getSeries()).called(1);
      },
    );

    blocTest<CollectionPokemonBloc, CollectionPokemonState>(
      'emits [CollectionPokemonLoading, CollectionPokemonError] when failed',
      build: () {
        mockGetSeriesFail();
        return collectionPokemonBloc;
      },
      act: (bloc) {
        bloc.add(CollectionPokemonGetSeriesEvent());
      },
      expect: () => [CollectionPokemonLoading(), isA<CollectionPokemonError>()],
      verify: (bloc) {
        verify(collectionPokemonRepository.getSeries()).called(1);
        expect(
          (bloc.state as CollectionPokemonError).message,
          Exception('Failed to get series').toString(),
        );
      },
    );
  });
}
