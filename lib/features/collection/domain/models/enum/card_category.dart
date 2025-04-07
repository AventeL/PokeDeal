enum CardCategory { pokemon, trainer, energy }

extension CardCategoryExtension on CardCategory {
  static CardCategory fromString(String category) {
    switch (category.toLowerCase()) {
      case 'pokemon':
        return CardCategory.pokemon;
      case 'trainer':
        return CardCategory.trainer;
      case 'energy':
        return CardCategory.energy;
      default:
        throw ArgumentError('Invalid card category: $category');
    }
  }
}
