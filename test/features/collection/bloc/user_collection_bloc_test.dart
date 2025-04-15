import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pokedeal/core/di/injection_container.dart';
import 'package:pokedeal/features/authentication/domain/models/user_profile.dart';
import 'package:pokedeal/features/authentication/domain/repository/authentication_repository.dart';
import 'package:pokedeal/features/collection/domain/models/card/user_card_collection.dart';
import 'package:pokedeal/features/collection/domain/models/enum/variant_value.dart';
import 'package:pokedeal/features/collection/domain/repository/collection_pokemon_repository.dart';
import 'package:pokedeal/features/collection/presentation/bloc/user_collection/user_collection_bloc.dart';

import '../../../mocks/generated_mocks.mocks.dart';

void main() {
  late UserCollectionBloc userCollectionBloc;
  late CollectionPokemonRepository collectionPokemonRepository;

  setUp(() {
    final mockAuthRepository = MockAuthenticationRepository();
    when(mockAuthRepository.userProfile).thenReturn(
      UserProfile(
        pseudo: 'TestUser',
        id: 'userId',
        email: 'test@gmail.com',
        createdAt: DateTime.now(),
      ),
    );

    getIt.registerSingleton<AuthenticationRepository>(mockAuthRepository);

    collectionPokemonRepository = MockCollectionPokemonRepository();
    userCollectionBloc = UserCollectionBloc(
      collectionPokemonRepository: collectionPokemonRepository,
    );
  });

  tearDown(() {
    userCollectionBloc.close();
    getIt.reset();
  });

  group('UserCollectionBloc tests', () {
    void mockLoadCollection() {
      when(
        collectionPokemonRepository.getUserCollection(
          userId: 'userId',
          cardId: 'cardId',
          setId: 'setId',
        ),
      ).thenAnswer(
        (_) async => [
          UserCardCollection(
            id: '1',
            userId: 'userId',
            quantity: 2,
            cardId: 'cardId',
            setId: 'setId',
            variant: VariantValue.holo,
          ),
        ],
      );
    }

    void mockAddCardToCollection() {
      when(
        collectionPokemonRepository.addCardToUserCollection(
          id: 'cardId',
          quantity: 2,
          variant: VariantValue.holo,
          setId: 'setId',
        ),
      ).thenAnswer(
        (_) async => UserCardCollection(
          id: '1',
          userId: 'userId',
          quantity: 2,
          cardId: 'cardId',
          setId: 'setId',
          variant: VariantValue.holo,
        ),
      );
    }

    blocTest<UserCollectionBloc, UserCollectionState>(
      'emits [UserCollectionLoading, UserCollectionLoaded] when UserCollectionLoadEvent is added and successful',
      build: () {
        mockLoadCollection();
        return userCollectionBloc;
      },
      act: (bloc) {
        bloc.add(
          UserCollectionLoadEvent(
            userId: 'userId',
            cardId: 'cardId',
            setId: 'setId',
          ),
        );
      },
      expect:
          () => [
            UserCollectionLoading(),
            UserCollectionLoaded(
              userCardsCollection: [
                UserCardCollection(
                  id: '1',
                  userId: 'userId',
                  quantity: 2,
                  cardId: 'cardId',
                  setId: 'setId',
                  variant: VariantValue.holo,
                ),
              ],
            ),
          ],
      verify: (bloc) {
        verify(
          collectionPokemonRepository.getUserCollection(
            userId: 'userId',
            cardId: 'cardId',
            setId: 'setId',
          ),
        ).called(1);
      },
    );

    blocTest<UserCollectionBloc, UserCollectionState>(
      'emits [UserCollectionLoading, UserCollectionError] when UserCollectionLoadEvent fails',
      build: () {
        when(
          collectionPokemonRepository.getUserCollection(
            userId: 'userId',
            cardId: 'cardId',
            setId: 'setId',
          ),
        ).thenThrow(Exception('Failed to load collection'));
        return userCollectionBloc;
      },
      act: (bloc) {
        bloc.add(
          UserCollectionLoadEvent(
            userId: 'userId',
            cardId: 'cardId',
            setId: 'setId',
          ),
        );
      },
      expect:
          () => [
            UserCollectionLoading(),
            UserCollectionError(
              message: 'Exception: Failed to load collection',
            ),
          ],
      verify: (bloc) {
        verify(
          collectionPokemonRepository.getUserCollection(
            userId: 'userId',
            cardId: 'cardId',
            setId: 'setId',
          ),
        ).called(1);
      },
    );

    blocTest<UserCollectionBloc, UserCollectionState>(
      'emits [UserCollectionLoading, UserCollectionStateCardAdded] when UserCollectionAddCardEvent is added and successful',
      build: () {
        mockAddCardToCollection();
        return userCollectionBloc;
      },
      act: (bloc) {
        bloc.add(
          UserCollectionAddCardEvent(
            pokemonCardId: 'cardId',
            quantity: 2,
            variant: VariantValue.holo,
            setId: 'setId',
          ),
        );
      },
      expect:
          () => [
            UserCollectionLoading(),
            UserCollectionStateCardAdded(),
            UserCollectionLoading(),
            UserCollectionLoaded(userCardsCollection: []),
          ],
      verify: (bloc) {
        verify(
          collectionPokemonRepository.addCardToUserCollection(
            id: 'cardId',
            quantity: 2,
            variant: VariantValue.holo,
            setId: 'setId',
          ),
        ).called(1);
      },
    );

    blocTest<UserCollectionBloc, UserCollectionState>(
      'emits [UserCollectionLoading, UserCollectionError] when UserCollectionAddCardEvent fails',
      build: () {
        when(
          collectionPokemonRepository.addCardToUserCollection(
            id: 'cardId',
            quantity: 2,
            variant: VariantValue.holo,
            setId: 'setId',
          ),
        ).thenThrow(Exception('Failed to add card'));
        return userCollectionBloc;
      },
      act: (bloc) {
        bloc.add(
          UserCollectionAddCardEvent(
            pokemonCardId: 'cardId',
            quantity: 2,
            variant: VariantValue.holo,
            setId: 'setId',
          ),
        );
      },
      expect:
          () => [
            UserCollectionLoading(),
            UserCollectionError(message: 'Exception: Failed to add card'),
          ],
      verify: (bloc) {
        verify(
          collectionPokemonRepository.addCardToUserCollection(
            id: 'cardId',
            quantity: 2,
            variant: VariantValue.holo,
            setId: 'setId',
          ),
        ).called(1);
      },
    );
  });
}
