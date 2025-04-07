import 'package:flutter_test/flutter_test.dart';
import 'package:pokedeal/core/helper/pokemon_card_image_helper.dart';

void main() {
  test('PokemonCardQuality toString', () {
    PokemonCardQuality quality = PokemonCardQuality.low;
    expect(quality.toString(), 'low');
    quality = PokemonCardQuality.high;
    expect(quality.toString(), 'high');
  });

  test('PokemonCardExtension toString', () {
    PokemonCardExtension extension = PokemonCardExtension.png;
    expect(extension.toString(), 'png');
    extension = PokemonCardExtension.jpg;
    expect(extension.toString(), 'jpg');
    extension = PokemonCardExtension.webp;
    expect(extension.toString(), 'webp');
  });

  test('generateImageUrl', () {
    String cardUrl = 'https://example.com/card';
    String expectedUrl = 'https://example.com/card/high.png';
    String generatedUrl = PokemonCardImageHelper.gererateImageUrl(cardUrl);
    expect(generatedUrl, expectedUrl);

    expectedUrl = 'https://example.com/card/low.jpg';
    generatedUrl = PokemonCardImageHelper.gererateImageUrl(
      cardUrl,
      quality: PokemonCardQuality.low,
      extension: PokemonCardExtension.jpg,
    );
    expect(generatedUrl, expectedUrl);

    expectedUrl = 'https://example.com/card/high.webp';
    generatedUrl = PokemonCardImageHelper.gererateImageUrl(
      cardUrl,
      extension: PokemonCardExtension.webp,
    );
    expect(generatedUrl, expectedUrl);
  });
}
