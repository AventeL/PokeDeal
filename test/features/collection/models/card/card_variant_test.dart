import 'package:flutter_test/flutter_test.dart';
import 'package:pokedeal/features/collection/domain/models/card/card_variant.dart';
import 'package:pokedeal/features/collection/domain/models/enum/variant_value.dart';

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

  // Tests for VariantValue enum and its extension
  test('VariantValue getFullName returns correct full name', () {
    expect(VariantValue.normal.getFullName, 'Normal');
    expect(VariantValue.holo.getFullName, 'Holo');
    expect(VariantValue.reverse.getFullName, 'Reverse');
    expect(VariantValue.promo.getFullName, 'Promo');
    expect(VariantValue.firstEdition.getFullName, '1st Edition');
  });

  test('VariantValue fromJson returns correct enum', () {
    expect(VariantValueExtension.fromJson('Normal'), VariantValue.normal);
    expect(VariantValueExtension.fromJson('Holo'), VariantValue.holo);
    expect(VariantValueExtension.fromJson('Reverse'), VariantValue.reverse);
    expect(VariantValueExtension.fromJson('Promo'), VariantValue.promo);
    expect(
      VariantValueExtension.fromJson('1st Edition'),
      VariantValue.firstEdition,
    );
  });

  test('VariantValue fromJson throws exception for unknown value', () {
    expect(() => VariantValueExtension.fromJson('Unknown'), throwsException);
  });
}
