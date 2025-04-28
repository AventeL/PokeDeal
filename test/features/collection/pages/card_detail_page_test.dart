import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pokedeal/core/di/injection_container.dart';
import 'package:pokedeal/features/authentication/domain/models/user_profile.dart';
import 'package:pokedeal/features/authentication/domain/repository/authentication_repository.dart';
import 'package:pokedeal/features/collection/domain/models/card/base_pokemon_card.dart';
import 'package:pokedeal/features/collection/domain/models/card/card_variant.dart';
import 'package:pokedeal/features/collection/domain/models/card/pokemon_card_brief.dart';
import 'package:pokedeal/features/collection/domain/models/card_count.dart';
import 'package:pokedeal/features/collection/domain/models/enum/card_category.dart';
import 'package:pokedeal/features/collection/domain/models/pokemon_set_brief.dart';
import 'package:pokedeal/features/collection/domain/repository/collection_pokemon_repository.dart';
import 'package:pokedeal/features/collection/presentation/bloc/card_bloc/collection_pokemon_card_bloc.dart';
import 'package:pokedeal/features/collection/presentation/bloc/user_collection/user_collection_bloc.dart';
import 'package:pokedeal/features/collection/presentation/pages/card_detail_page.dart';
import 'package:pokedeal/features/collection/presentation/widgets/card_collection_list_widget.dart';

import '../../../mocks/generated_mocks.mocks.dart';

void main() {
  final mockRepository = MockCollectionPokemonRepository();
  final mockBloc = MockCollectionPokemonCardBloc();
  final mockAuthenticationRepository = MockAuthenticationRepository();

  setUp(() {
    getIt.registerLazySingleton<CollectionPokemonRepository>(
      () => mockRepository,
    );
    getIt.registerLazySingleton<CollectionPokemonCardBloc>(() => mockBloc);

    getIt.registerLazySingleton<AuthenticationRepository>(
      () => mockAuthenticationRepository,
    );
  });

  tearDown(() {
    getIt.reset();
  });

  Widget mockPage = CardDetailPage(
    userId: 'userId',
    cardId: 'cardId',
    cardBrief: PokemonCardBrief(
      id: 'cardId',
      name: 'Card Name',
      image: 'https://example.com/card.png',
      localId: 'localId',
    ),
  );

  testWidgets(
    'CardDetailsPage shows CircularProgressIndicator when state is CollectionPokemonCardLoading',
    (WidgetTester tester) async {
      when(mockBloc.state).thenReturn(CollectionPokemonCardLoading());

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlocProvider<CollectionPokemonCardBloc>(
              create: (context) => mockBloc,
              child: mockPage,
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    },
  );

  testWidgets(
    'CardDetailsPage shows error message when state is CollectionPokemonCardError',
    (WidgetTester tester) async {
      when(
        mockBloc.state,
      ).thenReturn(CollectionPokemonCardError(message: 'An error occurred'));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlocProvider<CollectionPokemonCardBloc>(
              create: (context) => mockBloc,
              child: mockPage,
            ),
          ),
        ),
      );

      expect(find.text('Error: An error occurred'), findsOneWidget);
    },
  );

  testWidgets(
    'CardDetailsPage shows card details when state is CollectionPokemonCardsGet',
    (WidgetTester tester) async {
      when(mockAuthenticationRepository.userProfile).thenReturn(
        UserProfile(
          id: 'userId',
          email: 'email',
          pseudo: 'username',
          createdAt: DateTime.now(),
        ),
      );
      when(mockBloc.state).thenReturn(
        CollectionPokemonCardsGet(
          card: BasePokemonCard(
            localId: '1',
            category: CardCategory.trainer,
            illustrator: 'Illustrator Name',
            id: 'cardId',
            name: 'Card Name',
            image: 'https://example.com/card.png',
            rarity: 'Rare',
            setBrief: PokemonSetBrief(
              id: 'setId',
              name: 'Set Name',
              symbolUrl: 'https://example.com/card',
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
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MultiBlocProvider(
              providers: [
                BlocProvider<CollectionPokemonCardBloc>(
                  create: (context) => mockBloc,
                ),
                BlocProvider<UserCollectionBloc>(
                  create:
                      (context) =>
                          MockUserCollectionBloc(), // Mock du UserCollectionBloc
                ),
              ],
              child: mockPage,
            ),
          ),
        ),
      );

      expect(find.text('Card Name'), findsNWidgets(2));
      expect(find.byType(CachedNetworkImage), findsNWidgets(2));
      expect(find.text("1/100"), findsOneWidget);
      expect(find.text('Rare'), findsOneWidget);
      expect(find.text('Set Name'), findsOneWidget);
      expect(find.byIcon(Icons.brush), findsOneWidget);
      expect(find.text('Illustrator Name'), findsOneWidget);
      expect(find.byType(CardCollectionListWidget), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsOneWidget);
    },
  );

  testWidgets('CardDetailsPage shows error message when state is Initial', (
    WidgetTester tester,
  ) async {
    when(mockBloc.state).thenReturn(CollectionPokemonCardInitial());

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BlocProvider<CollectionPokemonCardBloc>(
            create: (context) => mockBloc,
            child: mockPage,
          ),
        ),
      ),
    );

    expect(find.text('Carte indisponible'), findsOneWidget);
  });
}
