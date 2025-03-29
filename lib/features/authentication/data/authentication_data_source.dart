import 'package:supabase_flutter/supabase_flutter.dart';

class AuthenticationDataSource {
  final SupabaseClient supabaseClient = Supabase.instance.client;

  Future<AuthResponse> signInWithEmail(String email, String password) async {
    return await supabaseClient.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<AuthResponse> signUpWithEmail(String email, String password) async {
    return await supabaseClient.auth.signUp(email: email, password: password);
  }

  Future<void> signOut() async {
    await supabaseClient.auth.signOut();
  }

  String getCurrentUserEmail() {
    final user = supabaseClient.auth.currentUser;
    if (user != null) {
      return user.email!;
    } else {
      throw Exception("No user is currently signed in.");
    }
  }
}
