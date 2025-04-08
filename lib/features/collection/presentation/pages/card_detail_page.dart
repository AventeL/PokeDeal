import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedeal/core/helper/pokemon_card_image_helper.dart';
import 'package:pokedeal/features/collection/domain/models/card/pokemon_card_brief.dart';
import 'package:pokedeal/features/collection/presentation/bloc/card_bloc/collection_pokemon_card_bloc.dart';

class CardDetailPage extends StatelessWidget {
  final String cardId;
  final PokemonCardBrief cardBrief;

  const CardDetailPage({
    super.key,
    required this.cardId,
    required this.cardBrief,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(cardBrief.name)),
      floatingActionButton: FloatingActionButton(
        onPressed: onAddToCollection,
        child: const Icon(Icons.add),
      ),
      body: BlocConsumer<CollectionPokemonCardBloc, CollectionPokemonCardState>(
        listener: (context, state) {
          if (state is CollectionPokemonCardError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Error: ${state.message}')));
          }
        },
        builder: (context, state) {
          if (state is CollectionPokemonCardLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is CollectionPokemonCardError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          if (state is CollectionPokemonCardsGet) {
            return Column(
              children: [
                if (state.card.image != null)
                  CachedNetworkImage(
                    imageUrl: PokemonCardImageHelper.gererateImageUrl(
                      state.card.image!,
                      quality: PokemonCardQuality.high,
                    ),
                  ),
                Text('Card Details Loaded ${state.card.category}'),
              ],
            );
          }

          return Center(child: Text('Carte indisponible'));
        },
      ),
    );
  }

  void onAddToCollection() {
    //@todo ouvrir une bottomsheet
  }
}
