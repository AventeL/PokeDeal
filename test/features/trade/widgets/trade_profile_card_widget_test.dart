import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pokedeal/features/authentication/domain/models/user_profile.dart';
import 'package:pokedeal/features/trade/domain/models/userStats.dart';
import 'package:pokedeal/features/trade/presentation/widgets/trade_profile_card_widget.dart';

void main() {
  testWidgets('TradeProfileCardWidget displays user information', (
    WidgetTester tester,
  ) async {
    final mockUserStats = Userstats(
      user: UserProfile(
        id: '1',
        pseudo: 'TestUser',
        email: 'testuser@test.com',
        createdAt: DateTime.now(),
      ),
      nbCards: 50,
      nbExchanges: 10,
    );

    bool wasTapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TradeProfileCardWidget(
            userProfile: mockUserStats,
            onTap: () {
              wasTapped = true;
            },
          ),
        ),
      ),
    );

    expect(find.text('TestUser'), findsOneWidget);

    expect(find.text('50 cartes, 10 échanges'), findsOneWidget);

    await tester.tap(find.byType(TradeProfileCardWidget));
    await tester.pumpAndSettle();

    expect(wasTapped, isTrue);
  });
}
