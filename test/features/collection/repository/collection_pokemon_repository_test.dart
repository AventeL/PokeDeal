import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pokedeal/features/collection/data/collection_pokemon_data_source_interface.dart';
import 'package:pokedeal/features/collection/domain/models/pokemon_serie.dart';
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

  group('getSeries', () {
    test('getSeries returns a list of PokemonSerie', () async {
      final mockSeries = [
        PokemonSerie(id: '1', name: 'Serie 1'),
        PokemonSerie(id: '2', name: 'Serie 2'),
      ];

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
}
