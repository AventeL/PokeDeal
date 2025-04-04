import 'package:flutter/material.dart';

class PokemonSerieCard extends StatefulWidget {
  final String name;

  const PokemonSerieCard({super.key, required this.name});

  @override
  State<PokemonSerieCard> createState() => _PokemonSerieCardState();
}

class _PokemonSerieCardState extends State<PokemonSerieCard> {
  bool isDeployed = false;
  double borderRadius = 8.0;

  Color bgColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: bgColor,
          borderRadius: BorderRadius.circular(borderRadius),
          child: InkWell(
            borderRadius: BorderRadius.circular(borderRadius),
            onTap: () {
              setState(() {
                isDeployed = !isDeployed;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              decoration: BoxDecoration(
                borderRadius:
                    !isDeployed
                        ? BorderRadius.circular(borderRadius)
                        : BorderRadius.only(
                          topLeft: Radius.circular(borderRadius),
                          topRight: Radius.circular(borderRadius),
                        ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.name,
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Spacer(),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Icon(
                      isDeployed ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (isDeployed)
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(borderRadius),
                  bottomRight: Radius.circular(borderRadius),
                ),
              ),
              child: Column(
                children: [
                  ListTile(
                    title: Text(
                      'EV 1',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  ListTile(
                    title: Text(
                      'EV 2',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
