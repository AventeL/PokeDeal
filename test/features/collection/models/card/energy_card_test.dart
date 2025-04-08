import 'package:flutter_test/flutter_test.dart';
import 'package:pokedeal/features/collection/domain/models/card/card_variant.dart';
import 'package:pokedeal/features/collection/domain/models/card/energy_card.dart';
import 'package:pokedeal/features/collection/domain/models/card_count.dart';
import 'package:pokedeal/features/collection/domain/models/enum/card_category.dart';
import 'package:pokedeal/features/collection/domain/models/pokemon_set_brief.dart';

void main() {
  test('EnergyCard has a fromJson', () {
    final json = {
      "id": "swsh35-91",
      "localId": "91",
      "name": "Fire Energy",
      "image": "https://images.pokemontcg.io/swsh35/91.png",
      "category": "energy",
      "illustrator": "Ken Sugimori",
      "rarity": "Common",
      "set": {
        "name": "Champion’s Path",
        "id": "swsh35",
        "logo": "https://example.com/logo.png",
        "symbol": "https://example.com/symbol.png",
        "cardCount": {
          "total": 80,
          "official": 80,
          "first_edition": null,
          "holo": 20,
          "reverse": 60,
          "normal": 80,
        },
      },
      "variants": {
        "firstEdition": false,
        "holo": false,
        "reverse": false,
        "wPromo": false,
        "normal": true,
      },
      "energyType": "Fire",
    };

    final energyCard = EnergyCard.fromJson(json);

    expect(energyCard.id, "swsh35-91");
    expect(energyCard.localId, "91");
    expect(energyCard.name, "Fire Energy");
    expect(energyCard.image, "https://images.pokemontcg.io/swsh35/91.png");
    expect(energyCard.category, CardCategory.energy);
    expect(energyCard.illustrator, "Ken Sugimori");
    expect(energyCard.rarity, "Common");
    expect(energyCard.setBrief.name, "Champion’s Path");
    expect(energyCard.setBrief.id, "swsh35");
    expect(energyCard.setBrief.logoUrl, "https://example.com/logo.png");
    expect(energyCard.setBrief.symbolUrl, "https://example.com/symbol.png");
    expect(energyCard.setBrief.cardCount.total, 80);
    expect(energyCard.setBrief.cardCount.official, 80);
    expect(energyCard.setBrief.cardCount.firstEd, null);
    expect(energyCard.setBrief.cardCount.holo, 20);
    expect(energyCard.setBrief.cardCount.reverse, 60);
    expect(energyCard.setBrief.cardCount.normal, 80);
    expect(energyCard.variants.firstEdition, false);
    expect(energyCard.variants.holo, false);
    expect(energyCard.variants.reverse, false);
    expect(energyCard.variants.promo, false);
    expect(energyCard.variants.normal, true);
    expect(energyCard.energyType, "Fire");
  });

  test('EnergyCard has a constructor', () {
    final card = EnergyCard(
      id: "swsh35-91",
      localId: "91",
      name: "Fire Energy",
      image: "https://images.pokemontcg.io/swsh35/91.png",
      category: CardCategory.energy,
      illustrator: "Ken Sugimori",
      rarity: "Common",
      setBrief: PokemonSetBrief(
        name: "Champion’s Path",
        id: "swsh35",
        logoUrl: "https://example.com/logo.png",
        symbolUrl: "https://example.com/symbol.png",
        cardCount: CardCount(
          total: 80,
          official: 80,
          firstEd: null,
          holo: 20,
          reverse: 60,
          normal: 80,
        ),
      ),
      variants: CardVariant(
        firstEdition: false,
        holo: false,
        reverse: false,
        promo: false,
        normal: true,
      ),
      energyType: "Fire",
    );

    expect(card.id, "swsh35-91");
    expect(card.localId, "91");
    expect(card.name, "Fire Energy");
    expect(card.image, "https://images.pokemontcg.io/swsh35/91.png");
    expect(card.category, CardCategory.energy);
    expect(card.illustrator, "Ken Sugimori");
    expect(card.rarity, "Common");
    expect(card.setBrief.name, "Champion’s Path");
    expect(card.setBrief.id, "swsh35");
    expect(card.setBrief.logoUrl, "https://example.com/logo.png");
    expect(card.setBrief.symbolUrl, "https://example.com/symbol.png");
    expect(card.setBrief.cardCount.total, 80);
    expect(card.setBrief.cardCount.official, 80);
    expect(card.setBrief.cardCount.firstEd, null);
    expect(card.setBrief.cardCount.holo, 20);
    expect(card.setBrief.cardCount.reverse, 60);
    expect(card.setBrief.cardCount.normal, 80);
    expect(card.variants.firstEdition, false);
    expect(card.variants.holo, false);
    expect(card.variants.reverse, false);
    expect(card.variants.promo, false);
    expect(card.variants.normal, true);
    expect(card.energyType, "Fire");
  });
}
