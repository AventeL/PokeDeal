import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pokedeal/core/helper/pokemon_card_image_helper.dart';

class PokemonCardWidget extends StatelessWidget {
  final String cardUrl;

  const PokemonCardWidget({super.key, required this.cardUrl});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: PokemonCardImageHelper.gererateImageUrl(
        cardUrl,
        quality: PokemonCardQuality.low,
      ),
    );
  }
}
