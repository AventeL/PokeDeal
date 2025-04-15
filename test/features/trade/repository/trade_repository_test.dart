import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pokedeal/features/authentication/domain/models/user_profile.dart';
import 'package:pokedeal/features/trade/domain/models/trade.dart';
import 'package:pokedeal/features/trade/domain/models/user_stats.dart';
import 'package:pokedeal/features/trade/domain/repository/trade_repository.dart';

import '../../../mocks/generated_mocks.mocks.dart';

void main() {
  late MockITradeDataSource mockTradeDataSource;
  late TradeRepository tradeRepository;

  setUp(() {
    mockTradeDataSource = MockITradeDataSource();
    tradeRepository = TradeRepository(tradeDataSource: mockTradeDataSource);
  });

  group('TradeRepository Tests', () {
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
        status: 'En cours',
        timestamp: DateTime.now(),
      ),
    ];
    final mockTradesSend = [
      Trade(
        id: '2',
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
        status: 'En cours',
        timestamp: DateTime.now(),
      ),
    ];

    test('fetchAllUsers returns a list of all users on success', () async {
      when(
        mockTradeDataSource.getAllUser(),
      ).thenAnswer((_) async => mockFetchAllUsers);

      final result = await tradeRepository.getAllUser();

      expect(result, equals(mockFetchAllUsers));
      verify(mockTradeDataSource.getAllUser()).called(1);
    });

    test('fetchAllUsers throws an exception on failure', () async {
      when(
        mockTradeDataSource.getAllUser(),
      ).thenThrow(Exception('Failed to fetch trades'));

      expect(() => tradeRepository.getAllUser(), throwsException);
      verify(mockTradeDataSource.getAllUser()).called(1);
    });

    test('getSendTrade returns a list of trades on success', () async {
      when(
        mockTradeDataSource.getSendTrade(),
      ).thenAnswer((_) async => mockTradesSend);

      final result = await tradeRepository.getSendTrade();

      expect(result, equals(mockTradesSend));
      verify(mockTradeDataSource.getSendTrade()).called(1);
    });

    test('getSendTrade throws an exception on failure', () async {
      when(
        mockTradeDataSource.getSendTrade(),
      ).thenThrow(Exception('Failed to fetch send trades'));

      expect(() => tradeRepository.getSendTrade(), throwsException);
      verify(mockTradeDataSource.getSendTrade()).called(1);
    });

    test('getReceivedTrade returns a list of trades on success', () async {
      when(
        mockTradeDataSource.getReceivedTrade(),
      ).thenAnswer((_) async => mockTradesReceive);

      final result = await tradeRepository.getReceivedTrade();

      expect(result, equals(mockTradesReceive));
      verify(mockTradeDataSource.getReceivedTrade()).called(1);
    });

    test('getReceivedTrade throws an exception on failure', () async {
      when(
        mockTradeDataSource.getReceivedTrade(),
      ).thenThrow(Exception('Failed to fetch received trades'));

      expect(() => tradeRepository.getReceivedTrade(), throwsException);
      verify(mockTradeDataSource.getReceivedTrade()).called(1);
    });
  });
}
