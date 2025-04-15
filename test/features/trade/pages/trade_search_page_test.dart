import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pokedeal/features/authentication/domain/models/user_profile.dart';
import 'package:pokedeal/features/trade/domain/models/userStats.dart';
import 'package:pokedeal/features/trade/presentation/bloc/trade_bloc.dart';
import 'package:pokedeal/features/trade/presentation/pages/trade_search_page.dart';
import 'package:pokedeal/features/trade/presentation/widgets/trade_profile_card_widget.dart';

import '../../../mocks/generated_mocks.mocks.dart';

void main() {
  late MockTradeBloc mockTradeBloc;

  setUp(() {
    mockTradeBloc = MockTradeBloc();
    when(mockTradeBloc.state).thenReturn(TradeStateInitial());
  });

  tearDown(() {
    mockTradeBloc.close();
  });

  testWidgets('TradeSearchPage displays search field and user list', (
    WidgetTester tester,
  ) async {
    final mockUsers = [
      Userstats(
        user: UserProfile(
          id: '1',
          pseudo: 'Alice',
          email: 'alice@test.com',
          createdAt: DateTime.now(),
        ),
        nbCards: 10,
        nbExchanges: 100,
      ),
      Userstats(
        user: UserProfile(
          id: '2',
          pseudo: 'Bob',
          email: 'bob@test.com',
          createdAt: DateTime.now(),
        ),
        nbCards: 59,
        nbExchanges: 103,
      ),
    ];

    when(
      mockTradeBloc.state,
    ).thenReturn(TradeStateUsersLoaded(users: mockUsers));

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BlocProvider<TradeBloc>(
            create: (_) => mockTradeBloc,
            child: Column(children: [TradeSearchPage()]),
          ),
        ),
      ),
    );

    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Rechercher un collectionneur'), findsOneWidget);

    expect(find.byType(TradeProfileCardWidget), findsNWidgets(2));
    expect(find.text('Alice'), findsOneWidget);
    expect(find.text('Bob'), findsOneWidget);
  });

  testWidgets('TradeSearchPage filters user list based on search query', (
    WidgetTester tester,
  ) async {
    final mockUsers = [
      Userstats(
        user: UserProfile(
          id: '1',
          pseudo: 'Alice',
          email: 'alice@test.com',
          createdAt: DateTime.now(),
        ),
        nbCards: 10,
        nbExchanges: 100,
      ),
      Userstats(
        user: UserProfile(
          id: '2',
          pseudo: 'Bob',
          email: 'bob@test.com',
          createdAt: DateTime.now(),
        ),
        nbCards: 59,
        nbExchanges: 103,
      ),
    ];

    when(
      mockTradeBloc.state,
    ).thenReturn(TradeStateUsersLoaded(users: mockUsers));

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BlocProvider<TradeBloc>(
            create: (_) => mockTradeBloc,
            child: Column(children: [TradeSearchPage()]),
          ),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), 'Alice');
    await tester.pump();

    expect(find.text('Alice'), findsNWidgets(2));
    expect(find.text('Bob'), findsNothing);
  });
}
