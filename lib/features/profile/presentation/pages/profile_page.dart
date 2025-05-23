import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pokedeal/core/di/injection_container.dart';
import 'package:pokedeal/core/widgets/empty_space.dart';
import 'package:pokedeal/features/authentication/domain/models/user_profile.dart';
import 'package:pokedeal/features/authentication/domain/repository/authentication_repository.dart';
import 'package:pokedeal/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:pokedeal/features/profile/presentation/widgets/user_collection_widget.dart';
import 'package:pokedeal/features/trade/domain/models/trade_request_data.dart';
import 'package:pokedeal/shared/widgets/custom_large_button.dart';

class ProfilePage extends StatefulWidget {
  final String? userId;
  final bool showBackButton;
  final bool showCollection;

  const ProfilePage({
    super.key,
    this.userId,
    this.showBackButton = true,
    this.showCollection = true,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    if (widget.userId != null) {
      BlocProvider.of<ProfileBloc>(
        context,
      ).add(ProfileLoadEvent(userId: widget.userId!));
    } else {
      BlocProvider.of<ProfileBloc>(context).add(
        ProfileLoadEvent(
          userId: getIt<AuthenticationRepository>().userProfile!.id,
        ),
      );
    }
  }

  @override
  void didUpdateWidget(covariant ProfilePage oldWidget) {
    BlocProvider.of<ProfileBloc>(context).add(
      ProfileLoadEvent(
        userId:
            widget.userId ?? getIt<AuthenticationRepository>().userProfile!.id,
      ),
    );
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.showBackButton ? AppBar() : null,
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
              child: SingleChildScrollView(
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
                      state.userProfile.user.pseudo,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    8.height,
                    Text(
                      "Membre depuis le ${DateFormat('dd/MM/yyyy').format(state.userProfile.user.createdAt)}",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    24.height,
                    if (state.userProfile.user.id !=
                        getIt<AuthenticationRepository>().userProfile!.id)
                      _buildAskTradeButton(),
                    8.height,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStatWidget(
                          label: "Cartes",
                          number: state.userProfile.nbcards.toString(),
                        ),
                        _buildStatWidget(
                          label: "Echanges",
                          number: state.userProfile.nbexchange.toString(),
                        ),
                        _buildStatWidget(
                          label: "Séries",
                          number: state.userProfile.nbseries.toString(),
                        ),
                      ],
                    ),
                    24.height,
                    _buildCollectionPart(state.userProfile.user),
                    32.height,
                    if (state.userProfile.user.id ==
                        getIt<AuthenticationRepository>().userProfile!.id)
                      CustomLargeButton(
                        onPressed: () => {context.push("/modify_profile")},
                        label: "Modifier",
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

  Widget _buildStatWidget({required String label, required String number}) {
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

  Widget _buildAskTradeButton() {
    return ElevatedButton(
      child: Text("Proposer un échange"),
      onPressed: () {
        context.push(
          "/trade_request",
          extra: {
            "otherUserTradeRequest": TradeRequestData(userId: widget.userId!),
          },
        );
      },
    );
  }

  Widget _buildCollectionPart(UserProfile user) {
    return Column(
      children: [
        32.height,
        Text("Collection", style: Theme.of(context).textTheme.headlineMedium),
        8.height,
        UserCollectionWidget(userId: user.id),
      ],
    );
  }
}
