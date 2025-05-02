import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pokedeal/features/authentication/domain/models/user_profile.dart';
import 'package:pokedeal/features/trade/domain/models/enum/trade_status.dart';
import 'package:pokedeal/features/trade/domain/models/trade.dart';
import 'package:pokedeal/features/trade/presentation/widgets/trade_card_widget.dart';

void main() {
  testWidgets(
    'TradeCardWidget displays trade information for a receive trade',
    (WidgetTester tester) async {
      final mockTrade = Trade(
        id: 'tradeId',
        senderId: UserProfile(
          id: 'senderId',
          email: 'sender@test.com',
          pseudo: 'Sender',
          createdAt: DateTime.now(),
        ),
        receiveId: UserProfile(
          id: 'receiverId',
          email: 'receiver@test.com',
          pseudo: 'Receiver',
          createdAt: DateTime.now(),
        ),
        status: TradeStatus.waiting,
        timestamp: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TradeCardRequestWidget(
              trade: mockTrade,
              onTap: () {},
              isTradeReceived: true,
            ),
          ),
        ),
      );

      expect(find.text('Sender'), findsOneWidget);
      expect(find.text('Vous propose un échange'), findsOneWidget);
    },
  );

  testWidgets('TradeCardWidget displays trade information for a send trade', (
    WidgetTester tester,
  ) async {
    final mockTrade = Trade(
      id: 'tradeId',
      senderId: UserProfile(
        id: 'senderId',
        email: 'sender@test.com',
        pseudo: 'Sender',
        createdAt: DateTime.now(),
      ),
      receiveId: UserProfile(
        id: 'receiverId',
        email: 'receiver@test.com',
        pseudo: 'Receiver',
        createdAt: DateTime.now(),
      ),
      status: TradeStatus.waiting,
      timestamp: DateTime.now(),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TradeCardRequestWidget(
            trade: mockTrade,
            onTap: () {},
            isTradeReceived: false,
          ),
        ),
      ),
    );

    expect(find.text('Receiver'), findsOneWidget);
    expect(find.text("A reçu votre demande d'échange"), findsOneWidget);
  });
}
