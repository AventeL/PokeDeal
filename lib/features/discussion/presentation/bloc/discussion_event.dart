part of 'discussion_bloc.dart';

class DiscussionEvent {}

class DiscussionEventGetDiscussionByTradeId extends DiscussionEvent {
  final String tradeId;

  DiscussionEventGetDiscussionByTradeId({required this.tradeId});
}

class DiscussionEventSendMessage extends DiscussionEvent {
  final Message message;

  DiscussionEventSendMessage({required this.message});
}

class DiscussionEventSubscribeToMessages extends DiscussionEvent {
  final String discussionId;

  DiscussionEventSubscribeToMessages({required this.discussionId});
}

class DiscussionEventUnsubscribeFromMessages extends DiscussionEvent {
  DiscussionEventUnsubscribeFromMessages();
}

class DiscussionEventNewMessageReceived extends DiscussionEvent {
  final Message message;

  DiscussionEventNewMessageReceived({required this.message});
}
