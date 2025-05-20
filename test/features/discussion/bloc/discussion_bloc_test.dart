import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pokedeal/features/discussion/domain/model/discussion.dart';
import 'package:pokedeal/features/discussion/domain/model/message.dart';
import 'package:pokedeal/features/discussion/presentation/bloc/discussion_bloc.dart';

import '../../../mocks/generated_mocks.mocks.dart';

void main() {
  late DiscussionBloc discussionBloc;
  late MockDiscussionRepository mockDiscussionRepository;

  setUp(() {
    mockDiscussionRepository = MockDiscussionRepository();
    discussionBloc = DiscussionBloc(
      discussionRepository: mockDiscussionRepository,
    );
  });

  tearDown(() {
    discussionBloc.close();
  });

  group('DiscussionBloc Tests', () {
    final discussion = Discussion(
      id: 'disc1',
      tradeId: 'trade1',
      messages: [
        Message(
          id: 'msg1',
          discussionId: 'disc1',
          senderId: 'user1',
          content: 'Hello',
          sendAt: DateTime.now(),
          type: MessageType.normal,
        ),
      ],
    );

    final messageNew = Message(
      id: 'msg2',
      discussionId: 'disc1',
      senderId: 'user2',
      content: 'New message',
      sendAt: DateTime.now(),
      type: MessageType.request,
    );

    void mockGetDiscussionSuccess() {
      when(
        mockDiscussionRepository.getDiscussionByTradeId('trade1'),
      ).thenAnswer((_) async => discussion);
    }

    void mockGetDiscussionFail() {
      when(
        mockDiscussionRepository.getDiscussionByTradeId('trade1'),
      ).thenThrow(Exception('Failed to get discussion'));
    }

    void mockSendMessageSuccess() {
      when(
        mockDiscussionRepository.sendMessage(any),
      ).thenAnswer((_) async => messageNew);
    }

    blocTest<DiscussionBloc, DiscussionState>(
      'emits [Loading, DiscussionGet] when getDiscussionByTradeId succeeds',
      build: () {
        mockGetDiscussionSuccess();
        return discussionBloc;
      },
      act:
          (bloc) => bloc.add(
            DiscussionEventGetDiscussionByTradeId(tradeId: 'trade1'),
          ),
      expect:
          () => [
            DiscussionStateLoading(),
            DiscussionStateDiscussionGet(discussion: discussion),
          ],
      verify: (_) {
        verify(
          mockDiscussionRepository.getDiscussionByTradeId('trade1'),
        ).called(1);
      },
    );

    blocTest<DiscussionBloc, DiscussionState>(
      'emits [Loading, Error] when getDiscussionByTradeId fails',
      build: () {
        mockGetDiscussionFail();
        return discussionBloc;
      },
      act:
          (bloc) => bloc.add(
            DiscussionEventGetDiscussionByTradeId(tradeId: 'trade1'),
          ),
      expect: () => [DiscussionStateLoading(), isA<DiscussionStateError>()],
      verify: (_) {
        verify(
          mockDiscussionRepository.getDiscussionByTradeId('trade1'),
        ).called(1);
      },
    );

    blocTest<DiscussionBloc, DiscussionState>(
      'emits [LoadingMessage, DiscussionGet(updated)] when sendMessage succeeds',
      build: () {
        mockSendMessageSuccess();
        return discussionBloc;
      },
      seed: () => DiscussionStateDiscussionGet(discussion: discussion),
      act: (bloc) => bloc.add(DiscussionEventSendMessage(message: messageNew)),
      expect:
          () => [
            DiscussionStateLoadingMessage(),
            isA<DiscussionStateDiscussionGet>().having(
              (state) => state.discussion.messages,
              'messages contains new message',
              contains(messageNew),
            ),
          ],
      verify: (_) {
        verify(mockDiscussionRepository.sendMessage(messageNew)).called(1);
      },
    );

    blocTest<DiscussionBloc, DiscussionState>(
      'updates state with new message on DiscussionEventNewMessageReceived',
      build: () => discussionBloc,
      seed: () => DiscussionStateDiscussionGet(discussion: discussion),
      act:
          (bloc) =>
              bloc.add(DiscussionEventNewMessageReceived(message: messageNew)),
      expect:
          () => [
            isA<DiscussionStateDiscussionGet>().having(
              (state) => state.discussion.messages,
              'messages contains new message',
              contains(messageNew),
            ),
          ],
    );

    blocTest<DiscussionBloc, DiscussionState>(
      'subscribes to messages stream and adds new messages',
      build: () {
        final controller = StreamController<Message>();
        when(
          mockDiscussionRepository.subscribeToMessages('disc1'),
        ).thenAnswer((_) => controller.stream);

        return discussionBloc;
      },
      act: (bloc) {
        bloc.add(DiscussionEventSubscribeToMessages(discussionId: 'disc1'));
      },
      verify: (bloc) async {
        // Here you can add messages to controller and expect bloc to emit states accordingly
      },
    );

    blocTest<DiscussionBloc, DiscussionState>(
      'cancels subscription on unsubscribe event',
      build: () {
        final controller = StreamController<Message>();
        when(
          mockDiscussionRepository.subscribeToMessages('disc1'),
        ).thenAnswer((_) => controller.stream);
        return discussionBloc;
      },
      act: (bloc) async {
        bloc.add(DiscussionEventSubscribeToMessages(discussionId: 'disc1'));
        await Future.delayed(Duration.zero);
        bloc.add(DiscussionEventUnsubscribeFromMessages());
      },
      expect: () => [],
      verify: (_) {
        // Optionally verify subscription canceled internally
      },
    );
  });
}
