import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pokedeal/core/widgets/empty_space.dart';
import 'package:pokedeal/features/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:pokedeal/shared/widgets/custom_large_button.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Paramètres")),
      body: BlocConsumer<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          if (state is AuthenticationError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
          if (state is AuthenticationUnauthenticated) {
            context.go('/authentication');
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              children: [
                16.height,
                CustomLargeButton(
                  onPressed: () => onDisconnect(context),
                  label: 'Déconnexion',
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void onDisconnect(BuildContext context) {
    BlocProvider.of<AuthenticationBloc>(
      context,
    ).add(AuthenticationEventSignOut());
  }
}
