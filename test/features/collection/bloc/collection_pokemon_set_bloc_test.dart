import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pokedeal/features/collection/domain/models/card_count.dart';
import 'package:pokedeal/features/collection/domain/models/legal.dart';
import 'package:pokedeal/features/collection/domain/models/pokemon_card.dart';
import 'package:pokedeal/features/collection/domain/models/pokemon_set_with_cards.dart';
import 'package:pokedeal/features/collection/domain/repository/collection_pokemon_repository.dart';
import 'package:pokedeal/features/collection/presentation/bloc/set_bloc/collection_pokemon_set_bloc.dart';

import '../../../mocks/generated_mocks.mocks.dart';

void main() {
  late CollectionPokemonSetBloc collectionPokemonSetBloc;
  late CollectionPokemonRepository collectionPokemonRepository;

  setUp(() {
    collectionPokemonRepository = MockCollectionPokemonRepository();
    collectionPokemonSetBloc = CollectionPokemonSetBloc(
      collectionPokemonRepository: collectionPokemonRepository,
    );
  });

  tearDown(() {
    collectionPokemonSetBloc.close();
  });

  group('_onCollectionPokemonGetSetWithCardsEvent', () {
    void mockGetSetWIthCards() {
      when(
        collectionPokemonRepository.getSetWithCards(setId: 'setId'),
      ).thenAnswer(
        (_) async => PokemonSetWithCards(
          name: 'name',
          id: 'id',
          cardCount: CardCount(total: 100, official: 20),
          cards: [
            PokemonCard(
              id: 'id',
              image: 'image',
              localId: 'localId',
              name: 'name',
            ),
          ],
          legal: Legal(expanded: false, standard: true),
        ),
      );
    }

    void mockGetSetWIthCardsFail() {
      when(
        collectionPokemonRepository.getSetWithCards(setId: 'setId'),
      ).thenThrow(Exception('Failed to get set'));
    }

    blocTest<CollectionPokemonSetBloc, CollectionPokemonSetState>(
      'emits [CollectionPokemonSetLoading, CollectionPokemonSetGet] when successful',
      build: () {
        mockGetSetWIthCards();
        return collectionPokemonSetBloc;
      },
      act: (bloc) {
        bloc.add(CollectionPokemonGetSetWithCardsEvent(setId: 'setId'));
      },
      expect:
          () => [
            CollectionPokemonSetLoading(),
            isA<CollectionPokemonSetWithCardsGet>(),
          ],
      verify: (bloc) {
        verify(
          collectionPokemonRepository.getSetWithCards(setId: 'setId'),
        ).called(1);
      },
    );

    blocTest<CollectionPokemonSetBloc, CollectionPokemonSetState>(
      'emits [CollectionPokemonSetLoading, CollectionPokemonSetError] when failed',
      build: () {
        mockGetSetWIthCardsFail();
        return collectionPokemonSetBloc;
      },
      act: (bloc) {
        bloc.add(CollectionPokemonGetSetWithCardsEvent(setId: 'setId'));
      },
      expect:
          () => [
            CollectionPokemonSetLoading(),
            isA<CollectionPokemonSetError>(),
          ],
      verify: (bloc) {
        verify(
          collectionPokemonRepository.getSetWithCards(setId: 'setId'),
        ).called(1);
        expect(
          (bloc.state as CollectionPokemonSetError).message,
          Exception('Failed to get set').toString(),
        );
      },
    );
  });
}
