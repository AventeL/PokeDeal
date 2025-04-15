import 'package:pokedeal/features/authentication/domain/models/user_profile.dart';

class Userstats {
  final UserProfile user;
  final int nbCards;
  final int nbExchanges;

  Userstats({
    required this.user,
    required this.nbCards,
    required this.nbExchanges,
  });
}
