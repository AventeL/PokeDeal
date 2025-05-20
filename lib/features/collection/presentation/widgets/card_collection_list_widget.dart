import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedeal/features/collection/domain/models/card/user_card_collection.dart';
import 'package:pokedeal/features/collection/domain/models/enum/variant_value.dart';
import 'package:pokedeal/features/collection/presentation/bloc/user_collection/user_collection_bloc.dart';
import 'package:pokedeal/features/collection/presentation/widgets/sheet_delete_card_to_collection.dart';

import '../../../../core/di/injection_container.dart';
import '../../../authentication/domain/repository/authentication_repository.dart';
import '../bloc/card_bloc/collection_pokemon_card_bloc.dart';

class CardCollectionListWidget extends StatefulWidget {
  final String userId;
  final String cardId;

  const CardCollectionListWidget({
    super.key,
    required this.userId,
    required this.cardId,
  });

  @override
  State<CardCollectionListWidget> createState() =>
      _CardCollectionListWidgetState();
}

class _CardCollectionListWidgetState extends State<CardCollectionListWidget> {
  @override
  void initState() {
    super.initState();
    context.read<UserCollectionBloc>().add(
      UserCollectionLoadCardEvent(userId: widget.userId, cardId: widget.cardId),
    );
  }

  List<UserCardCollection> userCardsCollection = [];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserCollectionBloc, UserCollectionState>(
      listener: (context, state) {
        if (state is UserCollectionError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error: ${state.message}')));
        }
        if (state is UserCollectionStateCardAdded) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Carte ajoutée à la collection')),
          );
        }
        if (state is UserCollectionCardLoaded) {
          userCardsCollection = state.userCardsCollection;
        }
      },
      builder: (context, state) {
        if (state is UserCollectionLoading) {
          return const Center(child: LinearProgressIndicator());
        }

        if (state is UserCollectionError) {
          return Center(child: Text('Error: ${state.message}'));
        }

        if (userCardsCollection.isEmpty) {
          return const Center(
            child: Text('Aucune carte dans votre collection'),
          );
        }

        return Expanded(
          child: ListView.builder(
            itemCount: userCardsCollection.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final card = userCardsCollection[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    final collectionPokemonCardState =
                        context.read<CollectionPokemonCardBloc>().state;

                    final isCurrentUser =
                        widget.userId ==
                        getIt<AuthenticationRepository>().userProfile!.id;

                    if (collectionPokemonCardState
                            is CollectionPokemonCardsGet &&
                        isCurrentUser) {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return SheetDeleteCardToCollection(
                            card: collectionPokemonCardState.card,
                            variant: card.variant,
                            onConfirm: (quantity, variant) {
                              context.read<UserCollectionBloc>().add(
                                UserCollectionDeleteCardEvent(
                                  setId:
                                      collectionPokemonCardState
                                          .card
                                          .setBrief
                                          .id,
                                  pokemonCardId:
                                      collectionPokemonCardState.card.id,
                                  quantity: quantity,
                                  variant: variant,
                                ),
                              );
                            },
                          );
                        },
                      );
                    }
                  },
                  child: ListTile(
                    tileColor: Theme.of(context).colorScheme.tertiaryContainer,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(card.variant.getFullName),
                        Text(card.quantity.toString()),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
