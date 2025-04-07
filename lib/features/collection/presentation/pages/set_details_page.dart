import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedeal/features/collection/domain/models/pokemon_card.dart';
import 'package:pokedeal/features/collection/domain/models/pokemon_set.dart';
import 'package:pokedeal/features/collection/domain/models/pokemon_set_with_cards.dart';
import 'package:pokedeal/features/collection/presentation/bloc/set_bloc/collection_pokemon_set_bloc.dart';
import 'package:pokedeal/helper/pokemon_card_image_helper.dart';

class SetDetailsPage extends StatefulWidget {
  final PokemonSet setInfo;

  const SetDetailsPage({super.key, required this.setInfo});

  @override
  State<SetDetailsPage> createState() => _SetDetailsPageState();
}

class _SetDetailsPageState extends State<SetDetailsPage> {
  late PokemonSetWithCards setWithCards;
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
                        PokemonCard card = setWithCards.cards[index];

                        if (card.image == null) {
                          return const Center(
                            child: Text('Image not available'),
                          );
                        }

                        return CachedNetworkImage(
                          imageUrl: PokemonCardImageHelper.gererateImageUrl(
                            card.image!,
                            quality: PokemonCardQuality.low,
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
}
