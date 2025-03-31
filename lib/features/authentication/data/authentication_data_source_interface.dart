import 'package:supabase_flutter/supabase_flutter.dart';

abstract class IAuthenticationDataSource {
  Future<AuthResponse> signInWithEmail(String email, String password);

  Future<AuthResponse> signUpWithEmail(String email, String password);

  Future<void> signOut();

  String getCurrentUserEmail();
}
