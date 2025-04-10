import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pokedeal/core/helper/pokemon_card_image_helper.dart';

class PokemonCardWidget extends StatelessWidget {
  final String cardUrl;
  final VoidCallback? onTap;

  const PokemonCardWidget({super.key, required this.cardUrl, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: CachedNetworkImage(
          imageUrl: PokemonCardImageHelper.gererateImageUrl(
            cardUrl,
            quality: PokemonCardQuality.low,
          ),
        ),
      ),
    );
  }
}
