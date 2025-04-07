class PokemonCardImageHelper {
  static String gererateImageUrl(
    String cardUrl, {
    PokemonCardQuality quality = PokemonCardQuality.high,
    PokemonCardExtension extension = PokemonCardExtension.png,
  }) {
    return '$cardUrl/${quality.toString()}.${extension.toString()}';
  }
}

enum PokemonCardQuality {
  low,
  high;

  @override
  String toString() {
    switch (this) {
      case PokemonCardQuality.low:
        return 'low';
      case PokemonCardQuality.high:
        return 'high';
    }
  }
}

enum PokemonCardExtension {
  png,
  jpg,
  webp;

  @override
  String toString() {
    switch (this) {
      case PokemonCardExtension.png:
        return 'png';
      case PokemonCardExtension.jpg:
        return 'jpg';
      case PokemonCardExtension.webp:
        return 'webp';
    }
  }
}
