import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pokedeal/core/widgets/empty_space.dart';
import 'package:pokedeal/features/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:pokedeal/features/authentication/presentation/pages/register_page_view.dart';

import 'login_page_view.dart';

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({super.key});

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _onLogin(String email, String password) {
    context.read<AuthenticationBloc>().add(
      AuthenticationEventSignInWithEmail(email, password),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(20),
                    ),
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).colorScheme.secondary,
                        Theme.of(context).colorScheme.primary,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top,
                      bottom: 40,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        20.height,
                        Text(
                          "PokeDeal",
                          style: Theme.of(context).textTheme.headlineLarge
                              ?.copyWith(color: Colors.white),
                        ),
                        20.height,
                        Text(
                          "Gérez et échangez votre collection de cartes\nPokemon !",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(20),
                  child: BlocConsumer<AuthenticationBloc, AuthenticationState>(
                    listener: (context, state) {
                      if (state is AuthenticationError && mounted) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(state.message)));
                      }
                    },
                    builder: (context, state) {
                      if (state is AuthenticationLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      return Column(
                        children: [
                          TabBar(
                            controller: _tabController,
                            indicatorSize: TabBarIndicatorSize.tab,
                            tabs: const [
                              Tab(text: 'Connexion'),
                              Tab(text: 'Inscription'),
                            ],
                            indicatorPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                            ),
                            dividerColor: Colors.transparent,
                          ),
                          SizedBox(
                            height: 500,
                            child: TabBarView(
                              controller: _tabController,
                              children: [
                                LoginPageView(
                                  emailController: emailController,
                                  passwordController: passwordController,
                                ),
                                RegisterPageView(
                                  emailController: emailController,
                                  passwordController: passwordController,
                                  confirmPasswordController:
                                      confirmPasswordController,
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        buildButton(),
      ],
    );
  }

  Widget buildButton() {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom:
            MediaQuery.of(context).padding.bottom == 0
                ? 16
                : MediaQuery.of(context).padding.bottom,
        top: 16,
      ),
      child: ElevatedButton(
        onPressed: () {
          String email = emailController.text;
          String password = passwordController.text;
          if (_tabController.index == 0) {
            if (email.isEmpty || password.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Veuillez remplir tous les champs'),
                ),
              );
              return;
            }
            _onLogin(email, password);
          } else {
            String confirmPassword = confirmPasswordController.text;
            if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Veuillez remplir tous les champs'),
                ),
              );
              return;
            }
            if (password != confirmPassword) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Les mots de passe ne correspondent pas'),
                ),
              );
              return;
            }
            context.go(
              '/get_info_profile',
              extra: {'email': email, 'password': password},
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          _tabController.index == 0 ? "Se connecter" : "S'inscrire",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
