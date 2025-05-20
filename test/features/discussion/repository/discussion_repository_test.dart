import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pokedeal/features/discussion/domain/model/discussion.dart';
import 'package:pokedeal/features/discussion/domain/model/message.dart';
import 'package:pokedeal/features/discussion/domain/repository/discussion_repository.dart';

import '../../../mocks/generated_mocks.mocks.dart';

void main() {
  late MockIDiscussionDataSource mockDiscussionDataSource;
  late DiscussionRepository discussionRepository;

  setUp(() {
    mockDiscussionDataSource = MockIDiscussionDataSource();
    discussionRepository = DiscussionRepository(
      discussionDataSource: mockDiscussionDataSource,
    );
  });

  group('DiscussionRepository Tests', () {
    final discussion = Discussion(id: 'disc1', tradeId: 'trade1', messages: []);

    final message = Message(
      id: 'msg1',
      discussionId: 'disc1',
      senderId: 'user1',
      content: 'Hello',
      sendAt: DateTime.now(),
      type: MessageType.normal,
    );

    test('getDiscussionByTradeId returns Discussion on success', () async {
      when(
        mockDiscussionDataSource.getDiscussionByTradeId('trade1'),
      ).thenAnswer((_) async => discussion);

      final result = await discussionRepository.getDiscussionByTradeId(
        'trade1',
      );

      expect(result, equals(discussion));
      verify(
        mockDiscussionDataSource.getDiscussionByTradeId('trade1'),
      ).called(1);
    });

    test('getDiscussionByTradeId throws exception on failure', () async {
      when(
        mockDiscussionDataSource.getDiscussionByTradeId('trade1'),
      ).thenThrow(Exception('Failed to get discussion'));

      expect(
        () => discussionRepository.getDiscussionByTradeId('trade1'),
        throwsException,
      );
      verify(
        mockDiscussionDataSource.getDiscussionByTradeId('trade1'),
      ).called(1);
    });

    test('sendMessage returns Message on success', () async {
      when(
        mockDiscussionDataSource.sendMessage(message),
      ).thenAnswer((_) async => message);

      final result = await discussionRepository.sendMessage(message);

      expect(result, equals(message));
      verify(mockDiscussionDataSource.sendMessage(message)).called(1);
    });

    test('sendMessage throws exception on failure', () async {
      when(
        mockDiscussionDataSource.sendMessage(message),
      ).thenThrow(Exception('Failed to send message'));

      expect(() => discussionRepository.sendMessage(message), throwsException);
      verify(mockDiscussionDataSource.sendMessage(message)).called(1);
    });

    test('subscribeToMessages returns Stream<Message>', () {
      final streamController = Stream<Message>.empty();

      when(
        mockDiscussionDataSource.subscribeToMessages('disc1'),
      ).thenAnswer((_) => streamController);

      final stream = discussionRepository.subscribeToMessages('disc1');

      expect(stream, isA<Stream<Message>>());
      verify(mockDiscussionDataSource.subscribeToMessages('disc1')).called(1);
    });
  });
}
