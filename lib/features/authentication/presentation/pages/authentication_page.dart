import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
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
  late ValueNotifier<int> _tabIndexNotifier;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _tabIndexNotifier = ValueNotifier<int>(_tabController.index);

    _tabController.addListener(() {
      if (_tabController.index != _tabIndexNotifier.value) {
        _tabIndexNotifier.value = _tabController.index;
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _tabIndexNotifier.dispose();
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
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 250,
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        Text(
                          "PokeDeal",
                          style: Theme.of(context).textTheme.headlineLarge
                              ?.copyWith(color: Colors.white),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "Gérez et échangez votre collection de cartes\nPokemon !",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(20),
                    child:
                        BlocConsumer<AuthenticationBloc, AuthenticationState>(
                          listener: (context, state) {
                            if (state is AuthenticationError && mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(state.message)),
                              );
                            }
                          },
                          builder: (context, state) {
                            if (state is AuthenticationLoading) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ValueListenableBuilder<int>(
              valueListenable: _tabIndexNotifier,
              builder: (context, index, _) {
                return ElevatedButton(
                  onPressed: () {
                    String email = emailController.text;
                    String password = passwordController.text;
                    if (index == 0) {
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
                      if (email.isEmpty ||
                          password.isEmpty ||
                          confirmPassword.isEmpty) {
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
                            content: Text(
                              'Les mots de passe ne correspondent pas',
                            ),
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
                    index == 0 ? "Se connecter" : "S'inscrire",
                    style: TextStyle(color: Colors.white),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
