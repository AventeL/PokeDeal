import 'package:pokedeal/features/authentication/domain/models/user_profile.dart';

class UserProfileWithStats {
  final UserProfile user;
  final int nbcards;
  final int nbexchange;
  final int nbseries;

  UserProfileWithStats({
    required this.user,
    required this.nbcards,
    required this.nbexchange,
    required this.nbseries,
  });
}
