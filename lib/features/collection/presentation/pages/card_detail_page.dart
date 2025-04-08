import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedeal/core/helper/pokemon_card_image_helper.dart';
import 'package:pokedeal/features/collection/domain/models/card/pokemon_card_brief.dart';
import 'package:pokedeal/features/collection/presentation/bloc/card_bloc/collection_pokemon_card_bloc.dart';

import '../widgets/pokemon_card_unavailable_widget.dart';

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
            return Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color:
                          Theme.of(context).brightness == Brightness.light
                              ? Colors.white
                              : Color(0xFF2C2C2C),
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          child:
                              state.card.image != null
                                  ? CachedNetworkImage(
                                    imageUrl:
                                        PokemonCardImageHelper.gererateImageUrl(
                                          state.card.image!,
                                          quality: PokemonCardQuality.high,
                                        ),
                                    height: 240,
                                    width: 150,
                                  )
                                  : Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8.0,
                                    ),
                                    child: PokemonCardUnavailableWidget(
                                      card: PokemonCardBrief(
                                        id: state.card.setBrief.id,
                                        localId: state.card.localId,
                                        name: state.card.setBrief.name,
                                      ),
                                      totalCard:
                                          state.card.setBrief.cardCount.total,
                                    ),
                                  ),
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  state.card.name,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium?.copyWith(
                                    color:
                                        Theme.of(context).brightness ==
                                                Brightness.light
                                            ? Colors.black
                                            : Colors.white,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(50),
                                        ),
                                      ),
                                      child: Text(
                                        '${state.card.localId}/${state.card.setBrief.cardCount.total}',
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(state.card.rarity ?? 'Inconnu'),
                                  ],
                                ),
                                Row(
                                  children: [
                                    state.card.setBrief.symbolUrl != null
                                        ? CachedNetworkImage(
                                          imageUrl:
                                              '${state.card.setBrief.symbolUrl!}.png',
                                          width: 30,
                                          height: 30,
                                          fit: BoxFit.cover,
                                        )
                                        : Image.asset(
                                          'assets/images/pokeball.png',
                                          width: 30,
                                          height: 30,
                                          fit: BoxFit.cover,
                                        ),
                                    const SizedBox(width: 8),
                                    Flexible(
                                      child: Text(
                                        state.card.setBrief.name,
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodyMedium?.copyWith(
                                          color:
                                              Theme.of(context).brightness ==
                                                      Brightness.light
                                                  ? Colors.black
                                                  : Colors.white,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.brush, size: 16),
                                    Text(state.card.illustrator ?? 'Inconnu'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
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
