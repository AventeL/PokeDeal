import 'package:pokedeal/features/authentication/data/authentication_data_source.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthenticationRepository {
  final AuthenticationDataSource authenticationDataSource;

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
