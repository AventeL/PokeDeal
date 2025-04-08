import 'package:flutter/material.dart';
import 'package:pokedeal/core/widgets/empty_space.dart';
import 'package:pokedeal/features/collection/domain/models/pokemon_set_brief.dart';

class PokemonSetCardWidget extends StatelessWidget {
  final PokemonSetBrief set;
  final VoidCallback? onTap;

  const PokemonSetCardWidget({super.key, required this.set, this.onTap});

  @override
  Widget build(BuildContext context) {
    double percentage =
        set.cardCount.total > 0
            ? set.cardCount.total / set.cardCount.total
            : 0.0;
    return Material(
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color:
                Theme.of(context).brightness == Brightness.light
                    ? Colors.white
                    : Color(0xFF2C2C2C),
          ),
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              set.logoUrl != null
                  ? Image.network(
                    '${set.logoUrl!}.png',
                    width: 70,
                    height: 50,
                    fit: BoxFit.contain,
                  )
                  : Image.asset(
                    'assets/images/pokeball.png',
                    width: 70,
                    height: 50,
                    fit: BoxFit.contain,
                  ),
              20.width,
              Expanded(
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          set.name,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Text(
                          set.cardCount.total.toString(),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: LinearProgressIndicator(
                            value: percentage,
                            backgroundColor: Colors.grey,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          '${(percentage * 100).toStringAsFixed(1)}%',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
