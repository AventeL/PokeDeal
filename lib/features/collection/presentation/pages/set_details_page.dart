import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pokedeal/features/collection/domain/models/card/pokemon_card_brief.dart';
import 'package:pokedeal/features/collection/domain/models/pokemon_set.dart';
import 'package:pokedeal/features/collection/domain/models/pokemon_set_brief.dart';
import 'package:pokedeal/features/collection/presentation/bloc/card_bloc/collection_pokemon_card_bloc.dart';
import 'package:pokedeal/features/collection/presentation/bloc/set_bloc/collection_pokemon_set_bloc.dart';
import 'package:pokedeal/features/collection/presentation/widgets/pokemon_card_unavailable_widget.dart';
import 'package:pokedeal/features/collection/presentation/widgets/pokemon_card_widget.dart';

class SetDetailsPage extends StatefulWidget {
  final PokemonSetBrief setInfo;

  const SetDetailsPage({super.key, required this.setInfo});

  @override
  State<SetDetailsPage> createState() => _SetDetailsPageState();
}

class _SetDetailsPageState extends State<SetDetailsPage> {
  late PokemonSet setWithCards;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    context.read<CollectionPokemonSetBloc>().add(
      CollectionPokemonGetSetWithCardsEvent(setId: widget.setInfo.id),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.setInfo.name)),
      body: BlocConsumer<CollectionPokemonSetBloc, CollectionPokemonSetState>(
        listener: (context, state) {
          if (state is CollectionPokemonSetWithCardsGet) {
            setWithCards = state.setWithCards;
          } else if (state is CollectionPokemonSetError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is CollectionPokemonSetLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CollectionPokemonSetError) {
            return Center(child: Text(state.message));
          }
          if (state is CollectionPokemonSetWithCardsGet) {
            setWithCards = state.setWithCards;
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

            return Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 2 / 3,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: setWithCards.cards.length,
                      itemBuilder: (context, index) {
                        PokemonCardBrief card = setWithCards.cards[index];

                        if (card.image == null) {
                          return PokemonCardUnavailableWidget(
                            card: card,
                            totalCard: setWithCards.cards.length,
                            onTap:
                                () => navigateToCardPage(
                                  cardId: card.id,
                                  cardBrief: card,
                                ),
                          );
                        }

                        return PokemonCardWidget(
                          cardUrl: card.image!,
                          onTap:
                              () => navigateToCardPage(
                                cardId: card.id,
                                cardBrief: card,
                              ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          }
          return const Center(child: Text('Aucune données à afficher'));
        },
      ),
    );
  }

  void navigateToCardPage({
    required String cardId,
    required PokemonCardBrief cardBrief,
  }) {
    context.read<CollectionPokemonCardBloc>().add(
      CollectionPokemonGetCardEvent(cardId: cardId),
    );
    context.push(
      '/card_details',
      extra: {'cardId': cardId, 'cardBrief': cardBrief},
    );
  }
}
