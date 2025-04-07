import 'package:flutter/material.dart';
import 'package:pokedeal/features/collection/domain/models/pokemon_set.dart';

class PokemonSetCardWidget extends StatelessWidget {
  final PokemonSet set;
  final VoidCallback? onTap;

  const PokemonSetCardWidget({super.key, required this.set, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(set.name, style: Theme.of(context).textTheme.bodyMedium),
              Text(
                set.cardCount.total.toString(),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
