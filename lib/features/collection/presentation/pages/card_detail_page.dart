import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedeal/core/helper/pokemon_card_image_helper.dart';
import 'package:pokedeal/core/widgets/empty_space.dart';
import 'package:pokedeal/features/collection/domain/models/card/base_pokemon_card.dart';
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
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  16.height,
                  buildCardHeader(state.card, context),
                  16.height,
                ],
              ),
            );
          }

          return Center(child: Text('Carte indisponible'));
        },
      ),
    );
  }

  Widget buildCardImage(BasePokemonCard card) {
    return SizedBox(
      height: 240,
      width: 150,
      child:
          card.image != null
              ? CachedNetworkImage(
                imageUrl: PokemonCardImageHelper.gererateImageUrl(
                  card.image!,
                  quality: PokemonCardQuality.high,
                ),
              )
              : Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: PokemonCardUnavailableWidget(
                  card: PokemonCardBrief(
                    id: card.setBrief.id,
                    localId: card.localId,
                    name: card.setBrief.name,
                  ),
                  totalCard: card.setBrief.cardCount.total,
                ),
              ),
    );
  }

  Widget buildNumberAndRarity(BasePokemonCard card) {
    return Row(
      children: [
        Text('${card.localId}/${card.setBrief.cardCount.total}'),
        if (card.rarity != null) ...[8.width, Text(card.rarity!)],
      ],
    );
  }

  Widget buildIllustrator(BasePokemonCard card) {
    return Row(
      children: [const Icon(Icons.brush, size: 16), Text(card.illustrator!)],
    );
  }

  Widget buildSetInfo(BasePokemonCard card, BuildContext context) {
    return Row(
      children: [
        card.setBrief.symbolUrl != null
            ? CachedNetworkImage(
              imageUrl: '${card.setBrief.symbolUrl!}.png',
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
        8.width,
        Flexible(
          child: Text(
            card.setBrief.name,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }

  Widget buildCardHeader(BasePokemonCard card, BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.tertiaryContainer,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            buildCardImage(card),
            16.width,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    card.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  buildNumberAndRarity(card),
                  buildSetInfo(card, context),
                  if (card.illustrator != null) buildIllustrator(card),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onAddToCollection() {
    //@todo ouvrir une bottomsheet
  }
}
