import 'package:pokedeal/features/authentication/domain/models/user_profile.dart';

abstract class IAuthenticationDataSource {
  Future<UserProfile> signInWithEmail(String email, String password);

  Future<UserProfile> signUpWithEmail(
    String email,
    String password,
    String pseudo,
  );

  Future<UserProfile?> getUserProfile();

  Future<void> signOut();
}
