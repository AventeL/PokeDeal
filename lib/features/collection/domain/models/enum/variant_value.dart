enum VariantValue { normal, holo, reverse, promo, firstEdition }

extension VariantValueExtension on VariantValue {
  String get getFullName {
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

  static VariantValue fromJson(String json) {
    switch (json) {
      case 'Normal':
        return VariantValue.normal;
      case 'Holo':
        return VariantValue.holo;
      case 'Reverse':
        return VariantValue.reverse;
      case 'Promo':
        return VariantValue.promo;
      case '1st Edition':
        return VariantValue.firstEdition;
      default:
        throw Exception('Unknown variant value: $json');
    }
  }
}
