import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pokedeal/core/di/injection_container.dart';
import 'package:pokedeal/core/widgets/empty_space.dart';
import 'package:pokedeal/features/authentication/domain/repository/authentication_repository.dart';
import 'package:pokedeal/features/collection/domain/models/card/pokemon_card_brief.dart';
import 'package:pokedeal/features/collection/domain/models/card/user_card_collection.dart';
import 'package:pokedeal/features/collection/domain/models/enum/variant_value.dart';
import 'package:pokedeal/features/collection/domain/models/pokemon_set.dart';
import 'package:pokedeal/features/collection/domain/models/pokemon_set_brief.dart';
import 'package:pokedeal/features/collection/presentation/bloc/card_bloc/collection_pokemon_card_bloc.dart';
import 'package:pokedeal/features/collection/presentation/bloc/set_bloc/collection_pokemon_set_bloc.dart';
import 'package:pokedeal/features/collection/presentation/bloc/user_collection/user_collection_bloc.dart';
import 'package:pokedeal/features/collection/presentation/widgets/bottom_sheet_add_card_to_collection.dart';
import 'package:pokedeal/features/collection/presentation/widgets/card_list_widget.dart';

class SetDetailsPage extends StatefulWidget {
  final PokemonSetBrief setInfo;

  const SetDetailsPage({super.key, required this.setInfo});

  @override
  State<SetDetailsPage> createState() => _SetDetailsPageState();
}

class _SetDetailsPageState extends State<SetDetailsPage> {
  late PokemonSet setWithCards;
  List<UserCardCollection> userCardsCollection = [];

  @override
  void initState() {
    super.initState();
    context.read<CollectionPokemonSetBloc>().add(
      CollectionPokemonGetSetWithCardsEvent(setId: widget.setInfo.id),
    );
    loadUserCardsCollection();
  }

  void loadUserCardsCollection() {
    context.read<UserCollectionBloc>().add(
      UserCollectionLoadSetEvent(
        userId: getIt<AuthenticationRepository>().userProfile!.id,
        setId: widget.setInfo.id,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.setInfo.name)),
      body: BlocConsumer<UserCollectionBloc, UserCollectionState>(
        listener: (context, userCollectionState) {
          if (userCollectionState is UserCollectionError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${userCollectionState.message}')),
            );
          }
          if (userCollectionState is UserCollectionStateCardAdded) {
            loadUserCardsCollection();
          }
          if (userCollectionState is UserCollectionSetLoaded) {
            userCardsCollection = userCollectionState.userCardsCollection;
          }
        },
        builder: (context, userCollectionState) {
          return BlocConsumer<
            CollectionPokemonSetBloc,
            CollectionPokemonSetState
          >(
            listener: (context, collectionPokemonSetState) {
              if (collectionPokemonSetState
                  is CollectionPokemonSetWithCardsGet) {
                setWithCards = collectionPokemonSetState.setWithCards;
              } else if (collectionPokemonSetState
                  is CollectionPokemonSetError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(collectionPokemonSetState.message)),
                );
              }
            },
            builder: (context, collectionPokemonSetState) {
              if (collectionPokemonSetState is CollectionPokemonSetLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (collectionPokemonSetState
                  is CollectionPokemonSetError) {
                return Center(child: Text(collectionPokemonSetState.message));
              }
              if (collectionPokemonSetState
                  is CollectionPokemonSetWithCardsGet) {
                setWithCards = collectionPokemonSetState.setWithCards;
                if (setWithCards.cards.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        textAlign: TextAlign.center,
                        'Les cartes pour ${widget.setInfo.name} ne sont pas encore disponibles',
                      ),
                    ),
                  );
                }

                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        8.height,
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).colorScheme.tertiaryContainer,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Progression',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${getTotalOfUserCards()}/${setWithCards.cards.length}',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                              8.height,
                              LinearProgressIndicator(
                                value:
                                    getTotalOfUserCards() /
                                    setWithCards.cards.length,
                                backgroundColor: Colors.grey[300],
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ],
                          ),
                        ),
                        16.height,
                        Text(
                          "Les cartes",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        16.height,
                        CardListWidget(
                          showOwnIndicator: true,
                          cards: setWithCards.cards,
                          userCardsCollection: userCardsCollection,
                          onLongPressCard: (String cardId) {
                            onAddToCollection(context, cardId);
                          },
                          onTapCard: (String cardId) {
                            navigateToCardPage(
                              cardId: cardId,
                              cardBrief: setWithCards.cards.firstWhere(
                                (card) => card.id == cardId,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }
              return const Center(child: Text('Aucune données à afficher'));
            },
          );
        },
      ),
    );
  }

  void navigateToCardPage({
    required String cardId,
    required PokemonCardBrief cardBrief,
  }) {
    context.push(
      '/card_details',
      extra: {
        'cardId': cardId,
        'cardBrief': cardBrief,
        'userId': getIt<AuthenticationRepository>().userProfile!.id,
      },
    );
  }

  void onAddToCollection(BuildContext context, String cardId) {
    context.read<CollectionPokemonCardBloc>().add(
      CollectionPokemonGetCardEvent(cardId: cardId),
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder:
          (context) => Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: BlocConsumer<
              CollectionPokemonCardBloc,
              CollectionPokemonCardState
            >(
              listener: (context, state) {
                if (state is CollectionPokemonCardError) {
                  Navigator.pop(context);
                }
              },
              builder: (context, state) {
                if (state is CollectionPokemonCardLoading) {
                  return SizedBox(
                    height: 100,
                    child: const Center(child: CircularProgressIndicator()),
                  );
                }
                if (state is CollectionPokemonCardsGet) {
                  return BottomSheetAddCardToCollection(
                    card: state.card,
                    onConfirm: (int quantity, VariantValue variant) {
                      context.read<UserCollectionBloc>().add(
                        UserCollectionAddCardEvent(
                          pokemonCardId: state.card.id,
                          quantity: quantity,
                          variant: variant,
                          setId: state.card.setBrief.id,
                        ),
                      );
                    },
                  );
                }

                return const Center(child: Text('Aucune données à afficher'));
              },
            ),
          ),
    );
  }

  int getTotalOfUserCards() {
    return userCardsCollection.map((element) => element.cardId).toSet().length;
  }
}
