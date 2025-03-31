import 'package:pokedeal/features/authentication/data/authentication_data_source_interface.dart';
import 'package:pokedeal/features/authentication/domain/models/user_profile.dart';

class AuthenticationRepository {
  UserProfile? userProfile;
  final IAuthenticationDataSource authenticationDataSource;

  AuthenticationRepository({required this.authenticationDataSource});

  Future<UserProfile> signInWithEmail(String email, String password) async {
    UserProfile userProfile = await authenticationDataSource.signInWithEmail(
      email,
      password,
    );
    this.userProfile = userProfile;

    return userProfile;
  }

  Future<UserProfile> signUpWithEmail(
    String email,
    String password,
    String pseudo,
  ) async {
    UserProfile userProfile = await authenticationDataSource.signUpWithEmail(
      email,
      password,
      pseudo,
    );
    this.userProfile = userProfile;

    return userProfile;
  }

  Future<UserProfile?> getUserProfile() async {
    if (userProfile != null) {
      return userProfile;
    }

    UserProfile? userProfileFromSupabase =
        await authenticationDataSource.getUserProfile();
    userProfile = userProfileFromSupabase;
    return userProfileFromSupabase;
  }

  Future<void> signOut() async {
    await authenticationDataSource.signOut();
  }
}
