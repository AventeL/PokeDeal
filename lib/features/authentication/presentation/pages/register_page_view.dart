import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pokedeal/core/validator/email_validator.dart';
import 'package:pokedeal/core/validator/password_validator.dart';
import 'package:pokedeal/core/widgets/empty_space.dart';

class RegisterPageView extends StatefulWidget {
  const RegisterPageView({super.key});

  @override
  State<RegisterPageView> createState() => _RegisterPageViewState();
}

class _RegisterPageViewState extends State<RegisterPageView> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Form(
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
                  TextFormField(
                    key: const Key('confirmPasswordField'),
                    controller: confirmPasswordController,
                    validator: PasswordValidator.validate,
                    decoration: InputDecoration(
                      labelText: 'Confirmer le mot de passe',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            key: const Key('registerButton'),
            onPressed: onRegister,
            child: const Text('S\'inscrire'),
          ),
        ),
      ],
    );
  }

  void onRegister() {
    if (formKey.currentState!.validate()) {
      String email = emailController.text;
      String password = passwordController.text;
      String confirmPassword = confirmPasswordController.text;
      if (password != confirmPassword) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Passwords do not match')));
      } else {
        context.go(
          '/get_info_profile',
          extra: {'email': email, 'password': password},
        );
      }
    }
  }
}
