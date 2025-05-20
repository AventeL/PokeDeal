import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pokedeal/features/authentication/domain/models/user_profile.dart';
import 'package:pokedeal/features/trade/domain/models/user_stats.dart';
import 'package:pokedeal/features/trade/presentation/bloc/trade_bloc.dart';
import 'package:pokedeal/features/trade/presentation/pages/trade_search_page.dart';
import 'package:pokedeal/features/trade/presentation/widgets/trade_profile_card_widget.dart';

import '../../../mocks/generated_mocks.mocks.dart';

void main() {
  late MockTradeBloc mockTradeBloc;

  setUp(() {
    mockTradeBloc = MockTradeBloc();
  });

  tearDown(() {
    mockTradeBloc.close();
  });

  testWidgets('affiche loading au demarrage', (tester) async {
    when(mockTradeBloc.state).thenReturn(TradeStateLoading());

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BlocProvider<TradeBloc>(
            create: (_) => mockTradeBloc,
            child: Column(children: [const TradeSearchPage()]),
          ),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Affiche une liste si on get des users', (tester) async {
    final users = [
      UserStats(
        user: UserProfile(
          id: '1',
          pseudo: 'Alice',
          email: 'alice@test.com',
          createdAt: DateTime.now(),
        ),
        nbCards: 10,
        nbExchanges: 100,
      ),
      UserStats(
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

    when(mockTradeBloc.state).thenReturn(TradeStateUsersLoaded(users: users));

    when(mockTradeBloc.stream).thenAnswer(
      (_) => Stream.fromIterable([
        TradeStateLoading(),
        TradeStateUsersLoaded(users: users),
      ]),
    );
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BlocProvider<TradeBloc>(
            create: (_) => mockTradeBloc,
            child: Column(children: [const TradeSearchPage()]),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(TextField), findsOneWidget);
    expect(find.byType(TradeProfileCardWidget), findsNWidgets(2));
    expect(find.text('Alice'), findsOneWidget);
    expect(find.text('Bob'), findsOneWidget);
  });
}
