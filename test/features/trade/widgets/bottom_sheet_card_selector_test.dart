import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pokedeal/features/collection/domain/models/card/base_pokemon_card.dart';
import 'package:pokedeal/features/collection/domain/models/card/card_variant.dart';
import 'package:pokedeal/features/collection/domain/models/card/user_card_collection.dart';
import 'package:pokedeal/features/collection/domain/models/card_count.dart';
import 'package:pokedeal/features/collection/domain/models/enum/card_category.dart';
import 'package:pokedeal/features/collection/domain/models/enum/variant_value.dart';
import 'package:pokedeal/features/collection/domain/models/legal.dart';
import 'package:pokedeal/features/collection/domain/models/pokemon_serie.dart';
import 'package:pokedeal/features/collection/domain/models/pokemon_serie_brief.dart';
import 'package:pokedeal/features/collection/domain/models/pokemon_set.dart';
import 'package:pokedeal/features/collection/presentation/bloc/user_collection/user_collection_bloc.dart';
import 'package:pokedeal/features/trade/domain/models/trade_request_data.dart';
import 'package:pokedeal/features/trade/presentation/widgets/bottom_sheet_card_selector.dart';

import '../../../mocks/generated_mocks.mocks.dart';

void main() {
  late MockUserCollectionBloc mockBloc;

  setUp(() {
    mockBloc = MockUserCollectionBloc();
  });

  testWidgets('Affiche loader pendant le chargement', (tester) async {
    when(mockBloc.state).thenReturn(UserCollectionLoading());
    when(
      mockBloc.stream,
    ).thenAnswer((_) => Stream.value(UserCollectionLoading()));

    final tradeRequestData = TradeRequestData(userId: 'userId');

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BlocProvider<UserCollectionBloc>.value(
            value: mockBloc,
            child: BottomSheetCardSelector(tradeRequestData: tradeRequestData),
          ),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Parcours le chemin pour choisir une carte', (tester) async {
    final tradeRequestData = TradeRequestData(userId: 'userId');

    final mockBloc = MockUserCollectionBloc();

    when(mockBloc.stream).thenAnswer(
      (_) => Stream.fromIterable([
        UserCollectionLoading(),
        UserCollectionAllLoaded(
          seriesCollection: [
            PokemonSerie(id: 'serie1', name: 'Série 1', sets: []),
          ],
          setsCollection: [
            PokemonSet(
              id: 'set1',
              name: 'Set 1',
              cardCount: CardCount(total: 100, official: 100),
              cards: [],
              legal: Legal(expanded: false, standard: true),
              serieBrief: PokemonSerieBrief(name: 'Série 1', id: 'serie1'),
            ),
          ],
          listOfCards: [
            BasePokemonCard(
              id: 'card1',
              name: 'Carte 1',
              localId: 'localId1',
              category: CardCategory.pokemon,
              setBrief:
                  PokemonSet(
                    id: 'set1',
                    name: 'Set 1',
                    cardCount: CardCount(total: 100, official: 100),
                    cards: [],
                    legal: Legal(expanded: false, standard: true),
                    serieBrief: PokemonSerieBrief(
                      name: 'Série 1',
                      id: 'serie1',
                    ),
                  ).toBrief(),
              variants: CardVariant(
                normal: true,
                promo: false,
                holo: false,
                reverse: false,
                firstEdition: false,
              ),
            ),
          ],
          userCardsCollection: [
            UserCardCollection(
              cardId: 'card1',
              variant: VariantValue.normal,
              id: 'id1',
              userId: 'userId',
              quantity: 1,
              setId: 'set1',
            ),
          ],
        ),
      ]),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<UserCollectionBloc>.value(
          value: mockBloc,
          child: Builder(
            builder: (context) {
              return Scaffold(
                body: Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      final result = await showModalBottomSheet(
                        context: context,
                        builder: (BuildContext bottomSheetContext) {
                          return BlocProvider<UserCollectionBloc>.value(
                            value: mockBloc,
                            child: BottomSheetCardSelector(
                              tradeRequestData: tradeRequestData,
                            ),
                          );
                        },
                      );

                      expect(result['variantValue'], VariantValue.normal);
                      expect(result['card'].id, 'card1');
                    },
                    child: const Text('Open BottomSheet'),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open BottomSheet'));
    await tester.pumpAndSettle();

    expect(find.text('Choisir une série'), findsOneWidget);
    await tester.tap(find.text('Série 1'));
    await tester.pumpAndSettle();

    expect(find.text('Choisir un set'), findsOneWidget);
    await tester.tap(find.text('Set 1'));
    await tester.pumpAndSettle();

    expect(find.text('Choisir une carte'), findsOneWidget);
    await tester.tap(find.text('Carte 1'));
    await tester.pumpAndSettle();

    expect(find.text('Choisir une rareté'), findsOneWidget);
    await tester.tap(find.text(VariantValue.normal.getFullName));
    await tester.pumpAndSettle();
  });
}
