import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pokedeal/core/di/injection_container.dart';
import 'package:pokedeal/core/widgets/empty_space.dart';
import 'package:pokedeal/features/authentication/domain/models/user_profile.dart';
import 'package:pokedeal/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:pokedeal/shared/widgets/custom_large_button.dart';

import '../../../../core/validator/email_validator.dart';
import '../../../../core/validator/password_validator.dart';
import '../../../../core/validator/pseudo_validator.dart';
import '../../../authentication/domain/repository/authentication_repository.dart';

class ModifyProfilePage extends StatefulWidget {
  const ModifyProfilePage({super.key});

  @override
  State<ModifyProfilePage> createState() => _ModifyProfilePageState();
}

class _ModifyProfilePageState extends State<ModifyProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _pseudoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isPasswordVisible = false;

  @override
  void initState() {
    _pseudoController.text =
        getIt<AuthenticationRepository>().userProfile!.pseudo;
    _emailController.text =
        getIt<AuthenticationRepository>().userProfile!.email;
    super.initState();
  }

  @override
  void dispose() {
    _pseudoController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void saveProfile() {
    if (_formKey.currentState!.validate()) {
      context.read<ProfileBloc>().add(
        ProfileUpdateEvent(
          user: UserProfile(
            id: getIt<AuthenticationRepository>().userProfile!.id,
            email: _emailController.text,
            pseudo: _pseudoController.text,
            createdAt: DateTime.now(),
          ),
          currentUser: getIt<AuthenticationRepository>().userProfile!,
          password: _passwordController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Modifier le profil')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: GestureDetector(
                          onTap: () {},
                          child: CircleAvatar(
                            radius: 50,
                            child: Icon(
                              Icons.account_circle,
                              size: 100,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        ),
                      ),
                      16.height,
                      Text(
                        'Pseudo',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      TextFormField(
                        key: Key('pseudoField'),
                        controller: _pseudoController,
                        validator: PseudoValidator.validate,
                      ),
                      16.height,
                      Text(
                        'Email',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      TextFormField(
                        key: const Key('emailField'),
                        controller: _emailController,
                        validator: EmailValidator.validate,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                      16.height,
                      Text(
                        'Mot de passe',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      TextFormField(
                        key: const Key('passwordField'),
                        controller: _passwordController,
                        obscureText: !isPasswordVisible,
                        validator: PasswordValidator.validate,
                        decoration: InputDecoration(
                          labelText: 'Mot de passe',
                          border: OutlineInputBorder(),
                          suffixIconColor:
                              Theme.of(context).colorScheme.primary,
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
                      32.height,
                      CustomLargeButton(
                        onPressed: () => {context.push("/modify_password")},
                        label: "Modifier le mot de passe",
                        bgColor: Theme.of(context).colorScheme.tertiary,
                      ),
                    ],
                  ),
                ),
              ),
              16.height,
              Center(
                child: CustomLargeButton(
                  onPressed: saveProfile,
                  label: 'Enregistrer',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
