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
    void mockLoadSetCollection() {
      when(
        collectionPokemonRepository.getUserCollection(
          userId: 'userId',
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

    void mockLoadCardCollection() {
      when(
        collectionPokemonRepository.getUserCollection(
          userId: 'userId',
          cardId: 'cardId',
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
      'emits [UserCollectionLoading, UserCollectionSetLoaded] when UserCollectionLoadSetEvent is added and successful',
      build: () {
        mockLoadSetCollection();
        return userCollectionBloc;
      },
      act: (bloc) {
        bloc.add(UserCollectionLoadSetEvent(userId: 'userId', setId: 'setId'));
      },
      expect:
          () => [
            UserCollectionLoading(),
            UserCollectionSetLoaded(
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
            setId: 'setId',
          ),
        ).called(1);
      },
    );

    blocTest<UserCollectionBloc, UserCollectionState>(
      'emits [UserCollectionLoading, UserCollectionCardLoaded] when UserCollectionLoadCardEvent is added and successful',
      build: () {
        mockLoadCardCollection();
        return userCollectionBloc;
      },
      act: (bloc) {
        bloc.add(
          UserCollectionLoadCardEvent(userId: 'userId', cardId: 'cardId'),
        );
      },
      expect:
          () => [
            UserCollectionLoading(),
            UserCollectionCardLoaded(
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
          ),
        ).called(1);
      },
    );

    blocTest<UserCollectionBloc, UserCollectionState>(
      'emits [UserCollectionLoading, UserCollectionError] when UserCollectionLoadSetEvent fails',
      build: () {
        when(
          collectionPokemonRepository.getUserCollection(
            userId: 'userId',
            setId: 'setId',
          ),
        ).thenThrow(Exception('Failed to load collection'));
        return userCollectionBloc;
      },
      act: (bloc) {
        bloc.add(UserCollectionLoadSetEvent(userId: 'userId', setId: 'setId'));
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
            setId: 'setId',
          ),
        ).called(1);
      },
    );

    blocTest<UserCollectionBloc, UserCollectionState>(
      'emits [UserCollectionLoading, UserCollectionError] when UserCollectionLoadCardEvent fails',
      build: () {
        when(
          collectionPokemonRepository.getUserCollection(
            userId: 'userId',
            cardId: 'cardId',
          ),
        ).thenThrow(Exception('Failed to load collection'));
        return userCollectionBloc;
      },
      act: (bloc) {
        bloc.add(
          UserCollectionLoadCardEvent(userId: 'userId', cardId: 'cardId'),
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
            UserCollectionCardLoaded(userCardsCollection: []),
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

    blocTest<UserCollectionBloc, UserCollectionState>(
      'emits [UserCollectionLoading, UserCollectionStateCardDeleted] when UserCollectionDeleteCardEvent is added and successful',
      build: () {
        when(
          collectionPokemonRepository.deleteCardFromUserCollection(
            id: 'cardId',
            quantity: 1,
            variant: VariantValue.normal,
            setId: 'setId',
          ),
        ).thenAnswer((_) async {});
        return userCollectionBloc;
      },
      act: (bloc) {
        bloc.add(
          UserCollectionDeleteCardEvent(
            pokemonCardId: 'cardId',
            quantity: 1,
            variant: VariantValue.normal,
            setId: 'setId',
          ),
        );
      },
      expect:
          () => [
            UserCollectionLoading(),
            UserCollectionStateCardDeleted(cardId: 'cardId', userId: 'setId'),
            UserCollectionLoading(),
            UserCollectionCardLoaded(userCardsCollection: []),
          ],
      verify: (bloc) {
        verify(
          collectionPokemonRepository.deleteCardFromUserCollection(
            id: 'cardId',
            quantity: 1,
            variant: VariantValue.normal,
            setId: 'setId',
          ),
        ).called(1);
      },
    );

    blocTest<UserCollectionBloc, UserCollectionState>(
      'emits [UserCollectionLoading, UserCollectionError] when UserCollectionDeleteCardEvent fails',
      build: () {
        when(
          collectionPokemonRepository.deleteCardFromUserCollection(
            id: 'cardId',
            quantity: 1,
            variant: VariantValue.normal,
            setId: 'setId',
          ),
        ).thenThrow(Exception('Failed to delete card'));
        return userCollectionBloc;
      },
      act: (bloc) {
        bloc.add(
          UserCollectionDeleteCardEvent(
            pokemonCardId: 'cardId',
            quantity: 1,
            variant: VariantValue.normal,
            setId: 'setId',
          ),
        );
      },
      expect:
          () => [
            UserCollectionLoading(),
            UserCollectionError(message: 'Exception: Failed to delete card'),
          ],
      verify: (bloc) {
        verify(
          collectionPokemonRepository.deleteCardFromUserCollection(
            id: 'cardId',
            quantity: 1,
            variant: VariantValue.normal,
            setId: 'setId',
          ),
        ).called(1);
      },
    );
  });
}
