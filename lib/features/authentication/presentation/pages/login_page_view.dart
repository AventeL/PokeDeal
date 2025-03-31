import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedeal/core/validator/email_validator.dart';
import 'package:pokedeal/core/validator/password_validator.dart';
import 'package:pokedeal/core/widgets/empty_space.dart';
import 'package:pokedeal/features/authentication/presentation/bloc/authentication_bloc.dart';

class LoginPageView extends StatefulWidget {
  const LoginPageView({super.key});

  @override
  State<LoginPageView> createState() => _LoginPageViewState();
}

class _LoginPageViewState extends State<LoginPageView> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        spacing: 16.0,
        children: [
          16.height,
          TextFormField(
            key: const Key('emailField'),
            controller: emailController,
            validator: EmailValidator.validate,
            decoration: InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
            ),
          ),
          TextFormField(
            key: const Key('passwordField'),
            controller: passwordController,
            validator: PasswordValidator.validate,
            decoration: InputDecoration(
              labelText: 'Mot de passe',
              border: OutlineInputBorder(),
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              key: const Key('loginButton'),
              onPressed: onLogin,
              child: const Text('Se Connecter'),
            ),
          ),
        ],
      ),
    );
  }

  void onLogin() {
    if (formKey.currentState!.validate()) {
      final email = emailController.text;
      final password = passwordController.text;
      context.read<AuthenticationBloc>().add(
        AuthenticationEventSignInWithEmail(email, password),
      );
    }
  }
}
