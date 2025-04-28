import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pokedeal/features/trade/presentation/bloc/trade_bloc.dart';
import 'package:pokedeal/features/trade/presentation/pages/trade_base_page.dart';
import 'package:pokedeal/features/trade/presentation/pages/trade_request_list_page.dart';
import 'package:pokedeal/features/trade/presentation/pages/trade_search_page.dart';

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

  testWidgets('TradeBasePage displays basic elements with Bloc', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BlocProvider<TradeBloc>(
            create: (_) => mockTradeBloc,
            child: TradeBasePage(),
          ),
        ),
      ),
    );

    expect(find.text('Echanges'), findsOneWidget);
    expect(find.text('Rechercher'), findsOneWidget);
    expect(find.text('Demandes'), findsOneWidget);
  });

  testWidgets(
    'TradeBasePage navigates to correct pages when buttons are pressed with Bloc',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlocProvider<TradeBloc>(
              create: (_) => mockTradeBloc,
              child: TradeBasePage(),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Demandes'));
      await tester.pump();

      expect(find.byType(TradeRequestListPage), findsOneWidget);

      await tester.tap(find.text('Rechercher'));
      await tester.pump();

      expect(find.byType(TradeSearchPage), findsOneWidget);
    },
  );
}
