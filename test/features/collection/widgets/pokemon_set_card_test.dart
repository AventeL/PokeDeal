import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pokedeal/features/collection/domain/models/card_count.dart';
import 'package:pokedeal/features/collection/domain/models/pokemon_set_brief.dart';
import 'package:pokedeal/features/collection/presentation/widgets/pokemon_set_card.dart';

void main() {
  testWidgets(
    'PokemonSetCardWidget has a LinearProgressIndicator and a pourcentage',
    (WidgetTester tester) async {
      final pokemonSet = PokemonSetBrief(
        name: 'Set 1',
        id: 'set1',
        cardCount: CardCount(official: 100, total: 100),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: PokemonSetCardWidget(set: pokemonSet)),
        ),
      );

      expect(find.byType(LinearProgressIndicator), findsOneWidget);
      expect(find.text('100.0%'), findsOneWidget);
    },
  );

  // @TODO faire les tests pour le pourcentage de la bar de progression
}
