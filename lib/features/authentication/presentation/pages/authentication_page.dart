import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedeal/features/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:pokedeal/features/authentication/presentation/pages/login_page_view.dart';
import 'package:pokedeal/features/authentication/presentation/pages/register_page_view.dart';

class AuthenticationPage extends StatelessWidget {
  const AuthenticationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is AuthenticationError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        if (state is AuthenticationLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return SafeArea(
          child: DefaultTabController(
            length: 2,
            child: Column(
              children: const [
                TabBar(
                  tabs: [Tab(text: 'Connexion'), Tab(text: 'Inscription')],
                ),
                Expanded(
                  child: TabBarView(
                    children: [LoginPageView(), RegisterPageView()],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
