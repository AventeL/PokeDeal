part of 'discussion_bloc.dart';

class DiscussionEvent {}

class DiscussionEventGetDiscussionByTradeId extends DiscussionEvent {
  final String tradeId;

  DiscussionEventGetDiscussionByTradeId({required this.tradeId});
}
