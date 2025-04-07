import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pokedeal/features/collection/domain/models/card/base_pokemon_card.dart';
import 'package:pokedeal/features/collection/domain/models/card/card_variant.dart';
import 'package:pokedeal/features/collection/domain/models/card_count.dart';
import 'package:pokedeal/features/collection/domain/models/enum/card_category.dart';
import 'package:pokedeal/features/collection/domain/models/pokemon_set_brief.dart';
import 'package:pokedeal/features/collection/domain/repository/collection_pokemon_repository.dart';
import 'package:pokedeal/features/collection/presentation/bloc/card_bloc/collection_pokemon_card_bloc.dart';

import '../../../mocks/generated_mocks.mocks.dart';

void main() {
  late CollectionPokemonCardBloc collectionPokemonCardBloc;
  late CollectionPokemonRepository collectionPokemonRepository;

  setUp(() {
    collectionPokemonRepository = MockCollectionPokemonRepository();
    collectionPokemonCardBloc = CollectionPokemonCardBloc(
      collectionPokemonRepository: collectionPokemonRepository,
    );
  });

  tearDown(() {
    collectionPokemonCardBloc.close();
  });

  group('_onCollectionPokemonGetCardEvent', () {
    void mockGetCard() {
      when(collectionPokemonRepository.getCard(id: 'cardId')).thenAnswer(
        (_) async => BasePokemonCard(
          localId: 'localId',
          category: CardCategory.trainer,
          illustrator: 'Illustrator Name',
          id: 'cardId',
          name: 'Card Name',
          image: 'https://example.com/card.png',
          setBrief: PokemonSetBrief(
            id: 'setId',
            name: 'Set Name',
            cardCount: CardCount(total: 100, official: 50),
          ),
          variants: CardVariant(
            firstEdition: true,
            holo: false,
            reverse: false,
            promo: false,
            normal: true,
          ),
        ),
      );
    }

    void mockGetCardFail() {
      when(
        collectionPokemonRepository.getCard(id: 'cardId'),
      ).thenThrow(Exception('Failed to get card'));
    }

    blocTest<CollectionPokemonCardBloc, CollectionPokemonCardState>(
      'emits [CollectionPokemonCardLoading, CollectionPokemonCardsGet] when successful',
      build: () {
        mockGetCard();
        return collectionPokemonCardBloc;
      },
      act: (bloc) {
        bloc.add(CollectionPokemonGetCardEvent(cardId: 'cardId'));
      },
      expect:
          () => [
            CollectionPokemonCardLoading(),
            isA<CollectionPokemonCardsGet>(),
          ],
      verify: (bloc) {
        verify(collectionPokemonRepository.getCard(id: 'cardId')).called(1);
      },
    );

    blocTest<CollectionPokemonCardBloc, CollectionPokemonCardState>(
      'emits [CollectionPokemonCardLoading, CollectionPokemonCardError] when failed',
      build: () {
        mockGetCardFail();
        return collectionPokemonCardBloc;
      },
      act: (bloc) {
        bloc.add(CollectionPokemonGetCardEvent(cardId: 'cardId'));
      },
      expect:
          () => [
            CollectionPokemonCardLoading(),
            isA<CollectionPokemonCardError>(),
          ],
      verify: (bloc) {
        verify(collectionPokemonRepository.getCard(id: 'cardId')).called(1);
        expect(
          (bloc.state as CollectionPokemonCardError).message,
          Exception('Failed to get card').toString(),
        );
      },
    );
  });
}
