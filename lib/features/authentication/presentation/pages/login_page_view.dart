import 'package:flutter/material.dart';
import 'package:pokedeal/core/validator/email_validator.dart';
import 'package:pokedeal/core/validator/password_validator.dart';
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
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isPasswordVisible = false;

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
        Form(
          key: formKey,
          child: Column(
            spacing: 16.0,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              16.height,
              Text('Email', style: Theme.of(context).textTheme.titleMedium),
              TextFormField(
                key: const Key('emailField'),
                controller: widget.emailController,
                validator: EmailValidator.validate,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              Text(
                'Mot de passe',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              TextFormField(
                key: const Key('passwordField'),
                controller: widget.passwordController,
                validator: PasswordValidator.validate,
                obscureText: !isPasswordVisible,
                decoration: InputDecoration(
                  labelText: 'Mot de passe',
                  border: OutlineInputBorder(),
                  suffixIconColor: Theme.of(context).colorScheme.primary,
                  suffixIcon: IconButton(
                    key: const Key('passwordVisibilityButton'),
                    onPressed: () {
                      setState(() {
                        isPasswordVisible = !isPasswordVisible;
                      });
                    },
                    icon: Icon(
                      isPasswordVisible
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
