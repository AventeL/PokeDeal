import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedeal/features/Authentication/presentation/bloc/authentication_bloc.dart';
import 'package:pokedeal/features/home/presentation/widgets/custom_bottom_navigation_bar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Page')),
      body: Column(
        children: [
          Center(
            child: Text(
              'Welcome to the Home Page! ${Supabase.instance.client.auth.currentSession?.user.email ?? ''}',
            ),
          ),
          FloatingActionButton(
            onPressed: () {
              context.read<AuthenticationBloc>().add(
                AuthenticationEventSignOut(),
              );
            },
            child: const Icon(Icons.logout),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
}
