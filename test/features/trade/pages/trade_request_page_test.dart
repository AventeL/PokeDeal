import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pokedeal/features/trade/presentation/bloc/trade_bloc.dart';
import 'package:pokedeal/features/trade/presentation/pages/trade_request_page.dart';
import 'package:pokedeal/features/trade/presentation/widgets/trade_list_widget.dart';

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

  testWidgets('TradeRequestPage displays TabBar with correct tabs', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BlocProvider<TradeBloc>(
            create: (_) => mockTradeBloc,
            child: Column(children: [TradeRequestPage()]),
          ),
        ),
      ),
    );

    expect(find.widgetWithText(Tab, 'Reçues'), findsOneWidget);
    expect(find.widgetWithText(Tab, 'Envoyées'), findsOneWidget);
  });

  testWidgets('TradeRequestPage switches tabs correctly', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BlocProvider<TradeBloc>(
            create: (_) => mockTradeBloc,
            child: Column(children: [TradeRequestPage()]),
          ),
        ),
      ),
    );

    expect(find.byType(TradeListWidget), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (widget) => widget is TradeListWidget && widget.tabIndex == 0,
      ),
      findsOneWidget,
    );

    await tester.tap(find.widgetWithText(Tab, 'Envoyées'));
    await tester.pumpAndSettle();

    expect(
      find.byWidgetPredicate(
        (widget) => widget is TradeListWidget && widget.tabIndex == 1,
      ),
      findsOneWidget,
    );
  });
}
