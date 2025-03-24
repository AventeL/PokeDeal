import 'package:flutter/material.dart';
import 'package:pokedeal/features/Authentication/presentation/pages/login_page_view.dart';
import 'package:pokedeal/features/Authentication/presentation/widgets/login_button_widget.dart';

class AuthenticationPage extends StatelessWidget {
  const AuthenticationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Text('PokeDeal', textAlign: TextAlign.center),
            const LoginPageView(),
            LoginButtonWidget(onPressed: () {}, label: "Se Connecter"),
          ],
        ),
      ),
    );
  }
}
