import 'package:flutter/material.dart';
import 'package:pokedeal/features/authentication/presentation/pages/authentication_page.dart';
import 'package:pokedeal/features/home/presentation/pages/home_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthenticationGate extends StatelessWidget {
  const AuthenticationGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder(
          stream: Supabase.instance.client.auth.onAuthStateChange,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final session = snapshot.hasData ? snapshot.data!.session : null;

            if (session != null) {
              return const HomePage();
            } else {
              return AuthenticationPage();
            }
          },
        ),
      ),
    );
  }
}
