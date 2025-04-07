import 'package:flutter/material.dart';
import 'package:pokedeal/features/collection/domain/models/card/pokemon_card_brief.dart';

class PokemonCardUnavailableWidget extends StatelessWidget {
  final PokemonCardBrief card;
  final int totalCard;

  const PokemonCardUnavailableWidget({
    super.key,
    required this.card,
    required this.totalCard,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              card.name,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text('Image non disponible', textAlign: TextAlign.center),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                "${card.localId}/$totalCard",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
