import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pokedeal/features/collection/domain/models/card/user_card_collection.dart';
import 'package:pokedeal/features/collection/domain/models/enum/variant_value.dart';
import 'package:pokedeal/features/collection/presentation/bloc/user_collection/user_collection_bloc.dart';
import 'package:pokedeal/features/collection/presentation/widgets/card_collection_list_widget.dart';

import '../../../mocks/generated_mocks.mocks.dart';

void main() {
  late MockUserCollectionBloc mockBloc;

  setUp(() {
    mockBloc = MockUserCollectionBloc();
  });

  testWidgets(
    'CardCollectionListWidget displays loading indicator when loading',
    (WidgetTester tester) async {
      when(mockBloc.state).thenReturn(UserCollectionLoading());

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<UserCollectionBloc>(
            create: (context) => mockBloc,
            child: CardCollectionListWidget(userId: 'user1', cardId: 'card1'),
          ),
        ),
      );

      expect(find.byType(LinearProgressIndicator), findsOneWidget);
    },
  );

  testWidgets(
    'CardCollectionListWidget shows error message when there is an error',
    (WidgetTester tester) async {
      when(
        mockBloc.state,
      ).thenReturn(UserCollectionError(message: 'An error occurred'));

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<UserCollectionBloc>(
            create: (context) => mockBloc,
            child: CardCollectionListWidget(userId: 'user1', cardId: 'card1'),
          ),
        ),
      );

      expect(find.text('Error: An error occurred'), findsOneWidget);
    },
  );

  testWidgets(
    'CardCollectionListWidget shows "No cards in your collection" when no cards are available',
    (WidgetTester tester) async {
      when(
        mockBloc.state,
      ).thenReturn(UserCollectionCardLoaded(userCardsCollection: []));

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<UserCollectionBloc>(
            create: (context) => mockBloc,
            child: CardCollectionListWidget(userId: 'user1', cardId: 'card1'),
          ),
        ),
      );

      expect(find.text('Aucune carte dans votre collection'), findsOneWidget);
    },
  );

  testWidgets('CardCollectionListWidget displays cards when available', (
    WidgetTester tester,
  ) async {
    final streamController = StreamController<UserCollectionState>.broadcast();
    final userCardsCollection = [
      UserCardCollection(
        id: '1',
        userId: '1',
        cardId: 'card1',
        quantity: 5,
        variant: VariantValue.normal,
        setId: 'set1',
      ),
      UserCardCollection(
        id: '2',
        userId: '1',
        cardId: 'card1',
        quantity: 3,
        variant: VariantValue.holo,
        setId: 'set2',
      ),
    ];

    when(mockBloc.stream).thenAnswer((_) => streamController.stream);
    when(mockBloc.state).thenReturn(UserCollectionLoading());

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<UserCollectionBloc>(
          create: (_) => mockBloc,
          child: Scaffold(
            body: Column(
              children: [
                CardCollectionListWidget(userId: '1', cardId: 'card1'),
              ],
            ),
          ),
        ),
      ),
    );

    streamController.add(
      UserCollectionCardLoaded(userCardsCollection: userCardsCollection),
    );
    await tester.pumpAndSettle();

    expect(find.text('Normal'), findsOneWidget);
    expect(find.text('Holo'), findsOneWidget);
    expect(find.text('5'), findsOneWidget);
    expect(find.text('3'), findsOneWidget);

    await streamController.close();
  });

  testWidgets(
    'CardCollectionListWidget shows message when collection is empty',
    (WidgetTester tester) async {
      when(
        mockBloc.state,
      ).thenReturn(UserCollectionCardLoaded(userCardsCollection: []));

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<UserCollectionBloc>(
            create: (context) => mockBloc,
            child: CardCollectionListWidget(userId: 'user1', cardId: 'card1'),
          ),
        ),
      );

      expect(find.text('Aucune carte dans votre collection'), findsOneWidget);
    },
  );
}
