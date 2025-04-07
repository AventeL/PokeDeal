import 'package:flutter/material.dart';
import 'package:pokedeal/core/widgets/empty_space.dart';

class RegisterPageView extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  const RegisterPageView({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
  });

  @override
  State<RegisterPageView> createState() => _RegisterPageViewState();
}

class _RegisterPageViewState extends State<RegisterPageView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              spacing: 16.0,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                16.height,
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: Colors.grey,
                        thickness: 1,
                        indent: 10,
                        endIndent: 10,
                      ),
                    ),
                    Text(
                      "Ou inscrivez-vous avec",
                      style: TextStyle(color: Colors.grey),
                    ),
                    Expanded(
                      child: Divider(
                        color: Colors.grey,
                        thickness: 1,
                        indent: 10,
                        endIndent: 10,
                      ),
                    ),
                  ],
                ),
                Text('Email', style: Theme.of(context).textTheme.titleMedium),
                TextField(
                  key: const Key('emailField'),
                  controller: widget.emailController,
                  decoration: InputDecoration(
                    labelText: 'votre@email.com',
                    border: OutlineInputBorder(),
                  ),
                ),
                Text(
                  'Mot de passe',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                TextField(
                  key: const Key('passwordField'),
                  controller: widget.passwordController,
                  decoration: InputDecoration(
                    labelText: 'Votre mot de passe',
                    border: OutlineInputBorder(),
                  ),
                ),
                Text(
                  'Confirmez votre mot de passe',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                TextField(
                  key: const Key('confirmPasswordField'),
                  controller: widget.confirmPasswordController,
                  decoration: InputDecoration(
                    labelText: 'Votre mot de passe',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
