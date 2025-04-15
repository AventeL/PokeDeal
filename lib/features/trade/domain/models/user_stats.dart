import 'package:pokedeal/features/authentication/domain/models/user_profile.dart';

class UserStats {
  final UserProfile user;
  final int nbCards;
  final int nbExchanges;

  UserStats({
    required this.user,
    required this.nbCards,
    required this.nbExchanges,
  });
}
