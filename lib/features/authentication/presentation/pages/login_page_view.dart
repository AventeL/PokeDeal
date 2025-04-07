import 'package:flutter/material.dart';
import 'package:pokedeal/core/widgets/empty_space.dart';

class LoginPageView extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const LoginPageView({
    super.key,
    required this.emailController,
    required this.passwordController,
  });

  @override
  State<LoginPageView> createState() => _LoginPageViewState();
}

class _LoginPageViewState extends State<LoginPageView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16.0,
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
              "Ou connectez-vous avec",
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
        Text('Mot de passe', style: Theme.of(context).textTheme.titleMedium),
        TextField(
          key: const Key('passwordField'),
          controller: widget.passwordController,
          decoration: InputDecoration(
            labelText: 'Votre mot de passe',
            border: OutlineInputBorder(),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              print("Mot de passe oublié cliqué !");
            },
            child: const Text(
              'Mot de passe oublié',
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ),
        Spacer(),
      ],
    );
  }
}
