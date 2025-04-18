import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pokedeal/core/di/injection_container.dart';
import 'package:pokedeal/core/widgets/empty_space.dart';
import 'package:pokedeal/features/authentication/domain/repository/authentication_repository.dart';
import 'package:pokedeal/features/profile/presentation/bloc/profile_bloc.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<ProfileBloc>(context).add(
      ProfileLoadEvent(
        userId: getIt<AuthenticationRepository>().userProfile!.id,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is ProfileLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is ProfileLoaded) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    8.height,
                    CircleAvatar(
                      radius: 50,
                      child: Icon(
                        Icons.account_circle,
                        size: 100,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    8.height,
                    Text(
                      state.userProfile.pseudo,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    8.height,
                    Text(
                      "Membre depuis le ${DateFormat('dd/MM/yyyy').format(state.userProfile.createdAt)}",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    24.height,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStatWidget(label: "Cartes", number: "238"),
                        _buildStatWidget(label: "Echanges", number: "12"),
                        _buildStatWidget(label: "Séries", number: "3"),
                      ],
                    ),
                    32.height,
                    Text(
                      "Collection",
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ],
                ),
              ),
            );
          } else if (state is ProfileError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return Center(child: Text('Impossible d\'accéder au profil'));
        },
      ),
    );
  }

  _buildStatWidget({required String label, required String number}) {
    return Column(
      children: [
        Text(number, style: Theme.of(context).textTheme.titleLarge),
        4.height,
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w300),
        ),
      ],
    );
  }
}
