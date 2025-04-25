import 'package:flutter/material.dart';
import 'package:pokedeal/features/collection/domain/models/pokemon_serie.dart';
import 'package:pokedeal/features/collection/domain/models/pokemon_set_brief.dart';
import 'package:pokedeal/features/collection/presentation/widgets/pokemon_set_card.dart';

class PokemonSerieCard extends StatefulWidget {
  final PokemonSerie pokemonSerie;
  final List<PokemonSetBrief>? sets;
  final Function(PokemonSetBrief)? onSetTap;

  const PokemonSerieCard({
    super.key,
    required this.pokemonSerie,
    this.sets,
    this.onSetTap,
  });

  @override
  State<PokemonSerieCard> createState() => _PokemonSerieCardState();
}

class _PokemonSerieCardState extends State<PokemonSerieCard> {
  bool isDeployed = false;
  double borderRadius = 8.0;

  Color get bgColor => Theme.of(context).colorScheme.tertiaryContainer;

  BorderRadius get adaptativeBorderRadius =>
      !isDeployed
          ? BorderRadius.circular(borderRadius)
          : BorderRadius.only(
            topLeft: Radius.circular(borderRadius),
            topRight: Radius.circular(borderRadius),
            bottomLeft: Radius.circular(0),
            bottomRight: Radius.circular(0),
          );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: bgColor,
          borderRadius: adaptativeBorderRadius,
          child: InkWell(
            borderRadius: adaptativeBorderRadius,
            onTap: () {
              setState(() {
                isDeployed = !isDeployed;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              decoration: BoxDecoration(borderRadius: adaptativeBorderRadius),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.pokemonSerie.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color:
                          Theme.of(context).brightness == Brightness.light
                              ? Colors.black
                              : Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Spacer(),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Icon(
                      isDeployed ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                      color:
                          Theme.of(context).brightness == Brightness.light
                              ? Colors.black
                              : Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (isDeployed) buildListSets(),
      ],
    );
  }

  Widget buildListSets() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(borderRadius),
          bottomRight: Radius.circular(borderRadius),
        ),
      ),
      child: Column(
        children:
            widget.sets != null && widget.sets!.isNotEmpty
                ? widget.sets!.map((set) {
                  return PokemonSetCardWidget(
                    set: set,
                    onTap: () => widget.onSetTap!(set),
                  );
                }).toList()
                : widget.pokemonSerie.sets.map((set) {
                  return PokemonSetCardWidget(
                    set: set,
                    onTap: () => widget.onSetTap!(set),
                  );
                }).toList(),
      ),
    );
  }
}
