import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pokedeal/core/di/injection_container.dart';
import 'package:pokedeal/features/authentication/domain/models/user_profile.dart';
import 'package:pokedeal/features/authentication/domain/repository/authentication_repository.dart';
import 'package:pokedeal/features/collection/domain/models/card/pokemon_card_brief.dart';
import 'package:pokedeal/features/collection/domain/models/card/user_card_collection.dart';
import 'package:pokedeal/features/collection/domain/models/card_count.dart';
import 'package:pokedeal/features/collection/domain/models/enum/variant_value.dart';
import 'package:pokedeal/features/collection/domain/models/legal.dart';
import 'package:pokedeal/features/collection/domain/models/pokemon_serie_brief.dart';
import 'package:pokedeal/features/collection/domain/models/pokemon_set.dart';
import 'package:pokedeal/features/collection/domain/models/pokemon_set_brief.dart';
import 'package:pokedeal/features/collection/presentation/bloc/set_bloc/collection_pokemon_set_bloc.dart';
import 'package:pokedeal/features/collection/presentation/bloc/user_collection/user_collection_bloc.dart';
import 'package:pokedeal/features/collection/presentation/pages/set_details_page.dart';

import '../../../mocks/generated_mocks.mocks.dart';

void main() {
  late MockCollectionPokemonSetBloc mockSetBloc;
  late MockUserCollectionBloc mockUserCollectionBloc;
  late MockAuthenticationRepository mockAuthRepository;

  setUp(() {
    mockSetBloc = MockCollectionPokemonSetBloc();
    mockUserCollectionBloc = MockUserCollectionBloc();
    mockAuthRepository = MockAuthenticationRepository();

    getIt.registerLazySingleton<AuthenticationRepository>(
      () => mockAuthRepository,
    );
    getIt.registerLazySingleton<CollectionPokemonSetBloc>(() => mockSetBloc);
    getIt.registerLazySingleton<UserCollectionBloc>(
      () => mockUserCollectionBloc,
    );

    when(mockAuthRepository.userProfile).thenReturn(
      UserProfile(
        id: 'userId',
        pseudo: 'TestUser',
        email: 'test@example.com',
        createdAt: DateTime.now(),
      ),
    );
  });

  tearDown(() {
    getIt.reset();
  });

  Widget createTestWidget() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CollectionPokemonSetBloc>(create: (_) => mockSetBloc),
        BlocProvider<UserCollectionBloc>(create: (_) => mockUserCollectionBloc),
      ],
      child: MaterialApp(
        home: SetDetailsPage(
          setInfo: PokemonSetBrief(
            id: 'set1',
            name: 'Set 1',
            cardCount: CardCount(total: 100, official: 100),
          ),
        ),
      ),
    );
  }

  testWidgets('Affiche CircularProgressIndicator quand loading', (
    tester,
  ) async {
    when(mockSetBloc.state).thenReturn(CollectionPokemonSetLoading());
    when(mockUserCollectionBloc.state).thenReturn(UserCollectionInitial());

    await tester.pumpWidget(createTestWidget());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Affiche message d\'erreur si erreur dans le set bloc', (
    tester,
  ) async {
    when(mockSetBloc.state).thenReturn(
      CollectionPokemonSetError(message: 'Erreur dans le chargement'),
    );
    when(mockUserCollectionBloc.state).thenReturn(UserCollectionInitial());

    await tester.pumpWidget(createTestWidget());

    expect(find.text('Erreur dans le chargement'), findsOneWidget);
  });

  testWidgets('Affiche message quand aucune carte disponible', (tester) async {
    when(mockSetBloc.state).thenReturn(
      CollectionPokemonSetWithCardsGet(
        setWithCards: PokemonSet(
          id: 'set1',
          name: 'Set 1',
          serieBrief: PokemonSerieBrief(id: 'serie1', name: 'Série 1'),
          cards: [],
          cardCount: CardCount(total: 100, official: 100),
          legal: Legal(expanded: false, standard: false),
        ),
      ),
    );

    when(mockUserCollectionBloc.state).thenReturn(UserCollectionInitial());

    await tester.pumpWidget(createTestWidget());

    expect(
      find.textContaining('ne sont pas encore disponibles'),
      findsOneWidget,
    );
  });

  testWidgets('Affiche cartes et progression quand disponibles', (
    tester,
  ) async {
    final card1 = PokemonCardBrief(
      id: 'card1',
      name: 'Card 1',
      image: 'https://example.com/image1.png',
      localId: '001',
    );

    final card2 = PokemonCardBrief(
      id: 'card2',
      name: 'Card 2',
      image: null,
      localId: '002',
    );

    when(mockSetBloc.state).thenReturn(
      CollectionPokemonSetWithCardsGet(
        setWithCards: PokemonSet(
          id: 'set1',
          name: 'Set 1',
          serieBrief: PokemonSerieBrief(id: 'serie1', name: 'Série 1'),
          cards: [card1, card2],
          cardCount: CardCount(total: 100, official: 100),
          legal: Legal(expanded: false, standard: false),
        ),
      ),
    );

    when(mockUserCollectionBloc.state).thenReturn(
      UserCollectionSetLoaded(
        userCardsCollection: [
          UserCardCollection(
            cardId: 'card1',
            setId: 'set1',
            quantity: 5,
            userId: 'userId',
            id: '1',
            variant: VariantValue.normal,
          ),
        ],
      ),
    );

    await tester.pumpWidget(createTestWidget());

    expect(find.byType(LinearProgressIndicator), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
    expect(find.byType(Text), findsWidgets);
  });
}
