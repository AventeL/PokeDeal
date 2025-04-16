import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pokedeal/core/helper/pokemon_card_image_helper.dart';
import 'package:pokedeal/features/collection/presentation/widgets/owned_indicator_widget.dart';

class PokemonCardWidget extends StatelessWidget {
  final String cardUrl;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool isOwned;

  const PokemonCardWidget({
    super.key,
    required this.cardUrl,
    this.onTap,
    this.onLongPress,
    this.isOwned = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            onLongPress: onLongPress,
            child: CachedNetworkImage(
              imageUrl: PokemonCardImageHelper.gererateImageUrl(
                cardUrl,
                quality: PokemonCardQuality.low,
              ),
            ),
          ),
        ),
        if (isOwned)
          Padding(
            padding: const EdgeInsets.only(right: 4.0, bottom: 4.0),
            child: OwnedIndicatorWidget(),
          ),
      ],
    );
  }
}
