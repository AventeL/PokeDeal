enum VariantValue { normal, holo, reverse, promo, firstEdition }

extension VariantValueExtension on VariantValue {
  String get name {
    switch (this) {
      case VariantValue.normal:
        return 'Normal';
      case VariantValue.holo:
        return 'Holo';
      case VariantValue.reverse:
        return 'Reverse';
      case VariantValue.promo:
        return 'Promo';
      case VariantValue.firstEdition:
        return '1st Edition';
    }
  }
}
