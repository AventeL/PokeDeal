import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pokedeal/core/di/injection_container.dart';
import 'package:pokedeal/features/authentication/domain/models/user_profile.dart';
import 'package:pokedeal/features/authentication/domain/repository/authentication_repository.dart';
import 'package:pokedeal/features/collection/domain/models/card/base_pokemon_card.dart';
import 'package:pokedeal/features/collection/domain/models/card/card_variant.dart';
import 'package:pokedeal/features/collection/domain/models/card_count.dart';
import 'package:pokedeal/features/collection/domain/models/enum/card_category.dart';
import 'package:pokedeal/features/collection/domain/models/enum/variant_value.dart';
import 'package:pokedeal/features/collection/domain/models/pokemon_set_brief.dart';
import 'package:pokedeal/features/collection/presentation/bloc/card_bloc/collection_pokemon_card_bloc.dart';
import 'package:pokedeal/features/discussion/domain/model/discussion.dart';
import 'package:pokedeal/features/discussion/domain/model/message.dart';
import 'package:pokedeal/features/discussion/presentation/bloc/discussion_bloc.dart';
import 'package:pokedeal/features/discussion/presentation/pages/discussion_page.dart';
import 'package:pokedeal/features/trade/domain/models/enum/trade_status.dart';
import 'package:pokedeal/features/trade/domain/models/trade.dart';
import 'package:pokedeal/features/trade/presentation/bloc/trade_bloc.dart';

import '../../../mocks/generated_mocks.mocks.dart';

void main() {
  late MockDiscussionBloc mockDiscussionBloc;
  late MockTradeBloc mockTradeBloc;
  late MockCollectionPokemonCardBloc mockCollectionCardBloc;
  late MockAuthenticationRepository mockAuthenticationRepository;

  setUp(() {
    mockDiscussionBloc = MockDiscussionBloc();
    mockTradeBloc = MockTradeBloc();
    mockCollectionCardBloc = MockCollectionPokemonCardBloc();
    mockAuthenticationRepository = MockAuthenticationRepository();
    getIt.registerLazySingleton<AuthenticationRepository>(
      () => mockAuthenticationRepository,
    );
    getIt.registerLazySingleton<DiscussionBloc>(() => mockDiscussionBloc);

    when(mockAuthenticationRepository.userProfile).thenReturn(
      UserProfile(
        id: '1',
        pseudo: 'TestUser',
        createdAt: DateTime(2023, 10, 9),
        email: 'mail',
      ),
    );
  });

  tearDown(() {
    mockDiscussionBloc.close();
    mockTradeBloc.close();
    mockCollectionCardBloc.close();
  });

  final sender = UserProfile(
    id: 'user1',
    pseudo: 'senderPseudo',
    email: 'sender@example.com',
    createdAt: DateTime.now(),
  );

  final receiver = UserProfile(
    id: 'user2',
    pseudo: 'receiverPseudo',
    email: 'receiver@example.com',
    createdAt: DateTime.now(),
  );

  final trade = Trade(
    id: 'trade1',
    senderId: sender,
    receiveId: receiver,
    status: TradeStatus.waiting,
    timestamp: DateTime.now(),
    senderCardId: 'card1',
    receiverCardId: 'card2',
    senderCardVariant: VariantValue.normal,
    receiverCardVariant: VariantValue.holo,
  );

  final discussion = Discussion(
    id: 'discussion1',
    tradeId: trade.id,
    messages: [
      Message(
        id: 'msg1',
        discussionId: 'discussion1',
        senderId: sender.id,
        content: 'Hello',
        sendAt: DateTime.now(),
        type: MessageType.normal,
      ),
      Message(
        id: 'msg2',
        discussionId: 'discussion1',
        senderId: receiver.id,
        content: 'Hi there!',
        sendAt: DateTime.now(),
        type: MessageType.normal,
      ),
    ],
  );

  final cardsMap = {
    'card1': BasePokemonCard(
      id: 'card1',
      name: 'Pikachu',
      localId: 'pikachu',
      category: CardCategory.pokemon,
      image: 'https://example.com/pikachu.png',
      setBrief: PokemonSetBrief(
        name: 'Base Set',
        id: 'baseSet',
        cardCount: CardCount(total: 100, official: 100),
      ),
      variants: CardVariant(
        firstEdition: false,
        holo: true,
        reverse: false,
        promo: true,
        normal: true,
      ),
    ),
    'card2': BasePokemonCard(
      id: 'card1',
      name: 'Pikachu2',
      localId: 'pikachu2',
      category: CardCategory.pokemon,
      image: 'https://example.com/pikachu.png',
      setBrief: PokemonSetBrief(
        name: 'Base Set',
        id: 'baseSet',
        cardCount: CardCount(total: 100, official: 100),
      ),
      variants: CardVariant(
        firstEdition: false,
        holo: true,
        reverse: false,
        promo: true,
        normal: true,
      ),
    ),
  };

  testWidgets(
    'DiscussionPage shows messages, trade propose and sends message',
    (WidgetTester tester) async {
      // Mock states and streams for blocs
      when(
        mockDiscussionBloc.state,
      ).thenReturn(DiscussionStateDiscussionGet(discussion: discussion));
      when(mockDiscussionBloc.stream).thenAnswer(
        (_) =>
            Stream.value(DiscussionStateDiscussionGet(discussion: discussion)),
      );

      when(mockTradeBloc.state).thenReturn(TradeStateInitial());
      when(
        mockTradeBloc.stream,
      ).thenAnswer((_) => Stream.value(TradeStateInitial()));

      when(
        mockCollectionCardBloc.state,
      ).thenReturn(CollectionPokemonCardsByIdsGet(cards: cardsMap));
      when(mockCollectionCardBloc.stream).thenAnswer(
        (_) => Stream.value(CollectionPokemonCardsByIdsGet(cards: cardsMap)),
      );

      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<DiscussionBloc>.value(value: mockDiscussionBloc),
            BlocProvider<TradeBloc>.value(value: mockTradeBloc),
            BlocProvider<CollectionPokemonCardBloc>.value(
              value: mockCollectionCardBloc,
            ),
          ],
          child: MaterialApp(home: DiscussionPage(trade: trade)),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.textContaining('receiverPseudo'), findsOneWidget);

      expect(find.text('Hello'), findsOneWidget);
      expect(find.text('Hi there!'), findsOneWidget);

      expect(find.text('Proposition d\'échange'), findsOneWidget);
    },
  );
}
