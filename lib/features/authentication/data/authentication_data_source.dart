import 'package:pokedeal/features/Authentication/data/authentication_data_source_interface.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthenticationDataSource implements IAuthenticationDataSource {
  final SupabaseClient supabaseClient = Supabase.instance.client;

  @override
  Future<AuthResponse> signInWithEmail(String email, String password) async {
    return await supabaseClient.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<AuthResponse> signUpWithEmail(String email, String password) async {
    return await supabaseClient.auth.signUp(email: email, password: password);
  }

  @override
  Future<void> signOut() async {
    await supabaseClient.auth.signOut();
  }

  @override
  String getCurrentUserEmail() {
    final user = supabaseClient.auth.currentUser;
    if (user != null) {
      return user.email!;
    } else {
      throw Exception("No user is currently signed in.");
    }
  }
}
