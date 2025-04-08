import 'package:flutter/material.dart';
import 'package:pokedeal/features/collection/domain/models/card/pokemon_card_brief.dart';

class PokemonCardUnavailableWidget extends StatelessWidget {
  final PokemonCardBrief card;
  final int totalCard;
  final VoidCallback? onTap;

  const PokemonCardUnavailableWidget({
    super.key,
    required this.card,
    required this.totalCard,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(8.0);

    return Material(
      color: Colors.transparent,
      borderRadius: borderRadius,
      child: InkWell(
        splashColor: Theme.of(context).primaryColor,
        borderRadius: borderRadius,
        onTap: onTap,
        child: Container(
          height: 224,
          width: 150,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: borderRadius,
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
        ),
      ),
    );
  }
}
