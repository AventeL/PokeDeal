enum CardCategory { pokemon, trainer, energy }

extension CardCategoryExtension on CardCategory {
  static CardCategory fromString(String category) {
    switch (category.toLowerCase()) {
      case 'pokémon':
        return CardCategory.pokemon;
      case 'dresseur':
        return CardCategory.trainer;
      case 'énergie':
        return CardCategory.energy;
      default:
        throw ArgumentError('Catégorie invalide: $category');
    }
  }
}
