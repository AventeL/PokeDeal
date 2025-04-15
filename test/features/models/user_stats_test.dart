import 'package:flutter_test/flutter_test.dart';
import 'package:pokedeal/features/authentication/domain/models/user_profile.dart';
import 'package:pokedeal/features/trade/domain/models/user_stats.dart';

void main() {
  test('UserStats has a constructor', () {
    DateTime now = DateTime.now();
    UserProfile user = UserProfile(
      id: 'userId',
      email: 'user@test.com',
      pseudo: 'User',
      createdAt: now,
    );

    UserStats userStats = UserStats(user: user, nbCards: 450, nbExchanges: 500);

    expect(userStats.user, user);
    expect(userStats.nbCards, 450);
    expect(userStats.nbExchanges, 500);
  });
}
