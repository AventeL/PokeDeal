import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pokedeal/features/authentication/domain/models/user_profile.dart';
import 'package:pokedeal/features/collection/domain/models/enum/variant_value.dart';
import 'package:pokedeal/features/trade/domain/models/trade.dart';
import 'package:pokedeal/features/trade/domain/models/trade_request_data.dart';
import 'package:pokedeal/features/trade/domain/models/user_stats.dart';
import 'package:pokedeal/features/trade/presentation/bloc/trade_bloc.dart';

import '../../../mocks/generated_mocks.mocks.dart';

void main() {
  late MockTradeRepository mockTradeRepository;
  late TradeBloc tradeBloc;

  setUp(() {
    mockTradeRepository = MockTradeRepository();
    tradeBloc = TradeBloc(tradeRepository: mockTradeRepository);
  });

  tearDown(() {
    tradeBloc.close();
  });

  group('TradeBloc Test', () {
    final mockFetchAllUsers = [
      UserStats(
        user: UserProfile(
          id: 'user1',
          email: 'user1@test.com',
          pseudo: 'User1',
          createdAt: DateTime.now(),
        ),
        nbCards: 10,
        nbExchanges: 150,
      ),
      UserStats(
        user: UserProfile(
          id: 'user2',
          email: 'user2@test.com',
          pseudo: 'User2',
          createdAt: DateTime.now(),
        ),
        nbCards: 10,
        nbExchanges: 150,
      ),
    ];
    final mockTradesReceive = [
      Trade(
        id: '1',
        senderId: UserProfile(
          id: 'user1',
          email: 'user1@test.com',
          pseudo: 'User1',
          createdAt: DateTime.now(),
        ),
        receiveId: UserProfile(
          id: 'user2',
          email: 'user2@test.com',
          pseudo: 'User2',
          createdAt: DateTime.now(),
        ),
        status: 'En attente',
        timestamp: DateTime.now(),
      ),
    ];

    final mockTradesSend = [
      Trade(
        id: '1',
        senderId: UserProfile(
          id: 'user3',
          email: 'user3@test.com',
          pseudo: 'User3',
          createdAt: DateTime.now(),
        ),
        receiveId: UserProfile(
          id: 'user4',
          email: 'user4@test.com',
          pseudo: 'User4',
          createdAt: DateTime.now(),
        ),
        status: 'En attente',
        timestamp: DateTime.now(),
      ),
    ];

    void mockFetchTradesSuccess() {
      when(
        mockTradeRepository.getAllUser(),
      ).thenAnswer((_) async => mockFetchAllUsers);
    }

    blocTest<TradeBloc, TradeState>(
      'emits [TradeStateSuccessGetAllUsers, TradeStateUsersLoaded] when getAllUser is successful',
      build: () {
        mockFetchTradesSuccess();
        return tradeBloc;
      },
      act: (bloc) => bloc.add(TradeEventGetAllUsers()),
      expect:
          () => [
            TradeStateSuccessGetAllUsers(),
            TradeStateUsersLoaded(users: mockFetchAllUsers),
          ],
      verify: (_) {
        verify(mockTradeRepository.getAllUser()).called(1);
      },
    );

    void mockFetchReceiveTradesSuccess() {
      when(
        mockTradeRepository.getReceivedTrade(),
      ).thenAnswer((_) async => mockTradesReceive);
    }

    void mockFetchSendTradesSuccess() {
      when(
        mockTradeRepository.getSendTrade(),
      ).thenAnswer((_) async => mockTradesSend);
    }

    blocTest<TradeBloc, TradeState>(
      'emits [TradeStateReceivedTradesLoaded] when getReceivedTrade is successful',
      build: () {
        mockFetchReceiveTradesSuccess();
        return tradeBloc;
      },
      act: (bloc) => bloc.add(TradeEventGetReceivedTrade()),
      expect: () => [TradeStateReceivedTradesLoaded(trades: mockTradesReceive)],
      verify: (_) {
        verify(mockTradeRepository.getReceivedTrade()).called(1);
      },
    );

    blocTest<TradeBloc, TradeState>(
      'emits [TradeStateSendTradesLoaded] when getSendTrade is successful',
      build: () {
        mockFetchSendTradesSuccess();
        return tradeBloc;
      },
      act: (bloc) => bloc.add(TradeEventGetSendTrade()),
      expect: () => [TradeStateSendTradesLoaded(trades: mockTradesSend)],
      verify: (_) {
        verify(mockTradeRepository.getSendTrade()).called(1);
      },
    );

    blocTest<TradeBloc, TradeState>(
      'emits [TradeStateLoading, TradeStateAskTradeSuccess] when askTrade is successful',
      build: () {
        when(
          mockTradeRepository.askTrade(
            myTradeRequestData: anyNamed('myTradeRequestData'),
            otherTradeRequestData: anyNamed('otherTradeRequestData'),
          ),
        ).thenAnswer((_) async => {});
        return tradeBloc;
      },
      act:
          (bloc) => bloc.add(
            TradeEventAskTrade(
              myTradeRequestData: TradeRequestData(
                userId: 'userId',
                cardId: 'cardId',
                variantValue: VariantValue.normal,
              ),
              otherTradeRequestData: TradeRequestData(
                userId: 'otherUserId',
                cardId: 'otherCardId',
                variantValue: VariantValue.holo,
              ),
            ),
          ),
      expect: () => [TradeStateLoading(), TradeStateAskTradeSuccess()],
      verify: (_) {
        verify(
          mockTradeRepository.askTrade(
            myTradeRequestData: anyNamed('myTradeRequestData'),
            otherTradeRequestData: anyNamed('otherTradeRequestData'),
          ),
        ).called(1);
      },
    );

    blocTest<TradeBloc, TradeState>(
      'emits [TradeStateError] when askTrade fails',
      build: () {
        when(
          mockTradeRepository.askTrade(
            myTradeRequestData: anyNamed('myTradeRequestData'),
            otherTradeRequestData: anyNamed('otherTradeRequestData'),
          ),
        ).thenThrow(Exception('Trade failed'));
        return tradeBloc;
      },
      act:
          (bloc) => bloc.add(
            TradeEventAskTrade(
              myTradeRequestData: TradeRequestData(
                userId: 'userId',
                cardId: 'cardId',
                variantValue: VariantValue.normal,
              ),
              otherTradeRequestData: TradeRequestData(
                userId: 'otherUserId',
                cardId: 'otherCardId',
                variantValue: VariantValue.holo,
              ),
            ),
          ),
      expect: () => [isA<TradeStateLoading>(), isA<TradeStateError>()],
      verify: (_) {
        verify(
          mockTradeRepository.askTrade(
            myTradeRequestData: anyNamed('myTradeRequestData'),
            otherTradeRequestData: anyNamed('otherTradeRequestData'),
          ),
        ).called(1);
      },
    );
  });
}
