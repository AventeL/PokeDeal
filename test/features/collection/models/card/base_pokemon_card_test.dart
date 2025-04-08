import 'package:flutter_test/flutter_test.dart';
import 'package:pokedeal/features/collection/domain/models/card/base_pokemon_card.dart';
import 'package:pokedeal/features/collection/domain/models/card/card_variant.dart';
import 'package:pokedeal/features/collection/domain/models/card_count.dart';
import 'package:pokedeal/features/collection/domain/models/enum/card_category.dart';
import 'package:pokedeal/features/collection/domain/models/pokemon_set_brief.dart';

void main() {
  test('BasePokemonCard has a fromJson', () {
    final json = {
      "id": "xy7-54",
      "localId": "54",
      "name": "Gardevoir EX",
      "image": "https://images.pokemontcg.io/xy7/54.png",
      "category": "pokémon",
      "illustrator": "5ban Graphics",
      "rarity": "Rare Holo EX",
      "set": {
        "name": "Ancient Origins",
        "id": "xy7",
        "logo": "https://example.com/logo.png",
        "symbol": "https://example.com/symbol.png",
        "cardCount": {
          "total": 98,
          "official": 98,
          "first_edition": null,
          "holo": 50,
          "reverse": 48,
          "normal": 98,
        },
      },
      "variants": {
        "firstEdition": false,
        "holo": true,
        "reverse": false,
        "wPromo": false,
        "normal": false,
      },
      "dexId": [282],
      "hp": 170,
      "types": ["Psychic"],
      "evolveFrom": "Kirlia",
      "description": "This Pokémon can sense emotions and heal people.",
      "level": "EX",
      "stage": "Basic",
      "suffix": "EX",
      "item": {
        "name": "Mega Stone",
        "effect": "Allows evolution into Mega Gardevoir.",
      },
    };

    final basePokemonCard = BasePokemonCard.fromJson(json);

    expect(basePokemonCard.id, "xy7-54");
    expect(basePokemonCard.localId, "54");
    expect(basePokemonCard.name, "Gardevoir EX");
    expect(basePokemonCard.image, "https://images.pokemontcg.io/xy7/54.png");
    expect(basePokemonCard.category, CardCategory.pokemon);
    expect(basePokemonCard.illustrator, "5ban Graphics");
    expect(basePokemonCard.rarity, "Rare Holo EX");
    expect(basePokemonCard.setBrief.name, "Ancient Origins");
    expect(basePokemonCard.setBrief.id, "xy7");
    expect(basePokemonCard.setBrief.logoUrl, "https://example.com/logo.png");
    expect(
      basePokemonCard.setBrief.symbolUrl,
      "https://example.com/symbol.png",
    );
    expect(basePokemonCard.setBrief.cardCount.total, 98);
    expect(basePokemonCard.setBrief.cardCount.official, 98);
    expect(basePokemonCard.setBrief.cardCount.firstEd, null);
    expect(basePokemonCard.setBrief.cardCount.holo, 50);
    expect(basePokemonCard.setBrief.cardCount.reverse, 48);
    expect(basePokemonCard.setBrief.cardCount.normal, 98);
    expect(basePokemonCard.variants.firstEdition, false);
    expect(basePokemonCard.variants.holo, true);
    expect(basePokemonCard.variants.reverse, false);
    expect(basePokemonCard.variants.promo, false);
    expect(basePokemonCard.variants.normal, false);
  });

  test('BasePokemonCard has a constructor', () {
    final card = BasePokemonCard(
      id: "xy7-54",
      localId: "54",
      name: "Gardevoir EX",
      image: "https://images.pokemontcg.io/xy7/54.png",
      category: CardCategory.pokemon,
      illustrator: "5ban Graphics",
      rarity: "Rare Holo EX",
      setBrief: PokemonSetBrief(
        name: "Ancient Origins",
        id: "xy7",
        logoUrl: "https://example.com/logo.png",
        symbolUrl: "https://example.com/symbol.png",
        cardCount: CardCount(
          total: 98,
          official: 98,
          firstEd: null,
          holo: 50,
          reverse: 48,
          normal: 98,
        ),
      ),
      variants: CardVariant(
        firstEdition: false,
        holo: true,
        reverse: false,
        promo: false,
        normal: false,
      ),
    );

    expect(card.id, "xy7-54");
    expect(card.localId, "54");
    expect(card.name, "Gardevoir EX");
    expect(card.image, "https://images.pokemontcg.io/xy7/54.png");
    expect(card.category, CardCategory.pokemon);
    expect(card.illustrator, "5ban Graphics");
    expect(card.rarity, "Rare Holo EX");
    expect(card.setBrief.name, "Ancient Origins");
    expect(card.setBrief.id, "xy7");
    expect(card.setBrief.logoUrl, "https://example.com/logo.png");
    expect(card.setBrief.symbolUrl, "https://example.com/symbol.png");
    expect(card.setBrief.cardCount.total, 98);
    expect(card.setBrief.cardCount.official, 98);
    expect(card.setBrief.cardCount.firstEd, null);
    expect(card.setBrief.cardCount.holo, 50);
    expect(card.setBrief.cardCount.reverse, 48);
    expect(card.setBrief.cardCount.normal, 98);
    expect(card.variants.firstEdition, false);
    expect(card.variants.holo, true);
    expect(card.variants.reverse, false);
    expect(card.variants.promo, false);
    expect(card.variants.normal, false);
  });

  test('throw error when the category is wrong', () {
    final json = {'category': 'invalid_category'};
    expect(() => BasePokemonCard.fromJson(json), throwsA(isA<ArgumentError>()));
  });

  test('CardCategoryExtension fromString', () {
    expect(CardCategoryExtension.fromString('pokémon'), CardCategory.pokemon);
    expect(CardCategoryExtension.fromString('dresseur'), CardCategory.trainer);
    expect(CardCategoryExtension.fromString('énergie'), CardCategory.energy);
    expect(
      () => CardCategoryExtension.fromString('invalid'),
      throwsArgumentError,
    );
  });
}
