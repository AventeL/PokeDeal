import 'package:pokedeal/features/Authentication/data/authentication_data_source_interface.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthenticationRepository {
  final IAuthenticationDataSource authenticationDataSource;

  AuthenticationRepository({required this.authenticationDataSource});

  Future<AuthResponse> signInWithEmail(String email, String password) async {
    return await authenticationDataSource.signInWithEmail(email, password);
  }

  Future<AuthResponse> signUpWithEmail(String email, String password) async {
    return await authenticationDataSource.signUpWithEmail(email, password);
  }

  Future<void> signOut() async {
    await authenticationDataSource.signOut();
  }
}
