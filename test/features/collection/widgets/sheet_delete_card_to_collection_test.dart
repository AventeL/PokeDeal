import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pokedeal/features/collection/domain/models/card/base_pokemon_card.dart';
import 'package:pokedeal/features/collection/domain/models/card/card_variant.dart';
import 'package:pokedeal/features/collection/domain/models/card_count.dart';
import 'package:pokedeal/features/collection/domain/models/enum/card_category.dart';
import 'package:pokedeal/features/collection/domain/models/enum/variant_value.dart';
import 'package:pokedeal/features/collection/domain/models/pokemon_set_brief.dart';
import 'package:pokedeal/features/collection/presentation/widgets/sheet_delete_card_to_collection.dart';

void main() {
  testWidgets('Affiche correctement la page et gere les interactions', (
    WidgetTester tester,
  ) async {
    final mockCard = BasePokemonCard(
      id: '1',
      name: 'serpent',
      category: CardCategory.pokemon,
      setBrief: PokemonSetBrief(
        id: 'setId',
        name: 'setName',
        symbolUrl: 'symbolUrl',
        logoUrl: 'logoUrl',
        cardCount: CardCount(total: 100, official: 50),
      ),
      variants: CardVariant(
        firstEdition: false,
        holo: true,
        reverse: false,
        promo: false,
        normal: false,
      ),
      localId: '123',
    );
    mockOnConfirm(int quantity, VariantValue variant) {}

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SheetDeleteCardToCollection(
            card: mockCard,
            onConfirm: mockOnConfirm,
            variant: VariantValue.holo,
          ),
        ),
      ),
    );

    expect(find.byType(TextFormField), findsOneWidget);

    expect(find.byType(DropdownButton<VariantValue>), findsOneWidget);
  });
}
