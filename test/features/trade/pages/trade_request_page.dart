import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pokedeal/features/collection/domain/models/card/base_pokemon_card.dart';
import 'package:pokedeal/features/collection/domain/models/card/card_variant.dart';
import 'package:pokedeal/features/collection/domain/models/card_count.dart';
import 'package:pokedeal/features/collection/domain/models/enum/card_category.dart';
import 'package:pokedeal/features/collection/domain/models/enum/variant_value.dart';
import 'package:pokedeal/features/collection/domain/models/pokemon_set_brief.dart';
import 'package:pokedeal/features/collection/presentation/bloc/card_bloc/collection_pokemon_card_bloc.dart';
import 'package:pokedeal/features/trade/domain/models/trade_request_data.dart';
import 'package:pokedeal/features/trade/presentation/bloc/trade_bloc.dart';
import 'package:pokedeal/features/trade/presentation/pages/trade_request_page.dart';
import 'package:pokedeal/shared/widgets/custom_large_button.dart';

import '../../../mocks/generated_mocks.mocks.dart';

void main() {
  late MockTradeBloc tradeBloc;
  late MockCollectionPokemonCardBloc cardBloc;

  final myTradeRequest = TradeRequestData(
    userId: 'me',
    cardId: '1',
    variantValue: VariantValue.holo,
  );

  final otherTradeRequest = TradeRequestData(
    userId: 'other',
    cardId: '2',
    variantValue: VariantValue.holo,
  );

  final baseCard = BasePokemonCard(
    id: '1',
    name: 'Serpent',
    category: CardCategory.pokemon,
    setBrief: PokemonSetBrief(
      id: 'setId',
      name: 'Base Set',
      symbolUrl: '',
      logoUrl: '',
      cardCount: CardCount(total: 100, official: 80),
    ),
    variants: CardVariant(
      firstEdition: false,
      holo: true,
      reverse: false,
      promo: false,
      normal: false,
    ),
    localId: '001',
  );

  setUp(() {
    tradeBloc = MockTradeBloc();
    cardBloc = MockCollectionPokemonCardBloc();
  });

  Widget makeTestableWidget() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TradeBloc>.value(value: tradeBloc),
        BlocProvider<CollectionPokemonCardBloc>.value(value: cardBloc),
      ],
      child: MaterialApp(
        home: TradeRequestPage(
          myTradeRequest: myTradeRequest,
          otherUserTradeRequest: otherTradeRequest,
        ),
      ),
    );
  }

  testWidgets('Affiche correctement la page et le bouton fonctionne', (
    tester,
  ) async {
    when(tradeBloc.state).thenReturn(TradeStateInitial());
    when(cardBloc.state).thenReturn(CollectionPokemonCardsGet(card: baseCard));

    await tester.pumpWidget(makeTestableWidget());
    await tester.pumpAndSettle();

    await tester.ensureVisible(
      find.widgetWithText(CustomLargeButton, "Demander"),
    );
    await tester.pumpAndSettle();

    expect(find.text('Vous proposez : '), findsOneWidget);
    expect(find.text("Vous recevez : "), findsOneWidget);
    expect(find.text("Demander"), findsOneWidget);

    final demandeButton = find.widgetWithText(CustomLargeButton, "Demander");
    expect(demandeButton, findsOneWidget);
    final button = tester.widget<CustomLargeButton>(demandeButton);
    expect(button.isActive, isTrue);

    when(tradeBloc.add(any)).thenReturn(null);

    await tester.tap(demandeButton);
    await tester.pump();
  });
}
