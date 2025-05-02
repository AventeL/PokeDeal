import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedeal/core/validator/password_validator.dart';
import 'package:pokedeal/core/widgets/empty_space.dart';
import 'package:pokedeal/shared/widgets/custom_large_button.dart';

import '../../../../core/di/injection_container.dart';
import '../../../authentication/domain/repository/authentication_repository.dart';
import '../bloc/profile_bloc.dart';

class ModifyPasswordPage extends StatefulWidget {
  const ModifyPasswordPage({super.key});

  @override
  State<ModifyPasswordPage> createState() => _ModifyPasswordPageState();
}

class _ModifyPasswordPageState extends State<ModifyPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  bool isOldPasswordVisible = false;
  bool isNewPasswordVisible = false;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  void _savePassword() {
    if (_formKey.currentState!.validate()) {
      context.read<ProfileBloc>().add(
        ChangePasswordEvent(
          currentPassword: _oldPasswordController.text,
          newPassword: _newPasswordController.text,
          email: getIt<AuthenticationRepository>().userProfile!.email,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Modifier le mot de passe')),
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
                      Text(
                        'Ancien mot de passe',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      TextFormField(
                        controller: _oldPasswordController,
                        obscureText: !isOldPasswordVisible,
                        validator: PasswordValidator.validate,
                        decoration: InputDecoration(
                          labelText: 'Ancien mot de passe',
                          border: const OutlineInputBorder(),
                          suffixIconColor:
                              Theme.of(context).colorScheme.primary,
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                isOldPasswordVisible = !isOldPasswordVisible;
                              });
                            },
                            icon: Icon(
                              isOldPasswordVisible
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                          ),
                        ),
                      ),
                      16.height,
                      Text(
                        'Nouveau mot de passe',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      TextFormField(
                        controller: _newPasswordController,
                        obscureText: !isNewPasswordVisible,
                        validator: PasswordValidator.validate,
                        decoration: InputDecoration(
                          labelText: 'Nouveau mot de passe',
                          border: const OutlineInputBorder(),
                          suffixIconColor:
                              Theme.of(context).colorScheme.primary,
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                isNewPasswordVisible = !isNewPasswordVisible;
                              });
                            },
                            icon: Icon(
                              isNewPasswordVisible
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              CustomLargeButton(onPressed: _savePassword, label: 'Enregistrer'),
            ],
          ),
        ),
      ),
    );
  }
}
