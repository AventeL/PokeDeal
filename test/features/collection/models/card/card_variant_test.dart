import 'package:flutter_test/flutter_test.dart';
import 'package:pokedeal/features/collection/domain/models/card/card_variant.dart';

void main() {
  test('CardVariant has a constructor', () {
    const cardVariant = CardVariant(
      firstEdition: true,
      holo: false,
      reverse: true,
      promo: false,
      normal: true,
    );

    expect(cardVariant.firstEdition, true);
    expect(cardVariant.holo, false);
    expect(cardVariant.reverse, true);
    expect(cardVariant.promo, false);
    expect(cardVariant.normal, true);
  });
  
  test('CardVariant has a fromJson', () {
    final json = {
      'firstEdition': true,
      'holo': false,
      'reverse': true,
      'wPromo': false,
      'normal': true,
    };

    final cardVariant = CardVariant.fromJson(json);

    expect(cardVariant.firstEdition, true);
    expect(cardVariant.holo, false);
    expect(cardVariant.reverse, true);
    expect(cardVariant.promo, false);
    expect(cardVariant.normal, true);
  });
}
