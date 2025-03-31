import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pokedeal/core/validator/pseudo_validator.dart';
import 'package:pokedeal/features/authentication/presentation/bloc/authentication_bloc.dart';

class GetMoreInfoProfilePage extends StatefulWidget {
  final String email;
  final String password;

  const GetMoreInfoProfilePage({
    super.key,
    required this.email,
    required this.password,
  });

  @override
  State<GetMoreInfoProfilePage> createState() => _GetMoreInfoProfilePageState();
}

class _GetMoreInfoProfilePageState extends State<GetMoreInfoProfilePage> {
  final TextEditingController pseudoController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          if (state is AuthenticationAuthenticated) {
            context.go('/');
          }
          if (state is AuthenticationError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is AuthenticationLoading) {
            return Center(child: const CircularProgressIndicator());
          }

          return SafeArea(
            child: Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      children: [
                        TextFormField(
                          key: Key('pseudoField'),
                          controller: pseudoController,
                          validator: PseudoValidator.validate,
                          decoration: InputDecoration(labelText: 'Pseudo'),
                        ),
                      ],
                    ),
                  ),
                  FloatingActionButton(
                    onPressed: () => onRegister(context),
                    child: Text('Valider'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void onRegister(BuildContext context) {
    if (formKey.currentState!.validate()) {
      String pseudo = pseudoController.text;
      context.read<AuthenticationBloc>().add(
        AuthenticationEventSignUpWithEmail(
          widget.email,
          widget.password,
          pseudo,
        ),
      );
    }
  }
}
