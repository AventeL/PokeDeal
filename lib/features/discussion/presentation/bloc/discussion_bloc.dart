import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pokedeal/features/discussion/domain/model/discussion.dart';
import 'package:pokedeal/features/discussion/domain/model/message.dart';
import 'package:pokedeal/features/discussion/domain/repository/discussion_repository.dart';

part 'discussion_event.dart';
part 'discussion_state.dart';

class DiscussionBloc extends Bloc<DiscussionEvent, DiscussionState> {
  final DiscussionRepository discussionRepository;
  StreamSubscription<Message>? _subscription;

  DiscussionBloc({required this.discussionRepository})
    : super(DiscussionInitial()) {
    on<DiscussionEventGetDiscussionByTradeId>(onDiscussionGetByTradeId);
    on<DiscussionEventSendMessage>(onDiscussionSendMessage);
    on<DiscussionEventNewMessageReceived>(onNewMessageReceived);
    on<DiscussionEventSubscribeToMessages>(onDiscussionSubscribe);
    on<DiscussionEventUnsubscribeFromMessages>(onDiscussionUnsubscribe);
  }

  void onDiscussionSubscribe(
    DiscussionEventSubscribeToMessages event,
    Emitter<DiscussionState> emit,
  ) {
    _subscription?.cancel();
    _subscription = discussionRepository
        .subscribeToMessages(event.discussionId)
        .listen((message) {
          add(DiscussionEventNewMessageReceived(message: message));
        });
  }

  Future<void> onDiscussionGetByTradeId(
    DiscussionEventGetDiscussionByTradeId event,
    Emitter<DiscussionState> emit,
  ) async {
    emit(DiscussionStateLoading());
    try {
      final Discussion discussion = await discussionRepository
          .getDiscussionByTradeId(event.tradeId);
      emit(DiscussionStateDiscussionGet(discussion: discussion));
    } catch (e) {
      emit(DiscussionStateError(message: e.toString()));
    }
  }

  Future<void> onDiscussionSendMessage(
    DiscussionEventSendMessage event,
    Emitter<DiscussionState> emit,
  ) async {
    try {
      final currentState = state;
      emit(DiscussionStateLoadingMessage());
      final Message message = await discussionRepository.sendMessage(
        event.message,
      );
      if (currentState is DiscussionStateDiscussionGet) {
        final updatedMessages = List<Message>.from(
          currentState.discussion.messages,
        );
        if (!updatedMessages.any((msg) => msg.id == message.id)) {
          updatedMessages.insert(0, message);
        }

        final updatedDiscussion = currentState.discussion.copyWith(
          messages: updatedMessages,
        );

        emit(DiscussionStateDiscussionGet(discussion: updatedDiscussion));
      }
    } catch (e) {
      emit(DiscussionStateError(message: e.toString()));
    }
  }

  void onNewMessageReceived(
    DiscussionEventNewMessageReceived event,
    Emitter<DiscussionState> emit,
  ) {
    final currentState = state;
    if (currentState is DiscussionStateDiscussionGet) {
      final updatedMessages = List<Message>.from(
        currentState.discussion.messages,
      );
      if (!updatedMessages.any((msg) => msg.id == event.message.id)) {
        updatedMessages.insert(0, event.message);
      }

      final updatedDiscussion = currentState.discussion.copyWith(
        messages: updatedMessages,
      );

      emit(DiscussionStateDiscussionGet(discussion: updatedDiscussion));
    }
  }

  void onDiscussionUnsubscribe(
    DiscussionEventUnsubscribeFromMessages event,
    Emitter<DiscussionState> emit,
  ) {
    _subscription?.cancel();
    _subscription = null;
  }
}
